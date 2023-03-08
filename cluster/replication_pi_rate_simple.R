library(qvalue)

args <- commandArgs(trailingOnly = T)
out <- read.table(args[1], header = T, check.names = F, as.is = T)
# out=out[order(out[args[2]]),]
outp <- na.omit(out[, args[2]])
pi0 <- pi0est(p = outp)
pi <- 1 - pi0$pi0
cat("pi=", pi, "\n")
