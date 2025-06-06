---
output: html_document
editor_options: 
  chunk_output_type: console
---


# VMA et FCM : Comprendre les fondamentaux {-}

Dans le cadre de l'entraînement en course à pied, deux concepts clés sont souvent évoqués :
la Vitesse Maximale Aérobie (VMA) et la Fréquence Cardiaque Maximale (FCM).
Comprendre ces notions est essentiel pour structurer vos séances d'entraînement efficacement.

## Qu'est-ce que la VMA ? {-}

La VMA est la vitesse à laquelle un coureur utilise le maximum d'oxygène que son corps peut consommer pendant l'effort (VO2max en mL/min/kg).
Pour en savoir plus sur la VO2max, regardez [cette vidéo](https://www.youtube.com/watch?v=MIVSIIvEhj0).
Elle est souvent considérée comme un bon indicateur de la performance aérobie d'un coureur (sa capacité à utiliser efficacement l'oxygène pendant un effort prolongé).
La VMA est généralement mesurée en km/h et peut être déterminée par des tests spécifiques (cf. la section [Test VMA du club](#testvma)).

### Pourquoi est-elle importante ? {-}

- **Détermination des allures d'entraînement** :
La VMA permet de définir des intensités d'entraînement précises, notamment pour les séances de fractionnés (cf. prochaine partie sur les types d'entraînements).

- **Suivi des progrès** :
En mesurant la VMA régulièrement, vous pouvez évaluer votre progression au fil du temps
et ajuster votre programme d'entraînement en conséquence.

### Test VMA du club {-#testvma}

Les entraîneurs organisent en moyenne deux tests VMA par an.
On utilise le test VAMEVAL. C'est un test qui fonctionne par paliers de vitesse croissante.
Ce test utilise une bande son comme [celle-ci](https://www.irbms.com/wp-content/uploads/2023/06/bande-son-1979-test-luc-leger.mp3) ; il suffit d'être au niveau du prochain plot (espacés de 20 mètres) à chaque bip sonore ; quand le coureur se retrouve à plus de 2 mètres d'un plot car il est à bout de forces, il doit s'arrêter.
Ce test est facile à mettre en place, il ne nécessite pas d'échauffement, et donne une estimation fiable de la VMA même pour des coureurs qui n'ont aucune idée de leur niveau actuel.

Pour calculer la VMA en fonction de la durée du test, il suffit d'appliquer la formule suivante : `VMA = (min + sec / 60) / 2 + 7.5` \(\left(\text{VMA} = \frac{\text{min} + \frac{\text{sec}}{60}}{2} + 7.5\right)\). Par exemple, lors du test VMA du 08/10/24, j'ai tenu 19 minutes et 32 secondes, ce qui me donne une VMA de 17.27.


### Estimation des vitesses et temps de course {-#vitesseVMA}

<label for="masInput">Entrez la VMA (km/h) : </label>
<input type="number" id="masInput" value="15" step="0.1" oninput="updateTable()">

<table style="margin-top: 10px; border-collapse: collapse; width: 80%; text-align: center; font-family: sans-serif;">
  <thead>
    <tr style="background-color: #f0f0f0;">
      <th style="border: 1px solid #ccc; padding: 6px;">Course</th>
      <th style="border: 1px solid #ccc; padding: 6px;">Vitesse estimée<br>(km/h)</th>
      <th style="border: 1px solid #ccc; padding: 6px;">Allure estimée<br>(min/km)</th>
      <th style="border: 1px solid #ccc; padding: 6px;">Temps estimé total</th>
    </tr>
  </thead>
  <tbody id="resultsBody">
    <!-- Lignes générées dynamiquement -->
  </tbody>
</table>

<script>
const courses = {
  "5 km":          { a: -0.3275719, distance: 5 },
  "10 km":         { a: -0.3830789, distance: 10 },
  "Semi-marathon": { a: -0.4427105, distance: 21.097 },
  "Marathon":      { a: -0.5709523, distance: 42.195 }
};

const exponent = 1.08;

function computeSpeed(vma, a) {
  return Math.exp(a + exponent * Math.log(vma));
}

function speedToPace(speed) {
  const pace = 60 / speed;
  const min = Math.floor(pace);
  const sec = Math.round((pace - min) * 60);
  return `${min}:${sec.toString().padStart(2, '0')}`;
}

function timeFromSpeed(distance, speed) {
  const totalMinutes = (distance / speed) * 60;
  let h = Math.floor(totalMinutes / 60);
  let m = Math.floor(totalMinutes % 60);
  let s = Math.round((totalMinutes - h * 60 - m) * 60);
  if (s === 60) {
    s = 0;
    m += 1;
    if (m === 60) {
      m = 0;
      h += 1;
    }
  }
  return `${h}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
}

function updateTable() {
  const vma = parseFloat(document.getElementById("masInput").value);
  const tbody = document.getElementById("resultsBody");
  tbody.innerHTML = "";

  for (const [course, { a, distance }] of Object.entries(courses)) {
    const vitesse = computeSpeed(vma, a);
    const allure = speedToPace(vitesse);
    const tempsTotal = timeFromSpeed(distance, vitesse);

    const row = `<tr>
                   <td style="border: 1px solid #ccc; padding: 6px;">${course}</td>
                   <td style="border: 1px solid #ccc; padding: 6px;">${vitesse.toFixed(2)}</td>
                   <td style="border: 1px solid #ccc; padding: 6px;">${allure}</td>
                   <td style="border: 1px solid #ccc; padding: 6px;">${tempsTotal}</td>
                 </tr>`;
    tbody.insertAdjacentHTML("beforeend", row);
  }
}

updateTable();
</script>

Ce sont des estimations moyennes données sur [Campus](https://www.campus.coach/calculateur/vma), donc avec une marge d'erreur, mais ça devrait déjà donner une bonne idée.


## Qu'est-ce que la FCM ? {-}

La Fréquence Cardiaque Maximale (FCM) est le nombre maximum de battements par minute (bpm) que votre cœur peut atteindre lors d'un effort maximal.
La FCM diminue avec l'âge, mais les formules comme `FCM = 220 - âge` sont trop générales ; c'est très variable d'un coureur à l'autre. 
Les montres de course modernes arrivent à l'estimer lors des efforts intenses.
Pour aller plus loin sur la fréquence cardiaque, regardez [cette vidéo](https://www.youtube.com/watch?v=c7f2gWekBXE).

### Pourquoi est-elle importante ? {-}

- **Évaluation de l'intensité** :
La FCM est utilisée pour définir des zones de fréquence cardiaque qui guident les coureurs dans l'intensité de leurs entraînements 
(cf. prochaine partie sur les types d'entraînements).

- **Prévention des blessures** :
Travailler dans des zones de fréquence cardiaque appropriées aide à éviter le surentraînement et réduit le risque de blessures.

### Les zones de fréquence cardiaque {-}

Pour structurer efficacement vos séances en utilisant votre cœur comme indicateur d'intensité, on parle souvent de **zones de fréquence cardiaque**. On en parle souvent en pourcentage de la FCM par abus de langage, mais en fait il faudrait plutôt parler de pourcentage de la **Fréquence Cardiaque de Réserve (FCR)**, qui tient aussi compte de votre fréquence cardiaque au repos.

La **FCR** se calcule ainsi :

> `FCR = FCM - FC au repos`

Une fois la FCR connue, on peut calculer une fréquence cible pour une intensité donnée :

> `FC cible = FC repos + (pourcentage * FCR)`

Par exemple, pour travailler à 70% de votre capacité :

> `FC cible = FC repos + 0.70 × (FCM - FC repos)`

Mon exemple :

- FC au repos : 51 bpm
- FCM : 188 bpm
- FCR = 188 - 51 = 137
- Zone à 60–70% : 51 + (% × 137) = 140 [133–147] bpm

Zones indicatives :

| Zone   | % FCM (% FCR) | Objectif principal       |
|:-------|:--------------|:-------------------------|
| Zone 1 | 50–60%        | Récupération active      |
| Zone 2 | 60–70%        | Endurance fondamentale   |
| Zone 3 | 70–80%        | Endurance active         |
| Zone 4 | 80–90%        | Résistance douce         |
| Zone 5 | 90–100%       | Résistance dure / VMA    |


## Comment les utiliser dans votre entraînement ? {-}

Pour maximiser vos performances, il est essentiel de comprendre comment utiliser la VMA et la FCM dans votre programme d'entraînement :

- **Séances basées sur la VMA** :
Utilisez votre VMA pour planifier vos entraînements en définissant des allures spécifiques pour le fractionné.

- **Contrôle de l'intensité avec la FCM** :
Surveillez votre fréquence cardiaque pendant les séances pour vous assurer que vous travaillez dans
la zone d'intensité souhaitée, permettant ainsi une meilleure gestion de l'effort.

En intégrant ces deux mesures dans votre entraînement,
vous serez en mesure d'améliorer vos performances de manière plus ciblée et efficace.
