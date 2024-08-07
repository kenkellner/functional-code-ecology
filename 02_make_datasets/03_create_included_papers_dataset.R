# 3. Combine papers to include into a single dataset

# Take papers to include (`UsePaper` = 1) from each separate journal CSV
# and combine them into a single CSV called `included_papers.csv`

# Not possible to run this code with data included in the repository
run_code <- FALSE

if(run_code){

files <- paste0("check_for_inclusion/", list.files("check_for_inclusion"))

cleaned <- lapply(files, read.csv)
cleaned <- do.call(rbind, cleaned)

(tab <- table(cleaned$Journal, cleaned$UsePaper))

sum(tab[,2])

# Remove Journal of Ecology
cleaned <- cleaned[cleaned$Journal != "JOURNAL OF ECOLOGY",]

# Save this intermediate step
write.csv(cleaned, "all_papers_cleaned.csv", row.names=FALSE)

# Check what percent of these used R
round(mean(cleaned$UsesR, na.rm=TRUE)*100) # 79%

# Keep only used papers
cleaned <- cleaned[!is.na(cleaned$UsePaper),]
cleaned <- cleaned[cleaned$UsePaper == 1,]

# Simplify columns
cleaned <- cleaned[,c("DOI","Journal","Year")]

# Add new columns to check in the next stage
# Info about whether data and/or code are shared with the paper
cleaned$All_Data <- cleaned$All_Code <- cleaned$Partial_Code <- NA
# Where the data/code are located
cleaned$Appendix <- cleaned$Dryad <- cleaned$Zenodo <- cleaned$Figshare <- NA
cleaned$OSF <- cleaned$Org_Database <- cleaned$Github <- NA
cleaned$Other_Database <- cleaned$Other_Paper <- NA
# Is info claimed to be present missing?
cleaned$Missing_Appendix <- cleaned$Missing_Broken_Link <- cleaned$Missing_Components <- NA
# Is data source provided, but not enough info to actually get the specific dataset?
cleaned$Database_Not_Enough_Info <- NA
# Only model code (BUGS, Stan) is provided, but not code to actually run the model
cleaned$Model_Code_Only <- NA
# Other notes
cleaned$Notes <- NA

# Save dataset
write.csv(cleaned, "included_papers.csv", row.names=FALSE)

}
