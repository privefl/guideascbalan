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

Pour calculer la VMA en fonction de la durée du test, il suffit d'appliquer la formule suivante : `VMA = (min + sec / 60) / 2 + 7.5` $\left(\text{VMA} = \frac{\text{min} + \frac{\text{sec}}{60}}{2} + 7.5\right)$. Par exemple, lors du test VMA du 08/10/24, j'ai tenu 19 minutes et 32 secondes, ce qui me donne une VMA de 17.27. Quand au test du 02/10/25, 20 min et 32 sec, pour une VMA de 17.77.


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

> `FC cible = FC repos + pourcentage * FCR`

<label for="fcMaxInput">FC maximale :</label>
<input type="number" id="fcMaxInput" value="185" step="1" size="3">

<label for="fcRestInput">FC au repos :</label>
<input type="number" id="fcRestInput" value="51" step="1" size="2">

<div style="overflow-x: auto; max-width: 100%; margin-top: 10px;">
<table style="border-collapse: collapse; width: 100%; text-align: center; font-family: sans-serif;">
  <thead>
    <tr style="background-color: #f0f0f0;">
      <th style="border: 1px solid #ccc; padding: 6px;">Zone</th>
      <th style="border: 1px solid #ccc; padding: 6px;">% FCM (% FCR)</th>
      <th style="border: 1px solid #ccc; padding: 6px;">Objectif</th>
      <th style="border: 1px solid #ccc; padding: 6px;">Intervalle FC (bpm)</th>
    </tr>
  </thead>
  <tbody id="fcResultsBody"></tbody>
</table>
</div>

<script>
const zones = [
  { nom: "Zone 1", minPct: 0.50, maxPct: 0.60, objectif: "Récupération active" },
  { nom: "Zone 2", minPct: 0.60, maxPct: 0.70, objectif: "Endurance fondamentale" },
  { nom: "Zone 3", minPct: 0.70, maxPct: 0.80, objectif: "Endurance active" },
  { nom: "Zone 4", minPct: 0.80, maxPct: 0.90, objectif: "Résistance douce" },
  { nom: "Zone 5", minPct: 0.90, maxPct: 1.00, objectif: "Résistance dure / VMA" }
];

function updateFCTable(fcMax, fcRest) {
  const tbody = document.getElementById("fcResultsBody");
  tbody.innerHTML = "";

  const fcr = fcMax - fcRest; // Fréquence cardiaque de réserve

  zones.forEach(zone => {
    const minFC = Math.ceil(fcRest + zone.minPct * fcr);
    const maxFC = Math.floor(fcRest + zone.maxPct * fcr);

    const row = `<tr>
      <td style="border: 1px solid #ccc; padding: 6px;">${zone.nom}</td>
      <td style="border: 1px solid #ccc; padding: 6px;">${Math.round(zone.minPct*100)}–${Math.round(zone.maxPct*100)}%</td>
      <td style="border: 1px solid #ccc; padding: 6px;">${zone.objectif}</td>
      <td style="border: 1px solid #ccc; padding: 6px;">${minFC}–${maxFC}</td>
    </tr>`;
    tbody.insertAdjacentHTML("beforeend", row);
  });
}

// Initialisation
updateFCTable(
  parseInt(document.getElementById("fcMaxInput").value),
  parseInt(document.getElementById("fcRestInput").value)
);

// Mise à jour en temps réel
document.getElementById("fcMaxInput").addEventListener("input", () => {
  updateFCTable(
    parseInt(document.getElementById("fcMaxInput").value),
    parseInt(document.getElementById("fcRestInput").value)
  );
});
document.getElementById("fcRestInput").addEventListener("input", () => {
  updateFCTable(
    parseInt(document.getElementById("fcMaxInput").value),
    parseInt(document.getElementById("fcRestInput").value)
  );
});
</script>


### Modifier ses zones de FC dans Garmin Connect {-}

Pour ajuster vos calculs de zones cardiaques à partir de la fréquence cardiaque de réserve (FCR) plutôt que de la fréquence cardiaque maximale (FCM), il est important que votre montre Garmin connaisse vos valeurs réelles de FC max et FC au repos.

1. Ouvrez Garmin Connect sur votre smartphone

2. Dans le menu Plus (☰), sélectionnez Appareils Garmin → Votre montre → Paramètres utilisateur → Zones de fréquence cardiaque

3. Sélectionnez "à partir de réserve de FC en pourcentage"

4. Renseignez la FC au repos, la FC max, et les différents pourcentages (50, 60, 70, 80, 90)


## Comment les utiliser dans votre entraînement ? {-}

Pour maximiser vos performances, il est essentiel de comprendre comment utiliser la VMA et la FCM dans votre programme d'entraînement :

- **Séances basées sur la VMA** :
Utilisez votre VMA pour planifier vos entraînements en définissant des allures spécifiques pour le fractionné (cf. prochaine partie).

- **Contrôle de l'intensité avec la FCM** :
Surveillez votre fréquence cardiaque (pendant les séances ou après coup) pour vous assurer que vous travaillez dans la zone d'intensité souhaitée, permettant ainsi une meilleure gestion de l'effort.

En intégrant ces deux mesures dans votre entraînement,
vous serez en mesure d'améliorer vos performances de manière plus ciblée et efficace.

Une troisième mesure utile à surveiller est le ressenti d'effort, ou RPE (Rate of Perceived Exertion), noté de 1 (effort très facile) à 10 (effort maximal). Personnellement, je dépasse rarement 7,5. Le but n'est pas de finir chaque séance vidé, les jambes en feu, et de devoir récupérer pendant 10 jours, mais plutôt de pouvoir enchaîner les entraînements régulièrement et progresser sans s'épuiser.
