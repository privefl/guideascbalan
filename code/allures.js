// Pace calculators for types.Rmd: race predictions (VMA + endurance index)
// and interval paces (% VMA). Both VMA inputs stay in sync.
(function () {
  "use strict";

  // Level 3 = the previous Campus-based estimates (speed = exp(a) * VMA^1.08, a per distance).
  // Other levels shift the endurance index (Peronnet & Thibault, %VMA varies by IE * ln(t / 7))
  // relative to level 3, whose index is about -7.5.
  const IE_REF = -7.5;
  const LEVELS = { 1: -10, 2: -9, 3: -7.5, 4: -6.5, 5: -5 };
  const IE_MIN = -13, IE_MAX = -3;
  const EXPONENT = 1.08;

  const RACES = [
    { name: "5 km", distance: 5, a: -0.3275719 },
    { name: "10 km", distance: 10, a: -0.3830789 },
    { name: "Semi-marathon", distance: 21.0975, a: -0.4427105 },
    { name: "Marathon", distance: 42.195, a: -0.53 }
  ];
  const SEUIL_REF = 0.83186;  // fraction of VMA held for 60 min at level 3

  const INTERVALS = [
    { distance: 0.200, pourcent: 105, totalMinutes: 12 },
    { distance: 0.300, pourcent: 102, totalMinutes: 14 },
    { distance: 0.400, pourcent: 100, totalMinutes: 16 },
    { distance: 0.500, pourcent: 98,  totalMinutes: 18 },
    { distance: 1.000, pourcent: 92,  totalMinutes: 24 }
  ];

  const CELL = 'style="border: 1px solid #ccc; padding: 6px;"';
  const $ = (id) => document.getElementById(id);
  const fr = (x, digits) => x.toFixed(digits).replace(".", ",").replace("-", "\u2212");

  // race speed (km/h) for an endurance index ie: Campus speed at level 3, shifted by
  // (ie - IE_REF) * ln(t / 7) % of VMA; t depends on the speed, so iterate (fast convergence)
  function raceSpeed(vma, ie, race) {
    const base = Math.exp(race.a + EXPONENT * Math.log(vma));
    let speed = base;
    for (let i = 0; i < 50; i++) {
      const tMin = (race.distance / speed) * 60;
      speed = base + vma * (ie - IE_REF) * Math.log(tMin / 7) / 100;
    }
    return speed;
  }

  function seuilSpeed(vma, ie) {
    return vma * (SEUIL_REF + (ie - IE_REF) * Math.log(60 / 7) / 100);
  }

  function speedToPace(speed) {
    const s = Math.round(3600 / speed);
    return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
  }

  function formatDuration(totalSeconds) {
    const s = Math.round(totalSeconds);
    const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60), sec = s % 60;
    const mmss = `${String(m).padStart(2, "0")}:${String(sec).padStart(2, "0")}`;
    return h > 0 ? `${h}:${mmss}` : mmss;
  }

  // "45:30", "1:39:00", "1h39", "1h39'00", "40'14" or "40min14" -> minutes (NaN if invalid)
  function parseChrono(txt) {
    const norm = String(txt).toLowerCase().replace(/\s+/g, "")
      .replace(/''|"|s$/g, "").replace(/min|h|'|m/g, ":").replace(/:$/, "");
    const parts = norm.split(":").map(Number);
    if (parts.length < 2 || parts.length > 3 || parts.some((x) => !Number.isFinite(x) || x < 0)) return NaN;
    const [h, m, s] = parts.length === 3 ? parts : [0, ...parts];
    return h * 60 + m + s / 60;
  }

  // endurance index from a recent race: { ie } or { error }
  // (the index for which the predicted time of that race equals the actual time)
  function indexFromRace(vma) {
    const distance = parseFloat($("courseDist").value);
    const tMin = parseChrono($("courseChrono").value);
    if (!(distance > 0)) return { error: "choisissez la distance de la course" };
    if (!(tMin > 0)) return { error: "chrono non reconnu (exemples : 40:14 ou 1:23:48)" };
    const race = RACES.find((r) => Math.abs(r.distance - distance) < 1e-6);
    const target = (distance / tMin) * 60;
    if (target >= vma) return { error: "ce chrono est plus rapide que votre VMA : vérifiez la VMA ou le chrono" };
    // predicted speed increases with ie: bisection
    let lo = IE_MIN, hi = IE_MAX;
    if (raceSpeed(vma, lo, race) > target || raceSpeed(vma, hi, race) < target)
      return { error: "chrono trop éloigné de ce que donne votre VMA : vérifiez la VMA ou le chrono" };
    for (let i = 0; i < 60; i++) {
      const mid = (lo + hi) / 2;
      if (raceSpeed(vma, mid, race) < target) lo = mid; else hi = mid;
    }
    return { ie: (lo + hi) / 2 };
  }

  // slider position (1 to 5) <-> endurance index, piecewise linear between LEVELS
  const KEYS = [1, 2, 3, 4, 5];
  function levelToIe(x) {
    const i = Math.min(3, Math.max(0, Math.floor(x) - 1));
    return LEVELS[KEYS[i]] + (x - KEYS[i]) * (LEVELS[KEYS[i + 1]] - LEVELS[KEYS[i]]);
  }
  function ieToLevel(ie) {
    for (let i = 0; i < 4; i++) {
      const a = LEVELS[KEYS[i]], b = LEVELS[KEYS[i + 1]];
      if (ie <= b || i === 3) return KEYS[i] + (ie - a) / (b - a);
    }
  }

  function row(cells) {
    return `<tr>${cells.map((c) => `<td ${CELL}>${c}</td>`).join("")}</tr>`;
  }

  function updateRaces(vma) {
    const useRace = $("modeCourse").checked;
    const slider = $("niveauInput");
    $("blocCourse").style.display = useRace ? "" : "none";
    let ie = levelToIe(parseFloat(slider.value)), msg, color = "#1a7f37";
    slider.disabled = false;
    if (useRace) {
      const r = indexFromRace(vma);
      if (r.error) {
        msg = `Course non utilisée : ${r.error}. En attendant, calcul avec le curseur.`;
        color = "#b42318";
      } else {
        ie = r.ie;
        const lvl = ieToLevel(ie);
        slider.value = Math.min(5, Math.max(1, lvl));
        slider.disabled = true;
        const pos = lvl < 1 ? "moins de 1" : lvl > 5 ? "plus de 5" : fr(lvl, 1);
        msg = `Calcul basé sur votre course : résistance <b>${pos}</b> sur 5 (indice d'endurance ${fr(ie, 1)}).`;
      }
    } else {
      msg = `Calcul basé sur le curseur : résistance <b>${fr(parseFloat(slider.value), 1)}</b> sur 5 (indice d'endurance ${fr(ie, 1)}).`;
    }
    $("niveauVal").textContent = fr(parseFloat(slider.value), 1);
    const info = $("ieInfo");
    info.innerHTML = msg;
    info.style.borderLeft = `4px solid ${color}`;
    info.style.paddingLeft = "10px";

    const rows = RACES.map((race) => {
      const { name, distance } = race;
      const speed = raceSpeed(vma, ie, race);
      return row([name, fr(speed, 2), speedToPace(speed), `${fr(100 * speed / vma, 1)} %`,
                  formatDuration((distance / speed) * 3600)]);
    });
    const vSeuil = seuilSpeed(vma, ie);
    rows.push(row(["Seuil (60 min)", fr(vSeuil, 2), speedToPace(vSeuil),
                   `${fr(100 * vSeuil / vma, 1)} %`, "1:00:00"]));
    $("resultsBody").innerHTML = rows.join("");
  }

  function updateIntervals(vma) {
    $("vmaResultsBody").innerHTML = INTERVALS.map(({ distance, pourcent, totalMinutes }) => {
      const speed = vma * pourcent / 100;
      const timeMin = (distance / speed) * 60;
      let m = Math.floor(timeMin), s = Math.round((timeMin - m) * 60);
      if (s === 60) { s = 0; m += 1; }
      const time = m === 0 ? `${s} sec` : `${m} min ${s} sec`;
      return row([`${Math.round(distance * 1000)} m`, `${pourcent}%`, `${totalMinutes} min`,
                  speedToPace(speed), time, `x ${fr(totalMinutes / timeMin, 1)}`]);
    }).join("");
  }

  function updateAll(source) {
    const inputs = [$("vmaInput1"), $("vmaInput2")];
    if (source) inputs.forEach((el) => { if (el !== source) el.value = source.value; });
    const vma = parseFloat(inputs[0].value);
    if (!(vma > 0)) return;
    updateRaces(vma);
    updateIntervals(vma);
  }

  ["vmaInput1", "vmaInput2"].forEach((id) => $(id).addEventListener("input", (e) => updateAll(e.target)));
  // default mode, even if the browser restored an odd form state
  if (!$("modeNiveau").checked && !$("modeCourse").checked) $("modeNiveau").checked = true;
  $("niveauInput").addEventListener("input", () => updateAll());
  ["modeNiveau", "modeCourse"].forEach((id) => $(id).addEventListener("change", () => updateAll()));
  // typing a race switches to race mode
  ["courseDist", "courseChrono"].forEach((id) => ["input", "change"].forEach((ev) =>
    $(id).addEventListener(ev, () => { $("modeCourse").checked = true; updateAll(); })));
  updateAll();
})();
