incl <- read.csv("included_papers_final.csv")
repr <- read.csv("reproducible_papers_final.csv")

# Included
tiff("code_and_data.tiff", height=7, width=7, units='in', res=300,
     compression='lzw')

par(mar=c(4,4,1,1))
layout(matrix(c(1, 2,
                3, 3), ncol=2, nrow=2, byrow=TRUE))

tab <- table(incl$Year, incl$All_Data)
n <- rowSums(tab)
p <- tab[,2] / n
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se
yrs <- 2018:2022

plot(yrs, p, ylim = c(0, 0.85), pch=19,
     ylab="Prop. with data", cex=1.3, cex.axis=1.1,
     xlab = "", xlim=c(2017.5, 2022.5))
lines(yrs, p, lty=2)
segments(yrs, low, yrs, up)
bw <- 0.1
for (i in 1:5){
  segments(yrs[i]-bw, low[i], yrs[i]+bw, low[i])
  segments(yrs[i]-bw, up[i], yrs[i]+bw, up[i])
}
text(2018, 0.8, "A", cex=2)

incl$Possible_Reproduce <- incl$All_Data & incl$All_Code

tab <- table(incl$Year, incl$Possible_Reproduce)
n <- rowSums(tab)
p <- tab[,2] / n
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se
yrs <- 2018:2022

plot(yrs, p, ylim = c(0, 0.85), pch=19,
     ylab="Prop. with code and data", cex=1.3, cex.axis=1.1,
     xlab = "", xlim=c(2017.5, 2022.5))
lines(yrs, p, lty=2)
segments(yrs, low, yrs, up)
bw <- 0.1
for (i in 1:5){
  segments(yrs[i]-bw, low[i], yrs[i]+bw, low[i])
  segments(yrs[i]-bw, up[i], yrs[i]+bw, up[i])
}
text(2018, 0.8, "B", cex=2)

tab <- table(incl$Journal, incl$Possible_Reproduce)
n <- rowSums(tab)
p <- tab[,2] / n
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se

journal_short <- c("BioCon","ConBio","Ecol","EcolEvol","EcoSph","JWM","MEE",
                   "PLoS","SciRep")
nj <- length(journal_short)

plot(1:nj, p, xaxt='n', cex=1.3, cex.axis=1.1,
     ylim=c(0,0.85), pch=19, xlab="Journal", ylab="Prop. with code and data")
axis(1, at=1:nj, labels=journal_short)
segments(1:nj, low, 1:nj, up)
bw <- 0.1
for (i in 1:nj){
  segments(i-bw, low[i], i+bw, low[i])
  segments(i-bw, up[i], i+bw, up[i])
}
text(1, 0.8, "C", cex=2)

mtext("Year", line = 1.2, cex=0.8)

dev.off()

tiff("running_code.tiff", height=6, width=7, units='in', res=300,
     compression='lzw')

par(mar=c(4,4,1,1))
layout(matrix(c(1, 2, 3, 3,
                4, 4, 4, 4), ncol=4, nrow=2, byrow=TRUE))

# Code runs
hist(repr$Code_Lines, breaks=15, xlab = "Code lines", main="")
text(15000, 65, "A", cex=2)
hist(repr$Libraries, breaks = 15, xlab = "Dependencies", main="")
text(150, 19.6, "B", cex=2)

tab <- table(repr$Year, repr$All_Code_Runs)
n <- rowSums(tab)
p <- tab[,2] / n
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se
yrs <- 2018:2022

plot(yrs, p, ylim = c(0, 0.75), pch=19,
     ylab="Prop. running code", cex=1.3, cex.axis=1.1,
     xlab = "Year", xlim=c(2017.5, 2022.5))
lines(yrs, p, lty=2)
segments(yrs, low, yrs, up)
bw <- 0.1
for (i in 1:5){
  segments(yrs[i]-bw, low[i], yrs[i]+bw, low[i])
  segments(yrs[i]-bw, up[i], yrs[i]+bw, up[i])
}
text(2022, 0.665, "C", cex=2)

