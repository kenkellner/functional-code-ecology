# Power analysis to determine adequate sample size

library(MASS)
logit <- function(x) log(x / (1-x))

set.seed(123)

# Parameters
sig <- 0.1 # Group-level standard deviation
p1 <- 0.2   # baseline probability of event
p2 <- 0.3   # probability when covariate = 1

# Implied slope
b <- logit(p2) - logit(p1)

# Check math
stopifnot(plogis(logit(p1)) == 0.2)
stopifnot(round(plogis(logit(p1) + b*1), 5) == 0.3)

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
  mn <- plogis(logit(p1) + b*x + ref[group])
  # Response variable
  y <- rbinom(n, size=1, prob=mn)
  # Complete data frame
  dat <- data.frame(x=x, y=y, group=group)

  # Fit model
  mod <- MASS::glmmPQL(y ~ x, random = ~ 1 | group, data=dat, family=binomial,
                       verbose=FALSE)
  # Extract coefficients
  out <- summary(mod)$tTable[2,c(1,2,4,5)]
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
stopifnot(all(scenario1 == c(0.28,0.34,0.49,0.73,0.87)))

# Bigger effect size
# Run simulations for p1 = 0.3 and p2 = 0.5
p1 <- 0.2   # baseline probability of event
p2 <- 0.4   # probability when covariate = 1

# Implied slope
b <- logit(p2) - logit(p1)

scenario2 <- sapply(sample_sizes, power_estimate, nsim=100)
stopifnot(all(scenario2 == c(0.39,0.66,0.97,1,1)))

# Run simulations for p1 = 0.4 and p2 = 0.6
# Since closer to 0.5, should be lower power
p1 <- 0.4
p2 <- 0.6
b <- logit(p2) - logit(p1)

scenario3 <- sapply(sample_sizes, power_estimate, nsim=100)
stopifnot(all(scenario3 == c(0.45,0.67,0.95,1,1)))

# Plot
png("power_analysis.png")
plot(sample_sizes, scenario1,
     type='o', ylim=c(0,1), xlab="Sample size", ylab="Power", col='red')
lines(sample_sizes, scenario2,
     type='o', col='blue')
lines(sample_sizes, scenario3,
     type='o', col='green')
abline(h=0.8, lty=2)
legend('bottomright',title = "Effect size", col=c("red","blue","green"), lty=1,
       legend=c("0.2 to 0.3",  "0.2 to 0.4", "0.4 to 0.6"))
dev.off()
