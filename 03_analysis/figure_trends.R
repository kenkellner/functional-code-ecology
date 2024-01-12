incl <- read.csv("included_papers_final.csv")
repr <- read.csv("reproducible_papers_final.csv")

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
