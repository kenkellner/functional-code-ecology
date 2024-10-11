# 7. Make final datasets

# This script does final clean up on the two datasets
# (included papers and reproducible papers)
# The outputs are the datasets included with this repository,
# included_papers_final.csv and reproducible_papers_final.csv

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

# Correct issues found during validation
# The following dataset contains Jeff's entered data
val <- read.csv("validation-dataset-jwd.csv")
repr_sub <- repr[repr$ID %in% val$ID,]
cbind(original=repr_sub$All_Code_Runs, validation=val$All_Code_Runs)

repr_sub[4,] # Validation is correct, this should be an object error
repr$All_Code_Runs[repr$ID == repr_sub$ID[4]] <- 0
repr$Miss_Object[repr$ID == repr_sub$ID[4]] <- 1

repr_sub[10,] # After double-check, still doesn't work.
# Problem is a missing .gri extension which raster doesn't pick up - version mismatch?

repr_sub[20,] # Validation is correct, this should be marked as running code
repr$All_Code_Runs[repr$ID == repr_sub$ID[20]] <- 1
# However runtime is too long to check (ignoring authors' logical statements that exclude a bunch of code)
repr$Runtime_Too_Long[repr$ID == repr_sub$ID[20]] <- 1
repr$Other_Code_Error[repr$ID == repr_sub$ID[20]] <- 0
repr$Problems[repr$ID == repr_sub$ID[20]] <- NA

# DOI refererence
doi_ref <- incl[,c("ID", "DOI")]
write.csv(doi_ref, "ID_to_DOI.csv", row.names=FALSE)

# Create final datasets
# Remove DOIs
incl$DOI <- NULL
repr$DOI <- NULL
val$DOI <- NULL

# Remove columns summarized elsewhere
incl$Notes <- NULL
repr$Notes <- NULL
val$Notes <- NULL
repr$Problems <- NULL
val$Problems <- NULL

# Clean up validation dataset for clarity
names(val)[names(val) == "All_Code_Runs"] <- "All_Code_Runs_JWD"
val$All_Code_Runs_KFK <- repr_sub$All_Code_Runs
val$Validation_Notes <- NA
val$Validation_Notes[c(4,10,20)] <- c("False negative", "Ignored, possibly R library issue",
                                      "False positive")

# write out final data files
write.csv(incl, "included_papers_final.csv", row.names=FALSE)
write.csv(repr, "reproducible_papers_final.csv", row.names=FALSE)
write.csv(val, "validation_final.csv", row.names=FALSE)

}
