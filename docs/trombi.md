---
output: html_document
editor_options: 
  chunk_output_type: console
---

# Trombinoscope {-}

C'est plus sympa de savoir qui est qui, et d'appeler les gens par leur prénom, alors voici la tête de nos licenciés :

<!-- <br> -->

<div style='display: flex; flex-wrap: wrap; justify-content: center; align-content: flex-start;'>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Chrystelle_Bonnot.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Chrystelle</strong><br>Bonnot</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Stéphane_Faure.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Stéphane</strong><br>Faure</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Christine_Perdrix.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Christine</strong><br>Perdrix</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Benoit_Falelavaki.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Benoit</strong><br>Falelavaki</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Christelle_Frezza.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Christelle</strong><br>Frezza</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Julien_Gondin.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Julien</strong><br>Gondin</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Céline_Salmon.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Céline</strong><br>Salmon</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Didier_Salmon.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Didier</strong><br>Salmon</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Dominique_Noca.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Dominique</strong><br>Noca</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/David_Levent.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>David</strong><br>Levent</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/hélène_ansel.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Hélène</strong><br>Ansel</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Chalore_Teepakorn.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Chalore</strong><br>Teepakorn</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Héloïse_Blanc.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Héloïse</strong><br>Blanc</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Grégoire_Sage.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Grégoire</strong><br>Sage</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Cécile_Gréa.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Cécile</strong><br>Gréa</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Rémi_Pasquet.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Rémi</strong><br>Pasquet</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Frédéric_RICHIR.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Frédéric</strong><br>Richir</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Jean-Michel_Halet.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Jean-Michel</strong><br>Halet</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Cécile_Chassy.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Cécile</strong><br>Chassy</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Jean-Louis_PERDRIX.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Jean-Louis</strong><br>Perdrix</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Nathalie_MECHREGUI.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Nathalie</strong><br>Mechregui</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Olivier_Laplante.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Olivier</strong><br>Laplante</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Tamimount_Le Mée.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Tamimount</strong><br>Le Mée</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Raphaël_Richard.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Raphaël</strong><br>Richard</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Emmanuel (Manu)_Jaillardon.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Emmanuel (Manu)</strong><br>Jaillardon</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Lisa-Maëva_Aïssaoui.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Lisa-Maëva</strong><br>Aïssaoui</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Adrien_Gaillard.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Adrien</strong><br>Gaillard</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/line_philippon.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Line</strong><br>Philippon</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Cyrille_Dumont.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Cyrille</strong><br>Dumont</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/thierry_clechet.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Thierry</strong><br>Clechet</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Sylvain_Trinquesse.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Sylvain</strong><br>Trinquesse</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/pauline_bordery.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Pauline</strong><br>Bordery</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/édouard_ferrari.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Édouard</strong><br>Ferrari</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Alexia_santos.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Alexia</strong><br>Santos</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/neil_bordery.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Neil</strong><br>Bordery</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/yves_dugas.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Yves</strong><br>Dugas</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/vincent_richaud.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Vincent</strong><br>Richaud</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/sébastien_deville.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Sébastien</strong><br>Deville</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/patrick_bruno.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Patrick</strong><br>Bruno</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/mélanie_démurger.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Mélanie</strong><br>Démurger</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/marion_corneloup.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Marion</strong><br>Corneloup</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/marilys_boyer.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Marilys</strong><br>Boyer</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/lydia_oriol.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Lydia</strong><br>Oriol</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/laurent_rognard.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Laurent</strong><br>Rognard</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/lionel_salmon.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Lionel</strong><br>Salmon</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/jean-jacques_berrard.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Jean-Jacques</strong><br>Berrard</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/gilles_serrano.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Gilles</strong><br>Serrano</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/florian_privé.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Florian</strong><br>Privé</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/frédéric_berlioz.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Frédéric</strong><br>Berlioz</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/dominique_darles.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Dominique</strong><br>Darles</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/anne_blay.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Anne</strong><br>Blay</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/agnès_michon.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Agnès</strong><br>Michon</div></div>
<div style='
      flex: 1 1 85px;
      height: 190px;
      margin: 5px;
      text-align: center;
      vertical-align: top;
    '><img src='trombi/Martin_GANDON.png' style='width:100%; max-width:95px; border-radius:8px;'><br><div style='height:70px; overflow:hidden; line-height:1.3em;'><strong>Martin</strong><br>Gandon</div></div>
</div>
