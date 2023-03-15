# setwd("/Users/yueliu/YueLiu_OneDrive/Projects/sex_specific_proteomics/QC_together.svaProtectSex/mashr")
library(mashr)
library(tidyverse)
library(flashr)

beta_all <- read.csv("assoc_result_list_for_mashr.full_join.beta.csv",
  row.names = 1, check.names = F, as.is = T
)
se_all <- read.csv("assoc_result_list_for_mashr.full_join.se.csv",
  row.names = 1, check.names = F, as.is = T
)
beta_all <- as.matrix(beta_all)
se_all <- as.matrix(se_all)
data <- mash_set_data(beta_all, se_all)
Ncond <- ncol(beta_all)

anno <- read.table("~/YueLiu_OneDrive/Projects/Gene_annotation/ensembl/Homo_sapiens.GRCh37.87.chr.gff3.gene",
  as.is = T
)
anno[1:2, ]
colnames(anno)[1:5] <- c(
  "ensg", "gene",
  "chr", "start", "end"
)
anno <- anno[, c(1:5)]

####################### -accounting for measurement correlations,
#### ---there are two methods
#---accounting for measurement correlations, i.e. sample overlaps
#---method 2
# The method is described in Yuxin Zou’s thesis.

# canonical matrix
U.c <- cov_canonical(data)

# data.strong; only significant signals
m.1by1 <- mash_1by1(data)
strong <- get_significant_results(m.1by1)
data.strong <- mash_set_data(data$Bhat[strong, ], data$Shat[strong, ])

# pca
U.pca <- cov_pca(data.strong, Ncond)

# flash
U.f <- cov_flash(data.strong, factors = "nonneg", tag = "non_neg", var_type = "constant")

# data-driven matrix
# ed using pca+flash
U.ed <- cov_ed(data.strong, c(U.f, U.pca))

# method 2  mash, Ulist = c(U.ed,U.c)
V.em <- mash_estimate_corr_em(data, Ulist = c(U.ed, U.c), details = TRUE)
m.Vem <- V.em$mash.model
print(get_loglik(m.Vem), digits = 10) # log-likelihood of the fit
# [1] -199435.986

m.Vem.pm <- as.data.frame(get_pm(m.Vem))
m.Vem.pm$ensg <- rownames(m.Vem.pm)
m.Vem.pm <- left_join(m.Vem.pm, anno, by = "ensg")
m.Vem.pm[1:2, ]
rownames(m.Vem.pm) <- m.Vem.pm$ensg
write.csv(m.Vem.pm, "assoc_result_list_for_mashr.full_join.mashr.m.Vem.pm.csv", row.names = T, quote = F)

m.Vem.psd <- as.data.frame(get_psd(m.Vem))
m.Vem.psd$ensg <- rownames(m.Vem.psd)
m.Vem.psd <- left_join(m.Vem.psd, anno, by = "ensg")
m.Vem.psd[1:2, ]
rownames(m.Vem.psd) <- m.Vem.psd$ensg
write.csv(m.Vem.psd, "assoc_result_list_for_mashr.full_join.mashr.m.Vem.psd.csv", row.names = T, quote = F)

m.Vem.lfsr <- as.data.frame(get_lfsr(m.Vem))
m.Vem.lfsr$ensg <- rownames(m.Vem.lfsr)
m.Vem.lfsr <- left_join(m.Vem.lfsr, anno, by = "ensg")
m.Vem.lfsr[1:2, ]
rownames(m.Vem.lfsr) <- m.Vem.lfsr$ensg
write.csv(m.Vem.lfsr, "assoc_result_list_for_mashr.full_join.mashr.m.Vem.lfsr.csv", row.names = T, quote = F)

# from Analysis plan
# Questions:
#  i) What genes have sex difference on brain protein expression
# in at least 1 brain region? 2 brain regions? ... 6 brain regions?
# i.e. number of significant tissues per gene
tep <- get_lfsr(m.Vem)
tep.sig <- ifelse(tep < 0.05, 1, ifelse(tep >= 0.05, 0, NA))
class(tep.sig)
dim(tep.sig)
dim(tep)
# significant tissues per gene
tep.sig_n <- apply(tep.sig, 1, sum)
sum(tep.sig_n) # [1] 1630
sum(tep < 0.05, na.rm = T) # [1] 1630

# omitting signficant tissues that were NA as input
tep.sig[is.na(beta_all)] <- 0
tep.sig_no_na <- apply(tep.sig, 1, sum)
dim(beta_all)
tep.na <- apply(beta_all, 1, function(x) sum(is.na(x)))

