args <- commandArgs(trailingOnly = T)
out <- read.table(args[1], header = T)
out <- out[order(out[args[2]]), ]
adj <- paste0(args[2], ".bonf")
out[adj] <- p.adjust(out[, args[2]], method = "bonferroni") # remember out[,args[2]] is a vector and out[args[2]] is a data.frame; out[,c("TWAS.P","MODELCV.PV")] is always a data frame
adj <- paste0(args[2], ".fdr")
out[adj] <- p.adjust(out[, args[2]], method = "fdr")
write.table(out, "", row.names = F, quote = F)
