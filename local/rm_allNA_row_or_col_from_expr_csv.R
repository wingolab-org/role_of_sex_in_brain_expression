args <- commandArgs(trailingOnly = T)

expr <- read.csv(args[1], row.names = 1, check.names = F, as.is = T)

if (args[2] == 1) { # remove rows that are all NA
  rm <- apply(expr, 1, function(x) all(is.na(x)))
  expr_new <- expr[!rm, ]
} else if (args[2] == 2) { # remove cols that are all NA
  rm <- apply(expr, 2, function(x) all(is.na(x)))
  expr_new <- expr[, !rm]
} else {
  cat("need args[2]; 1:remove rows that are all NA\n;2:remove cols that are all NA\n")
  q()
}
write.csv(expr_new, "")
