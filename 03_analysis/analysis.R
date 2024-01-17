library(lme4)
library(DHARMa)
library(sankey)

# Read in datasets-------------------------------------------------------------

# Included papers
incl <- read.csv("included_papers_final.csv")

# Journal information
jour <- read.csv("journal_data.csv")

# Merge journal data into included papers dataset
incl <- merge(incl, jour, by = c("Journal", "Year"))

# Potentially reproducible papers
repr <- read.csv("reproducible_papers_final.csv")

# Figure 1 --------------------------------------------------------------------
# Visualize results of data collection with a Sankey diagram

# Set up first node and split
all_papers <- nrow(incl)
all_papers_lab <- paste0("All papers\n(",all_papers,")")

code_and_data <- sum(incl$All_Data & incl$All_Code)
code_and_data_lab <- paste0("\nHas code/\ndata (", code_and_data, ")")
incomplete <- all_papers - code_and_data
inc_lab <- paste0("\nMissing\ncode/data\n(",incomplete,")")

split1 <- data.frame(start_node = rep(all_papers_lab, 2),
                     end_node = c(code_and_data_lab, inc_lab),
                     weight = c(code_and_data, incomplete), 
                     colorstyle="col", col=c("forestgreen", "goldenrod"))

# Set up second node and split
code_runs <- sum(repr$All_Code_Runs, na.rm=TRUE)
code_runs_lab <- paste0("\nCode\nruns (",code_runs,")")
other_issues <- sum(is.na(repr$All_Code_Runs))
other_issues_lab <- paste0("\nOther\nissues (", other_issues, ")")
doesnt_run <- code_and_data - other_issues - code_runs
doesnt_run_lab <- paste0("\nCode\nerrors (",doesnt_run,")") 


split2 <- data.frame(start_node = rep(code_and_data_lab, 3),
                     end_node = c(code_runs_lab, doesnt_run_lab, other_issues_lab),
                     weight = c(code_runs, doesnt_run, other_issues),
                     colorstyle = "col", col=c("forestgreen","goldenrod","gray"))

# Set up third node and splits
data_sub_coderuns <- repr[repr$All_Code_Runs==1 & !is.na(repr$All_Code_Runs),]

too_long <- sum(data_sub_coderuns$Runtime_Too_Long)
too_long_lab <- paste0("Runtime\ntoo long\n(", too_long, ")")
reproduces <- sum(!is.na(data_sub_coderuns$Outputs_Match) & data_sub_coderuns$Outputs_Match==1)
repro_lab <- paste0("Reproduces\n(", reproduces, ")")
doesnt_reproduce <- code_runs - too_long - reproduces
doesnt_repro_lab <- paste0("Doesn't\nreproduce\n(", doesnt_reproduce, ")")

split3 <- data.frame(start_node = rep(code_runs_lab, 3),
                     end_node = c(repro_lab, doesnt_repro_lab, too_long_lab),
                     weight = c(reproduces, doesnt_reproduce, too_long),
                     colorstyle = "col", col=c("forestgreen","goldenrod","gray"))

# Set up fourth node and splits
data_sub_norun <- repr[repr$All_Code_Runs==0 & !is.na(repr$All_Code_Runs),]

dep_pkg <- sum(data_sub_norun$Depr_Packages == 1)
dep_pkg_lab <- paste0("Deprecated\npackage\n(", dep_pkg, ")")
miss_file <- sum(data_sub_norun$Miss_File == 1 & data_sub_norun$Depr_Packages == 0)
miss_file_lab <- paste0("File issue\n(", miss_file, ")")
miss_obj <- sum(data_sub_norun$Miss_Object == 1 & data_sub_norun$Depr_Packages == 0)
miss_obj_lab <- paste0("Missing R\nobject (", miss_obj, ")")
other_error <- doesnt_run - dep_pkg - miss_file - miss_obj
other_error_lab <- paste0("Other error\n(", other_error, ")")

