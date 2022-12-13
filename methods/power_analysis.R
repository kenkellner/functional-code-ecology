# Power analysis to determine adequate sample size

library(glmmTMB)
logit <- function(x) log(x / (1-x))

set.seed(123)

# Parameters
sig <- 0.05 # Group-level standard deviation
p1 <- 0.2   # baseline probability of event
p2 <- 0.3   # probability when covariate = 1

# Implied slope
b <- logit(p2) - logit(p1)

# Functio to simulate one dataset with a given sample size
# and check if covariate effect is significant at alpha = 0.05
run_one_sim <- function(n=100){
  # Number of groups
  levs <- 10
  # Random intercept adjustment for each group
  ref <- rnorm(levs, 0, sig)
  # Covariate values (standard normal, mean=0, SD=1)
  x <- rnorm(n)
  # Random effects for each data point
  group <- sample(1:levs, n, replace=T)

  # Expected value
  mn <- plogis(p1 + b*x + ref[group])
  # Response variable
  y <- rbinom(n, size=1, prob=mn)
  # Complete data frame
  dat <- data.frame(x=x, y=y, group=group)

  # Fit model
  mod <- glmmTMB::glmmTMB(y ~ x + (1|group), data=dat, family='binomial')
  # Extract coefficients
  out <- summary(mod)$coefficients$cond[2,]
  # return TRUE if p < 0.05 and effect size is in the right direction
  # i.e., positive since p2 > p1
  out[4] < 0.05 & out[1] > 0
}

# Run a bunch of sims and take the mean to get an estimate of power
power_estimate <- function(n=100, nsim=100){
  mean(sapply(1:nsim, function(x) run_one_sim(n=n)))
}

# Sample sizes to try
sample_sizes <- c(30, 50, 100, 150, 200)
names(sample_sizes) <- sample_sizes

# Run simulations for p1 = 0.2 and p2 = 0.3
scenario1 <- sapply(sample_sizes, power_estimate, nsim=100)
stopifnot(all(scenario1 == c(0.19,0.42,0.76,0.88,0.94)))

# Run simulations for p1 = 0.4 and p2 = 0.5
# Since closer to 0.5, should be lower power
p1 <- 0.4
p2 <- 0.5
b <- logit(p2) - logit(p1)

scenario2 <- sapply(sample_sizes, power_estimate, nsim=100)
stopifnot(all(scenario2 == c(0.10,0.24,0.53,0.66,0.77)))

# Plot
png("power_analysis.png")
plot(sample_sizes, scenario1,
     type='o', ylim=c(0,1), xlab="Sample size", ylab="Power", col='red')
lines(sample_sizes, scenario2,
     type='o', col='blue')
abline(h=0.8, lty=2)
legend('bottomright',title = "Effect", col=c("red","blue"), lty=1,
       legend=c("0.2 to 0.3",  "0.4 to 0.5"))
dev.off()
