<table style="width: 600px; border: none;" cellpadding="10" align="center">
  <tr>
    <td align="center">
      <img src="images/iPOP-up_logo.png" alt="iPOP-up" style="height: 60px; width: auto;">
    </td>
    <td align="center">
      <img src="images/U-Paris-Cite-logo.png" alt="Université Paris-Cité" style="height: 60px; width: auto;">
    </td>
    <td align="center">
      <img src="images/IFB-logo.png" alt="IFB" style="height: 65px; width: auto;">
    </td>
    <td align="center">
      <img src="images/ELIXIR-France_logo.png" alt="ELIXIR-FR" style="height: 60px; width: auto;">
    </td>
    <td align="center">
      <img src="images/MERIT-logo.png" alt="MERIT" style="height: 50px; width: auto;">
    </td>
  </tr>
</table>


# Journée IA pour le développement logiciel et l'analyse des données biologiques -- 2ème édition

Edition 2026, le 12 juin, sur le campus des Grands Moulins, 75013 Paris.

## Exposés du matin

| Intervenant | Titre | Diaporama |
|----------|------------------------------------|:----:|
| Bertrand Cosson et Jacques van Helden | Introduction à la journée | [pdf](slides/2026/1-1_intro_colloque-IA_2026-06-12.pdf) |
| Pierre Poulain | Science ouverte, données et IA : automatiser l’annotation scientifique  |[pdf](slides/2026/1-2_annotation_donnees_IA_Poulain_2026-06-12.pdf) |
| Guillaume Gautreau | Hands-on workshop on genomic language models  |  [pdf](slides/2026/1-3_Guillaume_Gautreau_gLM.pdf) |
| Romuald Marin | VeromeCh\@t |  |
| Approches émergentes : API, IA agentique, écosystèmes de développement | Baptiste Rousseau | [pdf](slides/2026/1-5_AI-emerging-approaches_Baptiste-Rousseau_2026-06-12.pdf) |
| Thomas Denecker | Démonstration en mode RetEx |  |
| Jacques van Helden, Bertand Cosson et Thomas Denecker | Présentation des travaux pratiques de l'après-midi |  [pdf](slides/2026/1-7_presentation-ateliers-pratiques.pdf) |

Vidéos de la matinée: (à ajouter)

## Organisation

### Programme et inscription

- <https://iabioscripting2.sciencesconf.org>

### Dépôt du code sur github