split4 <- data.frame(start_node = rep(doesnt_run_lab, 4),
                     end_node = c(dep_pkg_lab, miss_file_lab,
                                  miss_obj_lab, other_error_lab),
                     weight= c(dep_pkg, miss_file, miss_obj, other_error),
                     colorstyle = "col", col="goldenrod")

# Combine everything
all_splits <- rbind(split1, split2, split3, split4)

# Specify colors of nodes
nodes <- data.frame(id = c(all_papers_lab, code_and_data_lab, 
                           inc_lab, code_runs_lab, doesnt_run_lab,
                           other_issues_lab, repro_lab, doesnt_repro_lab,
                           too_long_lab, dep_pkg_lab, miss_file_lab,
                           miss_obj_lab, other_error_lab),
                    col = c("forestgreen", "forestgreen", "goldenrod", 
                            "forestgreen", "goldenrod", "gray",
                            "forestgreen","goldenrod", "gray",
                            "goldenrod","goldenrod","goldenrod","goldenrod"),
                    cex=1.1, adjy=0.9)

# Make plot input
plot_input <- make_sankey(nodes = nodes, edges = all_splits)

tiff("Figure_1.tiff", height=7, width=7, units='in', res=300, compression='lzw')
sankey(plot_input, mar = c(0, 3.2, 0, 4.2))
dev.off()


# Objective 1 -----------------------------------------------------------------
# Determine the proportion of papers for which it is possible to attempt to 
# reproduce the results. That is, are both data and code for a given paper available?

# Create Response variable
# Are both data and code for a given paper available?
incl$Data_and_Code <- as.numeric(incl$All_Data & incl$All_Code)

# Predictions
# 1. Papers in journals with data and code availability policies will be more 
# likely to have code and data available
# Covariate: Code_Required (implies data required also)
# 2. Awareness of the importance of reproducibility has been increasing. 
# Thus, year (2018-2022) will have a positive effect on availability of both data and code
# Covariate: Year (standardized)
# 3. Papers in higher-impact journals (as measured by impact factor) 
# will be more likely to have code and data
# Covariate: Impact_Factor

# Fit global GLMM
set.seed(123)
mod1 <- lme4::glmer(Data_and_Code ~ Code_Required + scale(Year) + scale(Impact_Factor) + (1|Journal),
                      family = binomial,      # logistic regression
                      data = incl)

summary(mod1)

res1 <- DHARMa::simulateResiduals(mod1)
plot(res1)

# Figure 2---------------------------------------------------------------------

tiff("Figure_2.tiff", height=7, width=7, units='in', res=300,
     compression='lzw')

par(mar=c(4,2,1,1), oma = c(1,3,0,0))
layout(matrix(c(1, 2,
                3, 3), ncol=2, nrow=2, byrow=TRUE))

# RHS formula
form <- ~Code_Required + scale(Year) + scale(Impact_Factor)

# Code required plot
# Calculate proportion for each code requirement option
tab_req <- table(incl$Code_Required, incl$Data_and_Code)
n <- rowSums(tab_req)
p <- tab_req[,2] / n

# Plot raw data
plot(1:2-0.1, p, ylim = c(0, 0.87), pch=19,
     ylab="Prop. with code and data", cex=1.3, cex.axis=1.2,
     xlab = "Journal code policy", xlim=c(0.5, 2.5), xaxt='n', cex.lab=1.2)
axis(1, at = 1:2, labels = c("Not required", "Required"), cex.axis=1.2)

legend('topright', legend = c("Raw data", "Model prediction"),
       lty = 1, col = c("black", "goldenrod"))

text(0.7, 0.8, "A", cex=2)

mtext("Proportion papers with code and data, and 95% CI", side = 2, line = 1,
      outer = TRUE)

# Plot model predictions

nd <- data.frame(Code_Required = c(0, 1), Year = median(incl$Year), 
                 Impact_Factor = median(incl$Impact_Factor))
