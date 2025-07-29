# This folder contains functions that were used to generate results in PLOS ONE paper: 

**"Expert informed, causally structured synthetic data generation for the investigation of mild feline acne in the setting of veterinary telemedicine"** 
[Wiktoria Lawniczak] (University of Leeds, Vet-AI Ltd), [Marc de Kamps] (University of Leeds), [Adele Williams-Xavier] (Vet-AI Ltd, AiWX Ltd), [Mark S. Gilthorpe] (Leeds Beckett University)

## Description:
* File 0_supporting_functions.r contains those functions or definitions that were used in at least one of the other parts of code. It does not need running on its own but is called by the notebooks.
* Notebooks beginning with 1_, 2_, and 3_ should be run in that order. Notebook beginning with 4_ can be run independently.
* 1_genData_synthetic_feline_acne.r tunes the genData algorithm from Ruscio J, Kaczetow W. **"Simulating Multivariate Nonnormal Data Using an Iterative Algorithm."** Multivariate Behavioral Research. 2008;43:355–381
* 2_genData_synthetic_feline_acne_create_dataset.r takes the number of latent factors and using it creates a folder with example datasets. These datasets are then analysed and results saved in the folder.
* 3_synthetic_feline_acne_analysis.r takes the results from the previous section, calculates analysis for dagitty dataset, and presents all together.
* 4_synthetic_feline_acne_analysis_extension.r extends the current DAG with compliance and improvement nodes, calculates 'table 2' for the two added nodes.

## Keywords:
* veterinary telemedicine 
* multilevel synthetic data generation
* expert-informed DAGs

