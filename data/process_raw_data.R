# The goal of this file is to clean the raw data and generate 
# 10 new CSV files (one per journal) from which the final set of 50 candidate
# articles per journal will be selected

suppressMessages(library(readxl))
suppressMessages(library(digest))

raw_files <- paste0("raw_data/", list.files("raw_data"))

# Do all files have the same header?
headers <- lapply(raw_files, function(x) suppressMessages(colnames(read_excel(x))))
stopifnot(all(sapply(headers, function(x) all(x == headers[[1]]))))

# Read them all in
raw_data <- lapply(raw_files, function(x) suppressMessages(read_excel(x)))
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

# Assign anon ID with MD5 hash
raw_data$ID <- as.character(sapply(raw_data$DOI, digest))
stopifnot(!any(duplicated(raw_data$ID)))

# Rename columns
names(raw_data) <- c("Authors", "Title", "Journal", "Volume", "StartPage", "EndPage", 
                    "DOI", "Year", "ID")

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
                        "Title", "Authors", "Volume", "StartPage", "EndPage", "ID")]

# Split again by journal
split_by_journal <- lapply(journals, function(x) raw_data[raw_data$Journal == x,])

dir.create("cleaned_data")

out <- lapply(split_by_journal, function(x){
         write.csv(x, paste0("cleaned_data/", gsub(" ", "_", x$Journal[1]), ".csv"))
})