mf <- model.frame(form, incl)
mf <- model.frame(terms(mf), nd)
X <- model.matrix(form, mf)
pr1 <- drop(X %*% fixef(mod1))
v <- X %*% vcov(mod1) %*% t(X)
se_fit <- sqrt(diag(v))
est <- plogis(pr1)
low_fit <- plogis(pr1 - 1.96 * se_fit)
up_fit <- plogis(pr1 + 1.96 * se_fit)
points(1:2+0.1, est, cex = 1.3, pch = 19, col='goldenrod')

# Error bars for model prediction
segments(1:2+0.1, low_fit, 1:2+0.1, up_fit, col='goldenrod')
bw <- 0.05
for (i in 1:2){
  segments(i+0.1-bw, low_fit[i], i+0.1+bw, low_fit[i], col='goldenrod')
  segments(i+0.1-bw, up_fit[i], i+0.1+bw, up_fit[i], col='goldenrod')
}

# Error  bars for raw data
# 95% CI
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se
segments(1:2-0.1, low, 1:2-0.1, up)
bw <- 0.05
for (i in 1:2){
  segments(i-0.1-bw, low[i], i-0.1+bw, low[i])
  segments(i-0.1-bw, up[i], i-0.1+bw, up[i])
}


# Year effect plot
yrs <- 2018:2022

# Calculate proportion in each year
tab_year <- table(incl$Year, incl$Data_and_Code)
n <- rowSums(tab_year)
p <- tab_year[,2] / n

# Plot raw data
plot(yrs, p, ylim = c(0, 0.87), pch=19,
     ylab="Prop. with code and data", cex=1.3, cex.axis=1.2,
     xlab = "Year", xlim=c(2017.75, 2022.25), cex.lab=1.2)

text(2018.25, 0.8, "B", cex=2)

# Plot model predictions
nd <- data.frame(Code_Required = 0, Year = 2018:2022, 
                 Impact_Factor = median(incl$Impact_Factor))
mf <- model.frame(form, incl)
mf <- model.frame(terms(mf), nd)
X <- model.matrix(form, mf)
pr1 <- drop(X %*% fixef(mod1))
v <- X %*% vcov(mod1) %*% t(X)
se_fit <- sqrt(diag(v))
est <- plogis(pr1)
low_fit <- plogis(pr1 - 1.96 * se_fit)
up_fit <- plogis(pr1 + 1.96 * se_fit)
polygon(c(yrs, rev(yrs)), c(low_fit, rev(up_fit)), col='lightgoldenrod1', border=NA)
lines(yrs, est, lty = 2, col='goldenrod')

# Re-plot raw data on top
points(yrs, p, pch = 19, cex = 1.3)

# Error  bars for raw data
# 95% CI
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se
segments(yrs, low, yrs, up)
bw <- 0.1
for (i in 1:5){
  segments(yrs[i]-bw, low[i], yrs[i]+bw, low[i])
  segments(yrs[i]-bw, up[i], yrs[i]+bw, up[i])
}

# Impact factor effect plot

# Calculate mean impact factor by journal
if_data <- aggregate(jour, by = Impact_Factor~Journal, FUN = mean)
if_data <- if_data[order(if_data$Impact_Factor),]

# Calculate proportion for each journal
tab_journ <- table(incl$Journal, incl$Data_and_Code)
# Sort by impact factor
tab_journ <- tab_journ[if_data$Journal,]
nj <- nrow(tab_journ)
n <- rowSums(tab_journ)
p <- tab_journ[,2] / n

abbrev <- c("JWM","E&E","ECOS","PLOS","SREP","ECOL","BC","CB","MEE")

# Plot raw data
plot(if_data$Impact_Factor, p, ylim = c(0, 0.87), pch=19,
     ylab="Prop. with code and data", cex=1.3, cex.axis=1.2,
     xlab = "Journal impact factor", cex.lab = 1.2,
     xlim = c(min(if_data$Impact_Factor)-0.25, max(if_data$Impact_Factor)+0.25))

text(2.2, 0.8, "C", cex=2)

