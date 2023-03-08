library(qvalue)
args <- commandArgs(trailingOnly = T)
out <- read.table(args[1], header = T, check.names = F)
out <- out[order(out[args[2]]), ]
qobj <- qvalue(p = out[, args[2]])

adj <- paste0(args[2], ".qvalue")
out[adj] <- qobj$qvalues

adj <- paste0(args[2], ".fdr")
out[adj] <- p.adjust(out[, args[2]], method = "fdr")

write.table(out, "", row.names = F, quote = F)
