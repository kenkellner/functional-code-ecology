# 7. Make final datasets

# This script does final clean up on the two datasets
# (included papers and reproducible papers)
# The outputs are the datasets included with this repository,
# included_papers_final.csv and reproducible_papers_final.csv

# Not possible to run this script with the data provided in the repository
run_code <- FALSE

if(run_code){

# Read in datasets
incl <- read.csv("included_papers.csv")
repr <- read.csv("reproducible_papers.csv")

# Remove papers from reproducible_papers that didn't actually have code/data
repr <- repr[is.na(repr$Possible_Reproduce) | repr$Possible_Reproduce == 1,]

# Remove Doser papers since he is a coauthor
incl <- incl[!grepl("Doser", incl$Notes),]
repr <- repr[!grepl("Doser", repr$Notes),]

# Assign IDs
ID <- 1:nrow(incl)
incl <- cbind(ID = ID, incl)

ID_repr <- rep(NA, nrow(repr))
for (i in 1:length(ID_repr)){
  ID_repr[i] <- incl$ID[which(incl$DOI == repr$DOI[i])]
}
repr <- cbind(ID = ID_repr, repr)

# Create validation dataset for 2nd author to review
# Keep only papers that I could test
set.seed(123)
val <- repr[!is.na(repr$All_Code_Runs),]
keep <- sort(sample(1:nrow(val), 30, replace=FALSE))
val <- val[keep,]
# Remove my scores
val$Fixed_Filepaths <- val$All_Code_Runs <- val$Some_Code_Runs <- val$Runtime_Too_Long <- NA
val$Outputs_Match <- val$Depr_Packages <- val$Miss_File <- val$Miss_Library <- NA
val$Miss_Object <- val$Other_Code_Error <- val$Non_CRAN_Package <- val$Problems <- NA
val$Notes <- NA
write.csv(val, "validation_dataset.csv", row.names=FALSE)

# Create final datasets
# Remove DOIs
incl$DOI <- NULL
repr$DOI <- NULL
# Remove columns summarized elsewhere
incl$Notes <- NULL
repr$Notes <- NULL
repr$Problems <- NULL

# write out final data files
write.csv(incl, "included_papers_final.csv", row.names=FALSE)
write.csv(repr, "reproducible_papers_final.csv", row.names=FALSE)

}