# Plot model predictions
if_range <- range(if_data$Impact_Factor)
if_seq <- seq(if_range[1], if_range[2], length.out=100)
nd <- data.frame(Code_Required = 0, Year = median(incl$Year), 
                 Impact_Factor = if_seq)
mf <- model.frame(form, incl)
mf <- model.frame(terms(mf), nd)
X <- model.matrix(form, mf)
pr1 <- drop(X %*% fixef(mod1))
v <- X %*% vcov(mod1) %*% t(X)
se_fit <- sqrt(diag(v))
est <- plogis(pr1)
low_fit <- plogis(pr1 - 1.96 * se_fit)
up_fit <- plogis(pr1 + 1.96 * se_fit)
polygon(c(if_seq, rev(if_seq)), c(low_fit, rev(up_fit)), col='lightgoldenrod1', border=NA)
lines(if_seq, est, lty = 2, col='goldenrod')

# Re-plot raw data on top
points(if_data$Impact_Factor, p, pch = 19, cex = 1.3)

# Error  bars for raw data
# 95% CI
xval <- if_data$Impact_Factor
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se
segments(xval, low, xval, up)
bw <- 0.07
for (i in 1:length(xval)){
  text(xval[i], up[i] + 0.05, abbrev[i])
  segments(xval[i]-bw, low[i], xval[i]+bw, low[i])
  segments(xval[i]-bw, up[i], xval[i]+bw, up[i])
}

dev.off()


# Objective 2 -----------------------------------------------------------------
# For papers with code and data available, are we able to successfully run the code?

# Response variable
table(repr$All_Code_Runs)

# Predictions
# 1. We expect that the longer and more complex an analysis (as measured crudely 
# in lines of code), the less likely we will be to run the code successfully. 
# The more code you have, the more chances there are to introduce errors.
# Covariate: Code_Lines
# 2. Code that is adequately commented should be more likely to run successfully, 
# since it may indicate that authors worked through the code carefully line by line 
# and confirmed it did what it said it was doing.
# Covariate: Commented
# Almost all papers had a decent number of comments and we realized we
# didn't have a good way of assessing these objectively, so we dropped this covariate
# from the model before analysis
table(repr$Commented)
# 3. The more outside libraries the code depends on, the less likely the code will be to run.
# This includes all dependencies of libraries called in the script.
# Covariate: Libraries
# 4. Code provided in a format designed for reproducibility, such as Rmarkdown, 
# will be more likely to run successfully than code in a text file (e.g., .R). 
# Code in text files will be more likely to run than code shared in a PDF or Word document.
# Create covariate
code_format <- rep(NA, nrow(repr))
code_format[repr$Word == 1 | repr$PDF == 1] <- "PDF/Word"
code_format[repr$Script == 1] <- "R script"
code_format[repr$RMarkdown == 1 | repr$Other == 1] <- "Rmd/other" # "Other" here is R package
repr$Code_Format <- factor(code_format, levels=c("R script", "Rmd/other", "PDF/Word"))
table(repr$Code_Format)

# Fit global GLMM
set.seed(123)
mod2 <- lme4::glmer(All_Code_Runs ~ scale(Code_Lines) + scale(Libraries) + Code_Format + (1|Journal),
                      family = binomial,      # logistic regression
                      data = repr)

summary(mod2)

res2 <- DHARMa::simulateResiduals(mod2)

plot(res2)

# Figure 3---------------------------------------------------------------------

tiff("Figure_3.tiff", height=3.5, width=7, units='in', res=300,
     compression='lzw')

par(mar=c(4,2,1,1), oma = c(1,3,0,0), mfrow=c(1,3))

form <- ~scale(Code_Lines) + scale(Libraries) + Code_Format

# Code Lines plot
line_cat <- cut(repr$Code_Lines, c(0, 1000, 2000, 3000, 4000, 50000),
                labels = c("0-1k", "1k-2k", "2k-3k", "3k-4k",
                           "4k+"))

