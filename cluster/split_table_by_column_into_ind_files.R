args <- commandArgs(trailingOnly = T)

df <- read.table(args[1], as.is = T, header = T, check.names = F)

# split_col=as.numeric(args[2])
split_col <- args[2] # the column name for split

out <- split(df, f = df[, split_col])

for (n in names(out)) {
  outn <- paste0("split.", n)
  write.table(out[[n]], outn, row.names = F, col.names = T, quote = F)
}
