# setwd("/Users/yueliu/Box Sync/4Yue/Projects/rosmap.BA6.BA37_largeDB/proteomics_QC")

library(tidyverse)
library(sva)

args <- commandArgs(trailingOnly = T)

# expr
# args[1]="n258_residual_log2_batchsexPMIageAD.BA37.ensgID_unique_most_abun.genoID.csv"

# disease status
# args[2]="genoID_vs_ADbinary.txt"
status <- read.table(args[2], as.is = T)
# status[1:2,]
colnames(status) <- c("sampleID", "disease_status")
rownames(status) <- status$sampleID

proteomics <- read.csv(args[1], row.names = 1, check.names = F, as.is = T)


phenotype <- status
sum(is.na(phenotype$disease_status))
phenotype <- phenotype[!is.na(phenotype$disease_status), ]
sum(is.na(phenotype$disease_status))

phenotype <- phenotype[rownames(phenotype) %in% colnames(proteomics), ]
dim(phenotype)
dim(proteomics)

#---prepare the data for sva---
# make sure phenotype rownames and proteomics colnames match
proteomics <- proteomics[, rownames(phenotype)]

edata <- as.matrix(proteomics)
edata <- edata[complete.cases(edata), ]
pheno <- phenotype
dim(pheno)


#---run sva---
mod <- model.matrix(~ as.factor(disease_status), data = pheno)
# dim(mod)
dim(edata)

# mod[1:2,]
# n.sv = num.sv(edata,mod,method="leek")
n.sv <- num.sv(edata, mod, method = "be")
n.sv

mod0 <- model.matrix(~1, data = pheno)
svaobj <- sva(edata, mod, mod0, n.sv = n.sv)
svadf <- as.data.frame(svaobj$sv)
colnames(svadf) <- paste0("sva", seq(1:n.sv))
svadf <- cbind(genoid = rownames(pheno), svadf)
# svadf[1:5,]

prefix <- sub(".csv", "", args[1])
write.table(svadf, paste0(prefix, ".sva_covar.txt"), row.names = F, col.names = T, quote = F)