lintab <- table(line_cat, repr$All_Code_Runs)

n <- rowSums(lintab)
p <- lintab[,2] / n
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se
xval <- levels(line_cat)

xpos <- 1:length(xval)

plot(xpos-0.1, p, ylim = c(0, 0.8), xlim = c(0.75, 5.25), pch=19,
     ylab="Prop. running code", cex=1.3, cex.lab=1.2,
     xlab = "Code lines", xaxt='n')
axis(1, at=xpos, labels=xval)

legend('topright', legend = c("Raw data", "Model prediction"),
       lty = 1, col = c("black", "goldenrod"))

text(1, 0.77, "A", cex=2)

mtext("Prop. running code and 95% CI", side = 2, line = 1,
      outer = TRUE)

# Error bars for raw data
segments(xpos-0.1, low, xpos-0.1, up)
bw <- 0.05
n <- c(paste0("n = ", n[1]), n[2:length(n)])
for (i in 1:5){
  #text(xpos[i]-0.1, up[i] + 0.03, n[i])
  segments(xpos[i]-bw-0.1, low[i], xpos[i]+bw-0.1, low[i])
  segments(xpos[i]-bw-0.1, up[i], xpos[i]+bw-0.1, up[i])
}

# Model prediction at midpoints of bins
nd <- data.frame(Code_Lines = c(500, 1500, 2500, 3500, 4500),
                 Libraries = median(repr$Libraries, na.rm = TRUE),
                 Code_Format = factor("R script", levels=levels(repr$Code_Format)))
mf <- model.frame(form, repr)
mf <- model.frame(terms(mf), nd)
X <- model.matrix(form, mf)
pr2 <- drop(X %*% fixef(mod2))
v <- X %*% vcov(mod2) %*% t(X)
se_fit <- sqrt(diag(v))
est <- plogis(pr2)
low_fit <- plogis(pr2 - 1.96 * se_fit)
up_fit <- plogis(pr2 + 1.96 * se_fit)
points(1:5+0.1, est, cex = 1.3, pch = 19, col='goldenrod')

# Error bars for model prediction
segments(1:5+0.1, low_fit, 1:5+0.1, up_fit, col='goldenrod')
bw <- 0.05
for (i in 1:5){
  segments(i+0.1-bw, low_fit[i], i+0.1+bw, low_fit[i], col='goldenrod')
  segments(i+0.1-bw, up_fit[i], i+0.1+bw, up_fit[i], col='goldenrod')
}

# Libraries
lib_cat <- cut(repr$Libraries, c(0, 50, 100, 150, 1000),
                labels = c("0-50", "51-100", "101-150", "150+"))

libtab <- table(lib_cat, repr$All_Code_Runs)

n <- rowSums(libtab)
p <- libtab[,2] / n
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se
xval <- levels(lib_cat)

xpos <- 1:length(xval)

# Raw data plot
plot(xpos-0.1, p, ylim = c(0, 0.8), xlim = c(0.75, 4.25), pch=19,
     ylab="Prop. running code", cex=1.3, cex.lab=1.2,
     xlab = "Library dependencies", xaxt='n')
axis(1, at=xpos, labels=xval)

text(1, 0.77, "B", cex=2)

segments(xpos-0.1, low, xpos-0.1, up)
bw <- 0.1
n <- c(paste0("n = ", n[1]), n[2:length(n)])
for (i in 1:5){
  #text(xpos[i], up[i] + 0.03, n[i])
  segments(xpos[i]-bw-0.1, low[i], xpos[i]+bw-0.1, low[i])
  segments(xpos[i]-bw-0.1, up[i], xpos[i]+bw-0.1, up[i])
}

# Model prediction at midpoints of bins
nd <- data.frame(Code_Lines = median(repr$Code_Lines, na.rm = TRUE),
                 Libraries = c(25, 75, 125, 175),
                 Code_Format = factor("R script", levels=levels(repr$Code_Format)))
