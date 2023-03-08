# setwd("/Users/yueliu/YueLiu_OneDrive/Projects/combine_multi_proteomics_sets/RB")
library(tidyverse)
args <- commandArgs(trailingOnly = T)

# args[1]="RB.path.reg_AD"
path <- read.table(args[1], as.is = T)
# 1st_col expr.path 2nd_col set.name
colnames(path) <- c("path", "name")
pathN <- length(path$path)
pathN # [1] 2

# initial 1st set; for combine proteomics data
comb <- read.csv(path[1, 1], row.names = 1, as.is = T, check.names = F)
dim(comb) # [1] 8179  393
# add suffx to proteomicsid; diff data may have same proteomicsid
colnames(comb) <- paste0(colnames(comb), ".", path[1, 2])
# gene_key for combine key
comb$gene_key <- rownames(comb)


# initial 1st set; for combine gene name, for record;
# it keeps which gene in which data set
comb_name <- data.frame(gene_key = comb$gene_key, set_name = 1)
colnames(comb_name)[2] <- path[1, 2]
comb_name[1:2, ]

# combining by full_join
for (i in 2:pathN) {
  this <- read.csv(path[i, 1], row.names = 1, as.is = T, check.names = F)
  colnames(this) <- paste0(colnames(this), ".", path[i, 2])
  this$gene_key <- rownames(this)
  comb <- full_join(comb, this, by = "gene_key")

  this_name <- data.frame(gene_key = this$gene_key, set_name = 1)
  colnames(this_name)[2] <- path[i, 2]
  comb_name <- full_join(comb_name, this_name, by = "gene_key")
}

dim(comb) # [1] 8609  591
dim(comb_name)
comb[1:2, 1:2]
comb_name[1:2, ]
rownames(comb) <- comb$gene_key
comb <- comb %>% select(-gene_key)
sum(is.na(comb_name[, 2])) # [1] 430
sum(is.na(comb_name[, 3])) # [1] 1076

write.csv(comb, paste0(args[1], ".comb.csv"))
write.table(comb_name, paste0(args[1], ".comb.gene_table"),
  row.names = F,
  col.names = T, quote = F
)
