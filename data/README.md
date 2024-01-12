# Data processing code

The files in this folder process the raw data downloaded from Web of Science to create the final datasets included with this repository.

* `included_papers_final.csv`
* `reproducible_papers_final.csv`

They also describe the process of data entry at each step.
Because the raw WoS downloads are not included in the repository, and because I manually entered information into the CSVs as I worked through the papers, it is not possible to run the code files in this folder from start to finish to generate the final dataset.
However I included them to keep a record of what steps I took when processing the data.

## Data processing steps

1. Process the raw WoS downloads into cleaned CSVs (`01_WoS_downloads.R`)
2. Record if papers should be included in the study and record this in the cleaned CSVs (described in `02_record_inclusion_data.md`)
3. Create the dataset of included papers (`03_create_included_papers_dataset.R`)
4. Work through the included papers to determine if they are potentially reproducible and record this information (described in `04_record_code_data_availability.md`)
5. Create dataset of reproducible papers (`05_create_reproducible_papers_dataset.R`)
6. Record if code in each reproducible paper runs and if the results reproduce the results in the paper (described in `06_record_reproducibility_data.md`)
7. Make final datasets (`07_make_final_datasets.R`)
