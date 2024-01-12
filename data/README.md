# Data processing code

The files in this folder process the raw data downloaded from Web of Science and create the final datasets included with this repository:

* `included_papers_final.csv`
* `reproducible_papers_final.csv`

Because the raw WoS downloads are not included in the repository, and because I manually entered information into the CSVs as I worked through the papers, it is not possible to run the code files in this folder from start to finish to generate the final dataset.
However I included them to keep a record of what steps I took when processing the data.

1. `01_process_WoS_downloads.R`: Process the raw XLS downloads from Web of Science into clean CSVs, one per journal

I then skimmed each paper included in the CSVs to determine if they should be included in the sample and entered this information into the CSV.

2. `02_create_included_papers.R`: From the CSVs in step 1 above, create a single CSV (`included_papers.csv`) containing the final dataset of papers to include in the study (i.e., ecology papers that look at abundance/distribution).

Next I worked through `included_papers.csv`, recording if the paper shared code and data and other relevant information.

3. `03_create_reproducible_papers.R`: Subset `included_papers.csv` to include only possibly reproducible papers (papers that included both code and data). The resulting dataset was `reproducible_papers.csv`.

Work through `reproducible_papers.csv` to record if the code ran, if the results were reproducible, etc.

4. `04_make_final_datasets.R`: Do final cleanup on `included_papers.csv` and `reproducible_papers.csv`, including removing some papers by coauthors (Doser) and removing DOIs.

The result of this step is the final shared datasets: `included_papers_final.csv` and `reproducible_papers_final.csv`.
