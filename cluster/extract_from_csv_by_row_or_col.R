args <- commandArgs(trailingOnly = T)
df <- read.csv(args[1], check.names = FALSE, row.names = 1, as.is = T)
exlist <- read.table(args[2], as.is = T)$V1
if (args[3] == 1) { # extract by row.names
  subdf <- df[rownames(df) %in% exlist, ]
  write.csv(subdf, "", row.names = T)
} else if (args[3] == 2) { # extract by col.names
  subdf <- df[, colnames(df) %in% exlist]
  write.csv(subdf, "", row.names = T)
} else {
  cat("must be extracted by rownames 1 or colnames 2\n")
  q()
}
