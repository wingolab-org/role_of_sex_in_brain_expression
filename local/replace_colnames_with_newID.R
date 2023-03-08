# setwd("/Users/yueliu/Box Sync/4Yue/Projects/rosmap_miRNA_analysis/from_Selina/ForYue")
library(tidyverse)
args <- commandArgs(trailingOnly = T)

# df
# args[1]="simple_df.csv"
# newId to replace rownames
# args[2]="n2178.wgs_chip.allinfo.unique.with_plink_FID_IID.projid.map.two_col"

df <- read.csv(args[1], row.names = 1, check.names = F, as.is = T)
idmap <- read.table(args[2], as.is = T)
colnames(idmap) <- c("old_id", "new_id")
idmap <- idmap[complete.cases(idmap), ]

coln <- colnames(df)
m <- match(coln, idmap$old_id)
newcol <- idmap$new_id[m]

newdf <- df[, !is.na(newcol)]
colnames(newdf) <- newcol[!is.na(newcol)]
rownames(newdf) <- rownames(df)

# write.csv(newdf,"simple_df.replace_col.csv",row.names = T,quote=F)
write.csv(newdf, "", row.names = T)
