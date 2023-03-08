library(tidyverse)
library(data.table)
args <- commandArgs(trailingOnly = T)

inter <- read.table(args[1], header = T, as.is = T)
addf <- read.table(args[2], as.is = T)

for (i in 1:nrow(addf)) {
  # thisf=fread(addf[i,1],select=c(2,13,6,4,11,7,10,9))
  thisf <- fread(addf[i, 1], select = c(2, 13, 6, 4, 7, 10, 9))
  thisn <- addf[i, 2]

  colnames(thisf) <- paste0("pQTL.", thisn, ".", colnames(thisf))
  colnames(thisf)[1:2] <- c("SNP", "GENE")

  inter <- left_join(inter, thisf, by = c("SNP", "GENE"))
}

write.table(inter, "", row.names = F, col.names = T, quote = F)
