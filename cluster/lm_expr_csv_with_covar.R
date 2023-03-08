# setwd("/Users/yueliu/YueLiu_OneDrive/Projects/sex_specific_proteomics/QC_together.svaProtectSex/rosmap")
library(tidyverse)
library(ggrepel)

args <- commandArgs(trailingOnly = T)
suppressMessages(library(tidyverse))

# pheno
# args[1]="n391_residual_log2_batchMSPMIagecogdx.ensgID_unique_most_abun.csv"

# the variable of interest
# args[2]="forYue_longAll.for_proteomics_QC_keep-cogdx-na.id_vs_msex.txt"

# whether the variable of interest should be treated as factor
var_file <- read.table(args[2], as.is = T)
colnames(var_file) <- c("covarid", "var_lm")
var_file$covarid <- as.character(var_file$covarid)
if (length(args) < 3) {
  cat("need more args\n")
  q()
} else {
  if (args[3] != 0) {
    cat("variable of interest will be treated as factor\n", file = stderr())
    var_file$var_lm <- as.factor(var_file$var_lm)
  }
}

# covar;
# the first column is the id, the same as colnames in pheno
# args[4]="n391_residual_log2_batchMSPMIagecogdx.ensgID_unique_most_abun.sav_covar.txt"

# covar name that should be treated as factor
# args[5]=""

# args[6]: print flag

# covar name that should be treated as factor
if (length(args) > 4 & args[5] != 0) {
  factor.covar <- read.table(args[5], as.is = T)[, 1]
  # cat("covar names in ",args[3]," will be treated as factor\n",
  #    file=stderr())
}

covar <- read.table(args[4], header = T, check.names = F, as.is = T)
# the first column is the id, the same as colnames in pheno
colnames(covar)[1] <- "covarid"
covar$covarid <- as.character(covar$covarid) # change type here
covar <- covar[!is.na(covar$covarid), ]
covar <- covar[!duplicated(covar$covarid), ]

if (length(args) > 4 & args[5] != 0) {
  factor.list <- colnames(covar)[colnames(covar) %in% factor.covar]
  for (fa in factor.list) {
    cat(fa, " will be treated as factor\n", file = stderr())
    covar[[fa]] <- as.factor(covar[[fa]])
  }
}

# merge var of interst and covar
covar <- inner_join(var_file, covar, by = "covarid")
covar[1:2, ]


pheno <- read.csv(args[1], row.names = 1, check.names = F, as.is = T)
pheno <- pheno[, colnames(pheno) %in% covar$covarid]

# pheno.resid=pheno
covar_form <- paste(colnames(covar)[2:ncol(covar)], collapse = "+")
# lm_form
cat("lm form is expr ~ ", covar_form, "\n", file = stderr())

# adapt from Wen's code
pvalue_model <- as.data.frame(matrix(NA, nrow = dim(pheno)[1], ncol = 3))
rownames(pvalue_model) <- rownames(pheno)
colnames(pvalue_model) <- c("pvalue", "beta", "sd_beta")
for (i in 1:nrow(pheno)) {
  test_protein <- pheno[i, ]
  test_protein <- as.data.frame(t(test_protein))
  colnames(test_protein) <- "log2abundance"
  test_protein$covarid <- rownames(test_protein)
  test_protein <- left_join(test_protein, covar, by = "covarid")

  model_form <- formula(paste0("log2abundance ~", covar_form))
  model_i <- summary(lm(model_form, data = test_protein, na.action = na.exclude))
  pvalue_model[i, 1] <- model_i$coefficients[2, 4]
  pvalue_model[i, 2] <- model_i$coefficients[2, 1]
  pvalue_model[i, 3] <- model_i$coefficients[2, 2]
}

pvalue_model$fdr <- p.adjust(pvalue_model$pvalue, method = "fdr", n = length(pvalue_model$pvalue))
pvalue_model$bonferroni <- p.adjust(pvalue_model$pvalue, method = "bonferroni", n = length(pvalue_model$pvalue))
pvalue_model <- pvalue_model[order(pvalue_model$pvalue), ]

if (length(args) > 5 & args[6] != 0) {
  prefix <- args[6]
} else {
  prefix <- paste0(sub(".csv", "", args[1]), ".lm")
}

# prefix="n391_residual_log2_batchMSPMIagecogdx.ensgID_unique_most_abun.lm_sex_with_sva"
write.csv(pvalue_model, paste0(prefix, ".pval.csv"))

######## Function for qq plot with -log10 pvalues
myqq <- function(pvector, title = "Quantile-Quantile Plot of -log10(P-values)", add = FALSE, colour = "blue", lty = 1) {
  o <- -log10(sort(pvector, decreasing = F))
  e <- -log10(1:length(o) / length(o))
  if (!add) {
    plot(e, o, main = title, xlim = c(0, max(e)), ylim = c(0, max(o[o < Inf])), col = colour, xlab = "expectation", ylab = "observation")
    abline(0, 1)
  } else {
    points(e, o, col = colour)
  }
}
png(paste0(prefix, ".qq.png"), width = 6, height = 6, units = "in", res = 300)
myqq(pvalue_model$pvalue)
dev.off()
