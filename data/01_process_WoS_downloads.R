# The goal of this file is to clean the raw download data from Web of Science 
# and create 10 new CSV files (one per journal) from which the final set of 
# 50 candidate articles per journal will be selected
# The original file downloads were .xls but they were converted first to .csv

raw_files <- paste0("WoS_downloads/", list.files("WoS_downloads"))

# Do all files have the same header?
headers <- lapply(raw_files, function(x) colnames(read.csv(x, check.names=FALSE, na.string="")))
stopifnot(all(sapply(headers, function(x) all(x == headers[[1]]))))

# Read them all in
raw_data <- lapply(raw_files, function(x) read.csv(x, check.names=FALSE, na.string=""))
raw_data <- do.call(rbind, raw_data)

keep_cols <- c("Authors", "Article Title", "Source Title", "Volume", 
                  "Start Page", "End Page", "DOI", "Publication Year") 

raw_data <- raw_data[, keep_cols]

# Remove outside range 2018-2022
raw_data <- raw_data[raw_data$`Publication Year` %in% 2018:2022,]

# Remove entries without DOI
raw_data <- raw_data[!is.na(raw_data$DOI),]

# Remove duplicated DOI
raw_data <- raw_data[!duplicated(raw_data$DOI),]

# Check journals
raw_data$`Source Title` = toupper(raw_data$`Source Title`)
journals <- unique(raw_data$`Source Title`)
stopifnot(length(journals) == 10)

# Rename columns
names(raw_data) <- c("Authors", "Title", "Journal", "Volume", "StartPage", "EndPage", 
                    "DOI", "Year")

# Scramble order
set.seed(123)
new_order <- sample(1:nrow(raw_data), nrow(raw_data), replace=FALSE)
raw_data <- raw_data[new_order,]

# Add columns I'll fill in after looking at papers
raw_data$PlantsOrAnimals <- NA
raw_data$HierarchModel <- NA
raw_data$UsesR <- NA
raw_data$UseArticle <- NA

# Re-organize columns
raw_data <- raw_data[,c("DOI", "Journal", "Year", "PlantsOrAnimals", "HierarchModel", "UsesR", "UseArticle",
                        "Title", "Authors", "Volume", "StartPage", "EndPage")]

# Split again by journal
split_by_journal <- lapply(journals, function(x) raw_data[raw_data$Journal == x,])

# Put cleaned files in new folder
# Next step is to decide if they should be included in the study based on topic
dir.create("check_for_inclusion")

out <- lapply(split_by_journal, function(x){
         write.csv(x, paste0("check_for_inclusion/", gsub(" ", "_", x$Journal[1]), ".csv"))
})
