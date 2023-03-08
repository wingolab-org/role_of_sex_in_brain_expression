args <- commandArgs(trailingOnly = T)
df <- read.csv(args[1], check.names = F, as.is = T, row.names = 1)

if (args[2] == 1) { # rownames
  ids <- rownames(df)
} else if (args[2] == 2) { # colnames
  ids <- colnames(df)
} else {
  cat("need args[2]; 1:rownames; 2:colnames\n")
}

write(ids, "")