mf <- model.frame(form, repr)
mf <- model.frame(terms(mf), nd)
X <- model.matrix(form, mf)
pr2 <- drop(X %*% fixef(mod2))
v <- X %*% vcov(mod2) %*% t(X)
se_fit <- sqrt(diag(v))
est <- plogis(pr2)
low_fit <- plogis(pr2 - 1.96 * se_fit)
up_fit <- plogis(pr2 + 1.96 * se_fit)
points(1:4+0.1, est, cex = 1.3, pch = 19, col='goldenrod')

# Error bars for model prediction
segments(1:4+0.1, low_fit, 1:4+0.1, up_fit, col='goldenrod')
bw <- 0.05
for (i in 1:4){
  segments(i+0.1-bw, low_fit[i], i+0.1+bw, low_fit[i], col='goldenrod')
  segments(i+0.1-bw, up_fit[i], i+0.1+bw, up_fit[i], col='goldenrod')
}

# Code format
code_format <- rep(NA, nrow(repr))
code_format[repr$Word == 1 | repr$PDF == 1] <- "PDF/Word"
code_format[repr$Script == 1] <- "R script"
code_format[repr$RMarkdown == 1 | repr$Other == 1] <- "Rmd/other"
code_format <- factor(code_format, levels=c("R script", "Rmd/other",
                                            "PDF/Word"))

formtab <- table(code_format, repr$All_Code_Runs)

n <- rowSums(formtab)
p <- formtab[,2] / n
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se
xval <- levels(code_format)

xpos <- 1:length(xval)

plot(xpos-0.1, p, ylim = c(0, 0.8), xlim = c(0.75, 3.25), pch=19,
     ylab="Prop. running code", cex=1.3, cex.lab=1.2,
     xlab = "Code format", xaxt='n')
axis(1, at=xpos, labels=xval)

text(1, 0.77, "C", cex=2)

segments(xpos-0.1, low, xpos-0.1, up)
bw <- 0.05
n <- c(paste0("n = ", n[1]), n[2:length(n)])
for (i in 1:3){
  #text(xpos[i], up[i] + 0.03, n[i])
  segments(xpos[i]-bw-0.1, low[i], xpos[i]+bw-0.1, low[i])
  segments(xpos[i]-bw-0.1, up[i], xpos[i]+bw-0.1, up[i])
}

# Model predictions
nd <- data.frame(Code_Lines = median(repr$Code_Lines, na.rm = TRUE),
                 Libraries = median(repr$Libraries, na.rm = TRUE),
                 Code_Format = factor(levels(repr$Code_Format),
                                      levels = levels(repr$Code_Format)))
mf <- model.frame(form, repr)
mf <- model.frame(terms(mf), nd)
X <- model.matrix(form, mf)
pr2 <- drop(X %*% fixef(mod2))
v <- X %*% vcov(mod2) %*% t(X)
se_fit <- sqrt(diag(v))
est <- plogis(pr2)
low_fit <- plogis(pr2 - 1.96 * se_fit)
up_fit <- plogis(pr2 + 1.96 * se_fit)
points(1:3+0.1, est, cex = 1.3, pch = 19, col='goldenrod')

# Error bars for model prediction
segments(1:3+0.1, low_fit, 1:3+0.1, up_fit, col='goldenrod')
bw <- 0.05
for (i in 1:3){
  segments(i+0.1-bw, low_fit[i], i+0.1+bw, low_fit[i], col='goldenrod')
  segments(i+0.1-bw, up_fit[i], i+0.1+bw, up_fit[i], col='goldenrod')
}

dev.off()


# Objective 3 -----------------------------------------------------------------
# For papers with running code, do the outputs match the results reported in the paper?
# The sample size of papers that both (1) had running code and (2) didn't
# take too long to run was only 10 - not enough to analyze.
table(repr$All_Code_Runs, repr$Runtime_Too_Long)

# Of these, 7/10 replicated
mean(repr$Outputs_Match, na.rm = TRUE)
