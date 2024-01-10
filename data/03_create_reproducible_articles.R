# Subset data to just articles that could be reproduced

# Full set of included articles
included <- read.csv("included_articles.csv")

# Have to have both data and code to reproduce
could_repro <- included$All_Data & included$All_Code

# Create dataset
repro <- included[could_repro,]

# Keep cols
keep_cols <- c("DOI", "Journal", "Year", "Appendix", "Dryad", "Zenodo",
               "Figshare", "OSF", "Org_Database", "Github", "Other_Database",
               "Other_Paper")
repro <- repro[, keep_cols]

# New columns for next stage of data collection
# Confirm that article is theoretically reproducible (i.e., data and code present)
# Just double checking the previous step
repro$Possible_Reproduce <- NA
# Code format(s)
repro$Script <- repro$RMarkdown <- repro$PDF <- repro$Word <- repro$Other <- NA
# Is code version-controlled (git etc)?
repro$Version_Control <- NA
# Is the code reasonably well commented (a judgment call obviously)?
repro$Commented <- NA
# Lines of R code in total (approximate)
repro$Code_Lines <- NA
# Number of libraries (actually loaded, not necessarily all libaries in the code)
repro$Libraries <- NA
# Did you have to adjust the file paths/directories manually?
repro$Fixed_Filepaths <- NA
# Does all the code seem to run?
repro$All_Code_Runs <- NA
# Only some code files run
repro$Some_Code_Runs <- NA
# If run time is too long (>30 min), we won't wait for it
repro$Runtime_Too_Long <- NA
# If it runs, do the outputs seem to roughly match the paper?
repro$Outputs_Match <- NA
# Note problems with code, i.e. wrong version of packages, etc.
repro$Problems <- NA
# Other notes
repro$Notes <- NA

write.csv(repro, "reproducible_articles.csv", row.names=FALSE)
