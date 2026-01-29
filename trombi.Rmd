---
output: html_document
editor_options: 
  chunk_output_type: console
---

# Trombinoscope {-}

C'est plus sympa de savoir qui est qui, et d'appeler les gens par leur prénom, alors voici la tête de nos licenciés :

<div id="loader" style="text-align: center; padding: 20px; color: #666;">Chargement des photos...</div>
<div id="photos" style="display: flex; flex-wrap: wrap; justify-content: center; align-content: flex-start;"></div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Configuration
    const owner = "privefl";
    const repo = "guideascbalan";
    const path = "trombi";

    // URL de l'API GitHub pour lister le contenu du dossier
    const apiUrl = `https://api.github.com/repos/${owner}/${repo}/contents/${path}`;

    fetch(apiUrl)
        .then(response => {
            if (!response.ok) throw new Error("Erreur API GitHub (Limite atteinte ou dossier introuvable)");
            return response.json();
        })
        .then(data => {
            const container = document.getElementById('photos');
            const loader = document.getElementById('loader');

            // 1. On filtre pour ne garder que les images PNG
            const images = data.filter(file => file.name.match(/\.png$/i));

            // Note : L'API ne donne pas la date de modification facilement.
            // Les images seront donc triées par ordre alphabétique par défaut.

            if (images.length === 0) {
                loader.innerHTML = "Aucune photo trouvée.";
                return;
            }

            // 2. On génère le HTML pour chaque image
            images.forEach(file => {
                // Analyse du nom de fichier : Prenom_Nom.png
                // On retire l'extension et on sépare au niveau du tiret bas
                const filename = file.name.replace(/\.png$/i, '');
                const parts = filename.split('_');

                let prenom = "";
                let nom = "";

                if (parts.length >= 2) {
                    prenom = capitalize(parts[0]);
                    nom = capitalize(parts[1]);
                } else {
                    // Si le fichier est mal nommé, on met tout dans le prénom
                    prenom = capitalize(filename);
                }

                // Création de la carte (Basé sur votre style Rmd)
                const card = document.createElement('div');
                card.style.cssText = `
                    flex: 1 1 85px;
                    height: 190px;
                    margin: 5px;
                    text-align: center;
                    vertical-align: top;
                `;

                card.innerHTML = `
                    <img src="${file.download_url}" alt="${prenom} ${nom}" style="width:100%; max-width:95px; border-radius:8px; cursor: pointer;" loading="lazy">
                    <br>
                    <div style="height:70px; overflow:hidden; line-height:1.3em; font-size: 0.9em; margin-top:5px;">
                        <strong>${prenom}</strong><br>${nom}
                    </div>
                `;

                container.appendChild(card);
            });

            loader.style.display = 'none';
        })
        .catch(error => {
            document.getElementById('loader').innerHTML = "⚠️ Impossible de charger les photos (limite API ou erreur réseau).";
            console.error(error);
        });

    // Petite fonction utilitaire pour mettre la 1ère lettre en majuscule (Title Case)
    function capitalize(str) {
        return str.toLowerCase().replace(/(?:^|\s|-)\S/g, function(a) { return a.toUpperCase(); });
    }
});
</script>
