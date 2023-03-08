# setwd("/Users/yueliu/YueLiu_OneDrive/Projects/sex_specific_proteomics/QC_together.svaProtectSex/combined_rosmap_banner")
library(tidyverse)
args <- commandArgs(trailingOnly = T)

# args[1]="RBM.union.ensg.final.07202020.reg_AD.expr.scale_panel.RB_subset.scale.sav_covar.txt"
# args[2]="ROSMP_Banner_MSBB.proteomicsid_to_genoid_map.master.no_head.txt"

tb <- read.table(args[1], header = T, as.is = T, check.names = F)
idname <- colnames(tb)[1]

idmap <- read.table(args[2], as.is = T)
idmap <- idmap[complete.cases(idmap), ]
idmap <- idmap[!duplicated(idmap[, 1]), ]
idmap <- idmap[!duplicated(idmap[, 2]), ]
colnames(idmap) <- c(idname, "newid")


newtb <- inner_join(idmap, tb, by = idname)
# newtb[1:2,1:5]
newtb <- newtb[, -1]
colnames(newtb)[1] <- idname

write.table(newtb, "", row.names = F, col.names = T, quote = F)