tab <- table(repr$Journal, repr$All_Code_Runs)
n <- rowSums(tab)
p <- tab[,2] / n
se <- sqrt((p*(1-p))/n)
low <- p - 1.96*se
up <- p + 1.96*se

journal_short <- c("BioCon","ConBio","Ecol","EcolEvol","EcoSph","JWM","MEE",
                   "PLoS","SciRep")
nj <- length(journal_short)

n <- table(repr$Journal)

plot(1:nj, p, xaxt='n', cex=1.3, cex.axis=1.1,
     ylim=c(0,0.7), pch=19, xlab="Journal", ylab="Prop. running code")
axis(1, at=1:nj, labels=journal_short)
segments(c(1,3:nj), low[c(1,3:nj)], c(1,3:nj), up[c(1,3:nj)])
bw <- 0.1

up[2] <- p[2]
for (i in 1:nj){
  if(i==1){
    text(i, up[i] + 0.05, paste0("n = ", n[i]))
  } else {
    text(i, up[i] + 0.05, n[i])
  }
  if(i==2) next
  segments(i-bw, low[i], i+bw, low[i])
  segments(i-bw, up[i], i+bw, up[i])
}
abline(h = mean(repr$All_Code_Runs, na.rm=TRUE), lty=2)
text(nj, 0.65, "D", cex=2)

dev.off()

# Predictors

tiff("predictors.tiff", height=4, width=7, units='in', res=300,
     compression='lzw')

par(mar=c(4,2,1,1), mfrow=c(1,3), oma = c(1,3,0,0))


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

plot(xpos, p, ylim = c(0, 0.8), xlim = c(0.75, 5.25), pch=19,
     ylab="Prop. running code", cex=1.3, cex.axis=1.1,
     xlab = "Code lines", xaxt='n')
axis(1, at=xpos, labels=xval, cex.lab=1.2)

segments(xpos, low, 1:length(xval), up)
bw <- 0.1
n <- c(paste0("n = ", n[1]), n[2:length(n)])
for (i in 1:5){
  text(xpos[i], up[i] + 0.03, n[i])
  segments(xpos[i]-bw, low[i], xpos[i]+bw, low[i])
  segments(xpos[i]-bw, up[i], xpos[i]+bw, up[i])
}
abline(h = mean(repr$All_Code_Runs, na.rm=TRUE), lty=2)

mtext("Prop. articles with running code", 2, line=3, cex=0.8)

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

plot(xpos, p, ylim = c(0, 0.8), xlim = c(0.75, 4.25), pch=19,
     ylab="Prop. running code", cex=1.3, cex.axis=1.1,
     xlab = "Library dependencies", xaxt='n')
axis(1, at=xpos, labels=xval, cex.lab=1.2)

segments(xpos, low, 1:length(xval), up)
bw <- 0.1
n <- c(paste0("n = ", n[1]), n[2:length(n)])
for (i in 1:5){
  text(xpos[i], up[i] + 0.03, n[i])
  segments(xpos[i]-bw, low[i], xpos[i]+bw, low[i])
  segments(xpos[i]-bw, up[i], xpos[i]+bw, up[i])
}
abline(h = mean(repr$All_Code_Runs, na.rm=TRUE), lty=2)


# Format

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

plot(xpos, p, ylim = c(0, 0.8), xlim = c(0.75, 3.25), pch=19,
     ylab="Prop. running code", cex=1.3, cex.axis=1.1,
     xlab = "Code format", xaxt='n')
axis(1, at=xpos, labels=xval, cex.lab=1.2)

segments(xpos, low, 1:length(xval), up)
bw <- 0.1
n <- c(paste0("n = ", n[1]), n[2:length(n)])
for (i in 1:5){
  text(xpos[i], up[i] + 0.03, n[i])
  segments(xpos[i]-bw, low[i], xpos[i]+bw, low[i])
  segments(xpos[i]-bw, up[i], xpos[i]+bw, up[i])
}
abline(h = mean(repr$All_Code_Runs, na.rm=TRUE), lty=2)

dev.off()

library(MASS)

mod <- glmmPQL(All_Code_Runs ~ Code_Lines + Libraries + code_format,
               random = ~1 | Journal, family = binomial, data = repr)
summary(mod)