df.sig_n <- data.frame(
  ensg = rownames(tep), N_sig = tep.sig_n,
  N_na = tep.na, N_sig_no_na = tep.sig_no_na
)
df.sig_n <- left_join(df.sig_n, anno, by = "ensg")
write.csv(df.sig_n, "assoc_result_list_for_mashr.full_join.mashr.m.Vem.n_sig.csv", row.names = F, quote = F)

df.sig_n.freq <- as.data.frame(table(df.sig_n$N_sig))
df.sig_n.freq <- df.sig_n.freq[-1, ]

df.sig_n.X <- df.sig_n[df.sig_n$chr == "X", ]
df.sig_n.X.freq <- as.data.frame(table(df.sig_n.X$N_sig))
df.sig_n.X.freq <- df.sig_n.X.freq[-1, ]
sum(df.sig_n.X$N_sig, na.rm = T) # [1] 140

df.sig_n.freq <- left_join(df.sig_n.freq, df.sig_n.X.freq, by = "Var1")
colnames(df.sig_n.freq) <- c("N_sig", "Freq", "Freq.chrX")
df.sig_n.freq$Freq.chrX.Ratio <- round(
  df.sig_n.freq$Freq.chrX / df.sig_n.freq$Freq,
  4
)
write.csv(df.sig_n.freq, "assoc_result_list_for_mashr.full_join.mashr.m.Vem.n_sig.freq.csv", row.names = F, quote = F)

# Questions:
# ii) Which genes have evidence of heterogeneity of effect of sex (direction of effect)?

both_sig <- data.frame(
  ensg = character(), tissue.1 = character(), tissue.2 = character(),
  lfsr.1 = double(), lfsr.2 = double(), pm.1 = double(), pm.2 = double()
)


for (i in 1:(Ncond - 1)) {
  for (j in (i + 1):Ncond) {
    sig_idx <- which(m.Vem.lfsr[, i] < 0.05 & m.Vem.lfsr[, j] < 0.05)
    sig_lsfr <- m.Vem.lfsr[sig_idx, ]
    sig_pm <- m.Vem.pm[sig_idx, ]
    df_add <- data.frame(
      ensg = rownames(sig_lsfr),
      tissue.1 = colnames(sig_lsfr)[i],
      tissue.2 = colnames(sig_lsfr)[j],
      lfsr.1 = sig_lsfr[, i],
      lfsr.2 = sig_lsfr[, j],
      pm.1 = sig_pm[, i],
      pm.2 = sig_pm[, j]
    )
    both_sig <- rbind(both_sig, df_add)
  }
}

both_sig[1:2, ]
both_sig$pm_1_2.sign <- ifelse(both_sig$pm.1 * both_sig$pm.2 > 0, "same",
  ifelse(both_sig$pm.1 * both_sig$pm.2 < 0, "diff", NA)
)
both_sig <- left_join(both_sig, anno, by = "ensg")
write.csv(both_sig, "assoc_result_list_for_mashr.full_join.mashr.m.Vem.pairwise_both_sig.csv", row.names = F, quote = F)

both_sig.diff <- both_sig[both_sig$pm_1_2.sign == "diff", ]
write.csv(both_sig.diff, "assoc_result_list_for_mashr.full_join.mashr.m.Vem.pairwise_both_sig_diff_sign.csv", row.names = F, quote = F)

sum(both_sig$pm_1_2.sign == "same") # [1] 1661
sum(both_sig$pm_1_2.sign == "same" & both_sig$chr == "X",
  na.rm = T
) # [1] 229
sum(both_sig$pm_1_2.sign == "diff") # [1] 19
sum(both_sig$pm_1_2.sign == "diff" & both_sig$chr == "X",
  na.rm = T
) # [1] 0


#### ---there are two methods
#---accounting for measurement correlations, i.e. sample overlaps
#---method 1
# The method is described in Urbut et al.
V.simple <- estimate_null_correlation_simple(data)
data.Vsimple <- mash_update_data(data, V = V.simple)

m.1by1 <- mash_1by1(data.Vsimple)
strong <- get_significant_results(m.1by1)
data.strong <- mash_set_data(data.Vsimple$Bhat[strong, ], data.Vsimple$Shat[strong, ],
  V = V.simple
)

# pca
U.pca <- cov_pca(data.strong, Ncond)

# flash
U.f <- cov_flash(data.strong, factors = "nonneg", tag = "non_neg", var_type = "constant")

# data-driven matrix
# ed using pca+flash
U.ed <- cov_ed(data.strong, c(U.f, U.pca))

U.c <- cov_canonical(data.Vsimple)

# mash Vsimple
m.Vsimple <- mash(data.Vsimple, Ulist = c(U.ed, U.c)) # fits with correlations because data.V includes correlation information
print(get_loglik(m.Vsimple), digits = 10)
# [1] -200293.8802
