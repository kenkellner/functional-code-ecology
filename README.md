# Functional and reproducible code is rare in ecology papers

Public archival of analysis code and associated data is increasingly required or encouraged by scientific journals upon paper acceptance.
Making both data and code available has numerous reported benefits, including increased transparency of methods, facilitation of future studies, and enabling complete reproduction of a paper's results.
At present, however, there are few standards or checks on publicly available code, and in our experience it is rarely examined by reviewers.
This leads to three questions: (1) how common is code sharing in recent papers; (2) how functional is the code, and (3) how reproducible are analyses when both code and data area publicly available?
This study attempts to answer these three questions for recent papers on species distribution and abundance.

## Table of contents

* `01_pregistration`: Description of planned methods and analyses, and a power analysis.
* `02_make_datasets`: Detailed methodology and example code for creating the datasets used in the analysis.
* `03_analysis`: Final data and code for running the analysis in the paper.

## Reproduce the paper results

1. Navigate to the `03_analysis` folder.
2. Install dependencies. To run the analysis in a Docker container (preferred to exactly reproduce the results), only [Docker](https://www.docker.com/) and `make` must be manually installed. To run the analysis without Docker, install `make`, R (>=4.0), and the R packages `rmarkdown`, `rstanarm`, and `sankey`.
3. Run the analysis with Docker by calling `make docker` in the command line. You may have to use `sudo` and you may have to run this twice to get output files to copy out of the container. Run the analysis without Docker by calling `make`, or manually in R with the code `rmarkdown::render('Functional_Reproducible_Code_Ecology.Rmd')`.
4. The output should be an HTML file containing the results, two table files, and three figure files.