- **Organisation github**: AI-BioSoftware (<https://github.com/AI-BioSoftware>)

- **Votre entrepôt:** *ia-bioscript26-XX*

    - Remplacez XX par votre numéro de groupe en 2 digits


### Retour d'expérience

- Formulaire : <https://forms.gle/EWbjEu2gwa8JHR7r7> 


## Ateliers pratiques de l'après-midi


### Phase 1 — Conceptualisation avec l’IA (≈ 45 min)

*L’IA comme consultant : elle analyse le problème et propose une approche avant toute programmation.*

**Ce que vous demandez à l’IA :**

- Soumettez la figure heatmap et la table de comptage
- Demandez-lui de proposer une approche d’analyse pour produire ce type de figure à partir de ces données
- Demandez-lui de produire un flowchart (organigramme) de la procédure proposée
- Demandez-lui de décomposer en étapes et de détailler pour chaque étape les paramètres importants et les choix possibles
- Discutez en groupe : les choix proposés vous semblent-ils biologiquement pertinents ?

**Questions guides :** 

- Quelle normalisation est proposée, et pourquoi ? 
- Comment les gènes sont-ils ordonnés ? 
- Quels paramètres de visualisation sont suggérés ? 
- Y a-t-il des alternatives proposées ? Lesquelles choisissez-vous et pourquoi ?

**Notez les paramètres retenus**

- ils constituent votre cahier des charges pour la Phase 2.

### Phase 2 — Implémentation (≈ 60 min)

*L’IA comme assistant programmeur : elle code ce que vous lui dictez, étape par étape.*

1. Validez collectivement le plan issu de la Phase 1 avant de demander le code
2. Demandez le code étape par étape, en précisant à chaque fois :
    - Le langage (R ou Python)
    - Les paramètres retenus en Phase 1
    - Vos exigences : documentation, gestion des erreurs

3. Exécutez sur l'instance RStudio de la salle ou sur l'ordinateur de votre choix
4. Itérez jusqu’à obtenir une figure satisfaisante
5. Comparez visuellement votre figure à la cible

**Conseil :** ne demandez pas tout le code en un seul prompt — avancez étape par étape et validez chaque bloc avant de passer au suivant.

### Phase 3a — Contrôle négatif (≈ 15 min)

*Le pipeline détecte-t-il de la périodicité là où il n’y en a pas ?*

- Téléchargez le fichier [oscillating-genes_1705_normalized-profiles_row-wise-permuted.tsv](https://raw.githubusercontent.com/IFB-ElixirFr/AI-bioscripting-workshop/refs/heads/main/data/yeast-transcriptome-cell-cycle/oscillating-genes_1705_normalized-profiles_row-wise-permuted.tsv) 
- Ouvrez-le et explorez son contenu
- Ce fichier contient les mêmes gènes et les mêmes valeurs d’expression que le fichier original, mais les 50 points temporels ont été permutés aléatoirement (seed = 42) — la périodicité temporelle est donc détruite
- Dans votre script, remplacez uniquement le nom du fichier d’entrée par le fichier permuté — ne modifiez rien d’autre
- Relancez le script et observez la figure produite
- Si la figure présente encore des patterns de périodicité → votre pipeline génère des illusions. Si elle est plate/aléatoire → il est robuste.
- Demandez à l’IA d’interpréter le résultat : que signifie biologiquement la présence ou l’absence de structure sur données permutées ?

### Phase 3b — Qualité du code (≈ 15 min)

- Demander à une IA d’améliorer la qualité globale du code et garantir sa maintenabilité


### Phase 4 — Révélation et comparaison (≈ 30 min)

*L’article est distribué — l’IA compare votre approche avec celle des auteurs.*

1. Recevez l’article complet + matériel supplémentaire (Kelliher et al., PLoS Genet 2016)
2. Soumettez-les à l’IA avec votre script et votre flowchart
3. Demandez-lui de comparer les deux approches :
    - Points communs entre votre procédure et celle de l’article
    - Différences et leurs conséquences sur le résultat
    - Avantages et limites de chaque approche
4. Préparez 2-3 points clés à partager en mise en commun


### Atelier 1 : Reproductibilité et FAIRisation

- Github repository: <https://github.com/IFB-ElixirFr/IA-BioSoftware-Workshop>

### Atelier 2 : Développement logiciel pour la biologie

- Github repository: <https://github.com/IFB-ElixirFr/AI-bioscripting-workshop/> 
- Github pages: <https://ifb-elixirfr.github.io/AI-bioscripting-workshop/> 
- Data table [oscillating-genes_1705_normalized-profiles.tsv](https://raw.githubusercontent.com/IFB-ElixirFr/AI-bioscripting-workshop/refs/heads/main/data/yeast-transcriptome-cell-cycle/oscillating-genes_1705_normalized-profiles.tsv): normalized counts (RPKM) for 1705 oscillating genes of *Saccharomyces cerevisiae*
- Permuted Data table [oscillating-genes_1705_normalized-profiles_row-wise-permuted.tsv](https://raw.githubusercontent.com/IFB-ElixirFr/AI-bioscripting-workshop/refs/heads/main/data/yeast-transcriptome-cell-cycle/oscillating-genes_1705_normalized-profiles_row-wise-permuted.tsv): random permutation of the normalized count table. 


----

## Contributions

### Institutions

- Institut Français de Bioinformatique (IFB)
- Université Paris Cité (plateforme iPOP-UP et DU omiques)
- Réseau métier en bioinformatique (MERIT)


### Comité scientifique et de programmation

- [Bertrand Cosson](https://orcid.org/0000-0003-3401-7137) (Université Paris-Cité)
- [Jacques van Helden](https://orcid.org/0000-0002-8799-8584) (Institut Français de Bioinformatique, Aix-Marseille Université) 
- [Imane Messak](https://orcid.org/0000-0002-1654-6652) (Institut Français de Bioinformatique)
- [Thomas Denecker](https://orcid.org/0000-0003-1421-7641) (Institut Français de Bioinformatique)


### Encadrants 2026

- [Bertrand Cosson](https://orcid.org/0000-0003-3401-7137) (Université Paris-Cité)
- [Thomas Denecker](https://orcid.org/0000-0003-1421-7641) (Institut Français de Bioinformatique)
- [Olivier Kirsh](https://orcid.org/0000-0001-6200-5681) (Université Paris-Cité)
- [Imane Messak](https://orcid.org/0000-0002-1654-6652) (Institut Français de Bioinformatique)
- [Baptiste Rousseau](https://orcid.org/0009-0002-1723-2732) (Institut Français de Bioinformatique)
- [Benjamin Saintpierre](https://orcid.org/0009-0004-9440-5902) (Inserm)
- [Jacques van Helden](https://orcid.org/0000-0002-8799-8584) (Institut Français de Bioinformatique, Aix-Marseille Université) 
- [Lilia Younsi](https://www.linkedin.com/in/lilia-younsi/) (Inserm)

### Autres contributions

Conception de l'atelier 2025 et préparation du jeu de données sur le cycle cellulaire de la levure. 

- [Pierre Poulain](https://orcid.org/0000-0003-4177-3619) (Université Paris-Cité)
- [Gaëlle Lelandais](https://orcid.org/0000-0002-2842-6172) (Université Paris-Saclay)



----

## Previous edition

| Edition | Date         | Release | DOI                     |
| ------- | ------------ | ------- | ----------------------- |
| 2026    | 12 June 2026 | v2026.0 | (to come)               |
| 2025    | 11 June 2025 | v2025.2 | [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20636013.svg)](https://doi.org/10.5281/zenodo.20636013)
 |


## Licence

[![CC BY-SA 4.0][cc-by-sa-shield]][cc-by-sa]

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg

## Funding

L'Institut Français de Bioinformatique (IFB) a été fondé par les Programme d'Investissements d'Avenir subventionné par l'Agence Nationale de la Recherche (RENABI-IFB, ANR-11-INBS-0013) et par le programme France 2030 relatifs aux équipements structurants pour la recherche / EQUIPEX+ (MUDIS4LS, ANR-21-ESRE-0048).

----

Maintained by [Jacques van Helden](https://orcid.org/0000-0002-4516-6509) [![ORCID](https://img.shields.io/badge/ORCID-0000--0002--4516--6509-a6ce39?logo=orcid&style=flat-square)](https://orcid.org/0000-0002-4516-6509)

