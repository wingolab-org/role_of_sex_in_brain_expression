args <- commandArgs(trailingOnly = T)
df <- read.table(args[1], header = T, as.is = T)
if ("N" %in% colnames(df)) {
  Nmean <- round(mean(df$N, na.rm = T))
} else {
  Nmean <- "NA"
}
cat(Nmean, "\n")
