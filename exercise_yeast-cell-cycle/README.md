# Using a generative AI to implement a script for bioanalysis

This folder describes the practical execise for the workshop "Using generative AI to implement a script for bioanalysis"

## Source article

- Kelliher, C. M., Leman, A. R., Sierra, C. S. & Haase, S. B. 
Investigating Conservation of the Cell-Cycle-Regulated Transcriptional Program in the Fungal Pathogen, Cryptococcus neoformans. 
PLoS Genet 12, e1006453 (2016). 
DOI [10.1371/journal.pgen.1006453](https://doi.org/10.1371/journal.pgen.1006453)


## Pre-processing 

Performed by Gaëlle Lelandais and the students of the "Diplôme Universitaire Omique (DUO)"

- The data table contains normalised counts of the 1705 yeast genes showing oscillating profiles of transcription during the cell cycle. 
- Raw RNA-seq counts were normalised uusing R package DeSEQ2


## Goal of the exercise

Use an AI to generate an R script that performs the following tasks: 

- Download a data table from this Web site, and save it to a local folder
- Load this data table data in R
- Compute summary statistics on the whole data table (min, max, median, mean, sd, ...)
- Compute marginal statistics on rows (genes) and columns (timepoints) of the data table
- Normalise the data table in 3 steps

    - log2 transformation
    - column-wise standardisation (centering and scaling)
    - row-wise standardisation (centering and scaling)

- Produce a heatmap similar to the leftv panel of [Figure 2 of the source article (Kelliher, 2016)](../../images/Kelliher_2016_pgen.1006453.g002.png)
- Export this heatmap in png and pdf formats

## Some recommendations

- **Provide your AI with context from the outset:** tell it your goal, give it details of the type of data, your criteria (documentation, structuring, etc.)
- **Act step-by-step:** rather than asking for a script that does everything from the outset, start by asking for a script that does the first step (downloading the data) then the second (loading the data), and advance step by step. 
- **Structure the script:** ask your AI to segment the code by implementing functions for each of the different tasks. 
- **Perform unit tests:** design a validation test for each function and ask the AI to check that the code gives the right answer.


## Results


The ChatGPT prompting is available here: [yeast-cell-cycle_ChatGPT-prompting.md](yeast-cell-cycle_ChatGPT-prompting.md)

The final code is available here : [yeast-cell-cycle_analysis_2025-06-13.R](yeast-cell-cycle_analysis_2025-06-13.R)

