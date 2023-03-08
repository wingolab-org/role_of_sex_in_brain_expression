# setwd("/Users/yueliu/Box Sync/4Yue/Projects/shared_genes_among_multi_proteomics_datasets/sva_adjust")
args <- commandArgs(trailingOnly = T)
suppressMessages(library(tidyverse))

# pheno
# args[1]="../RBM.union.ensg.final.07202020.reg_AD.expr.scale_panel.genoID.RB_subset.csv"

# covar;
# the first column is the id, the same as colnames in pheno
# args[2]="sva_RB.txt"

# covar name that should be treated as factor
# args[3]=""

# args[4]: print flag

# covar name that should be treated as factor
if (length(args) > 2 & args[3] != 0) {
  factor.covar <- read.table(args[3], as.is = T)[, 1]
  # cat("covar names in ",args[3]," will be treated as factor\n",
  #    file=stderr())
}

covar <- read.table(args[2], header = T, check.names = F, as.is = T)
# the first column is the id, the same as colnames in pheno
colnames(covar)[1] <- "covarid"
covar$covarid <- as.character(covar$covarid) # change type here
covar <- covar[!is.na(covar$covarid), ]
covar <- covar[!duplicated(covar$covarid), ]

if (length(args) > 2 & args[3] != 0) {
  factor.list <- colnames(covar)[colnames(covar) %in% factor.covar]
  for (fa in factor.list) {
    cat(fa, " will be treated as factor\n", file = stderr())
    covar[[fa]] <- as.factor(covar[[fa]])
  }
}

pheno <- read.csv(args[1], row.names = 1, check.names = F, as.is = T)
pheno <- pheno[, colnames(pheno) %in% covar$covarid]

pheno.resid <- pheno
covar_form <- paste(colnames(covar)[2:ncol(covar)], collapse = "+")
# covar_form
cat("covariates are: \n", covar_form, "\n", file = stderr())
for (i in 1:nrow(pheno)) {
  test_protein <- pheno[i, ]
  test_protein <- as.data.frame(t(test_protein))
  colnames(test_protein) <- "log2abundance"
  test_protein$covarid <- rownames(test_protein)
  test_protein <- left_join(test_protein, covar, by = "covarid")

  model_form <- formula(paste0("log2abundance ~", covar_form))
  pheno.resid[i, ] <- resid(lm(model_form, data = test_protein, na.action = na.exclude))
}

# cat("\n---pheno and pheno.resid correlation summary:---\n")
dim(pheno)
dim(pheno.resid)
# pheno[1:2,1:2]
# pheno.resid[1:2,1:2]
# cor.test(as.numeric(pheno[1,]),as.numeric(pheno.resid[1,])) #0.9988
# cor.test(as.numeric(pheno[2,]),as.numeric(pheno.resid[2,])) #0.8914
# cort=cor.test(as.numeric(pheno[3,]),as.numeric(pheno.resid[3,])) #0.9288962
# cort$estimate

# pheno.cor=pheno
# pheno.cor$cor=NA
# for(i in 1:nrow(pheno)){
#  cort=cor.test(as.numeric(pheno[i,]),as.numeric(pheno.resid[i,]))
#  pheno.cor[i,"cor"]=cort$estimate
# }
# pheno.cor=pheno.cor$cor
# cat ("correlation between original and residuals after regression:\n")
# summary(pheno.cor)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 0.5288  0.9525  0.9851  0.9620  0.9967  1.0000
# length(pheno.cor) #[1] 8606
# sum(pheno.cor<0.9,na.rm=T)#[1] 944
# sum(pheno.cor<0.8,na.rm=T)#[1] 241

# write.csv(pheno.resid,"test.csv")
if (length(args) > 3 & args[4] != 0) { # print to args[4]
  write.csv(pheno.resid, args[4])
} else {
  write.csv(pheno.resid, paste0(args[1], ".resid.csv"))
}

# pheno["ENSG00000000419",1:2]
# test1=as.data.frame(t(pheno["ENSG00000000419",]))
# colnames(test1)='log2abundance'
# rownames(test1)[1:2]
# test1$covarid=rownames(test1)
# test1=left_join(test1,covar,by='covarid')
# test1[1:2,]
# covar_form
# model_form=formula(paste0("log2abundance ~",covar_form))
# model_form
# test1.resid=resid(lm(model_form,data=test1,na.action=na.exclude))
# test1.resid[1:5]
# pheno.resid["ENSG00000000419",1:5]
