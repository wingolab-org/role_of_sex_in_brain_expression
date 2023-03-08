# setwd("/Users/yueliu/Box Sync/4Yue/Projects/rosmap.BA6.BA37_largeDB/proteomics_QC")

library(tidyverse)
args <- commandArgs(trailingOnly = T)

# args[1]="protein_proteomics_step0.without_GIS.csv"
# args[1]="./rosmap_batchMSPMIagecogdx.lm_sex_with_sva.pval.csv"
if (length(args) > 1) {
  ensg_f <- args[2]
} else {
  ensg_f <- "~/YueLiu_OneDrive//Projects/Gene_annotation/ensembl/Homo_sapiens.GRCh37.87.chr.gff3.gene"
}
# ensg id and uniprot id map
ensg <- read.table(ensg_f,
  header = F,
  na.strings = c("", "NA"), as.is = T
)
# colnames(ensg)
colnames(ensg)[1:5] <- c("ensgid", "gene", "ensg_chr", "ensg_start", "ensg_end")

df <- read.csv(args[1], row.names = 1, check.names = F, as.is = T)
df$ensgid <- rownames(df)
df <- left_join(df, ensg[, 1:5], by = "ensgid")
# df[1:4,]
rownames(df) <- df$ensgid

prefix <- sub(".csv", "", args[1])
write.csv(df, paste0(prefix, ".add_anno.csv"),
  row.names = T
)
