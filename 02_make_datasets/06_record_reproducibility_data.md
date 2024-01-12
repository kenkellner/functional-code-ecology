# 6. Record reproducibility data

For each included paper entry in `reproducible_papers.csv`, perform the following steps:

1. Go the paper's web page and download the code and data. If multiple sources are provided, default to sources with a permanent DOI (e.g. choose Zenodo over Github).
2. Create a folder for the paper and extract the code and data into it, preserving the created file structure as much as possible.
3. Read any provided README files.
4. If the data were provided separately from the code, attempt to put the data into the correct location in the file structure.
5. Double check: does it appear the analysis in the paper is reproducible? Record this in column `Possible_Reproduce`
6. Record the format(s) of the provided code (e.g. R script, PDF, Word document, Rmarkdown) in columns `Script`, `PDF`, `Word`, `Rmarkdown`, `Other`.
7. Extract R code from any Rmarkdown/Quarto files using `knitr::purl()` so it can be run separately.
8. Record if the code seems to be reasonably well-commented (judgment call) in column `Commented`.
9. Record the total lines of R code using `wc -l *.R` in a Bash prompt. Do this for all subfolders as well. Also count the lines of any provided BUGS or Stan model files the same way and add to the total. Code in other languages (e.g. Python or Bash) was not included. For papers that were presenting a new package, the package code was not included in the total, only the code for provided examples. Record this total in column `Code_Lines`.
10. Search through all code files and identify R packages used, using Bash code `grep -r library *.R`, `grep -r require *.R`, `grep -r "::" *.R`, and manual inspections. Get a list of all the package names. Calculate the total number of recursive package dependencies using the following R function, and record this in column `Libraries`. For packages only available on Github this had to be done partly manually.

```r
total_deps <- function(packages){
  out <- tools::package_dependencies(packages, recursive=TRUE)
  out <- c(names(out), unlist(out))
  length(unique(out))
}
```

11. Download the latest version of required packages from CRAN. If the package is only available on Github, download it from Github and record this in column `Non_CRAN_Package`. If one or more of the required packages is deprecated (removed from CRAN), record this in column `Depr_Packages`, mark `All_Code_Runs` to 0, and stop running code for that paper.
12. If the README and/or code file names (e.g. numbered names like `1_process_data.R`) make it clear the order to proceed in the analysis, follow that order. Otherwise start with the file that is my best guess at where the analysis should start.
13. Adjust file paths to the downloaded data if it is necessary, and record if I did in column `Fixed_Filepaths`. Do NOT change the file *names* in any way, including lowercase/uppercase. Some operating systems (Linux) are sensitive to the case of filenames.
14. Begin running the code in the file.
15. If the code errors, record 0 in `All_Code_Runs` (and optionally 0 or 1 in `Some_Code_Runs` depending on if most of the code runs, but we won't use this column as it is subjective). Also record the reason in the appropriate column: `Miss_File` if a data or code file appears to be missing or misnamed, `Miss_Library` if a function is called from an R package that hasn't been loaded, `Miss_Object` if the code references an R object that doesn't exist, or `Other_Code_Error` otherwise. Optionally record detailed explanation in column `Problems`. Sometimes the misnamed files have only trivial mistakes, but according to the rules we still mark those as the code failing to run.
16. If code runs but it is going to take a very long time (e.g. a long Bayesian analysis or simulation), adjust the settings such as reducing number of iterations or simulations to create a shorter run to check the code at least works. Record that this was done in `Runtime_Too_Long`. If the authors themselves indicate that in the provided code the number of run iterations/simulations is lower than what they actually used in the paper, also mark `Runtime_Too_Long`. Don't compare outputs from these shorter runs to the actual results (i.e., don't fill in `Outputs_Match` column) as it isn't a fair comparison.
17. If the code runs and doesn't take too long, compare the output/figures to what's in the paper. Record if they match in `Outputs_Match` column and add any additional notes in `Notes` column.
