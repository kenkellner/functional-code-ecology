library(digest)

files <- paste0("cleaned_data/", list.files("cleaned_data"))

cleaned <- lapply(files, read.csv)
cleaned <- do.call(rbind, cleaned)

(tab <- table(cleaned$Journal, cleaned$UseArticle))

sum(tab[,2])

# Remove Journal of Ecology
cleaned <- cleaned[cleaned$Journal != "JOURNAL OF ECOLOGY",]

# Keep only used articles
cleaned <- cleaned[!is.na(cleaned$UseArticle),]
cleaned <- cleaned[cleaned$UseArticle == 1,]

# Simplify columns
cleaned <- cleaned[,c("DOI","Journal","Year")]

# Re-generate ID
cleaned$ID <- sapply(cleaned$DOI, digest)

# Save dataset
write.csv(cleaned, "final_data.csv", row.names=FALSE)
