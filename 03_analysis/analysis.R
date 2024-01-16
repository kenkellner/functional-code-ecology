library(lme4)
library(DHARMa)

# Read in datasets-------------------------------------------------------------

# Included papers
incl <- read.csv("included_papers_final.csv")

# Journal information
jour <- read.csv("journal_data.csv")

# Merge journal data into included papers dataset
incl <- merge(incl, jour, by = c("Journal", "Year"))

# Potentially reproducible papers
repr <- read.csv("reproducible_papers_final.csv")

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

res <- DHARMa::simulateResiduals(mod1)
plot(res)

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
