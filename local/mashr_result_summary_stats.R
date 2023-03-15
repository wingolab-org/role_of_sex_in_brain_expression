setwd("/Users/yueliu/YueLiu_OneDrive/Projects/sex_specific_proteomics/QC_together.svaProtectSex/mashr")
library(tidyverse)

lfsr <- read.csv("assoc_result_list_for_mashr.full_join.mashr.m.Vem.lfsr.csv",
    as.is = T, row.names = 1
)
beta <- read.csv("assoc_result_list_for_mashr.full_join.mashr.m.Vem.pm.csv",
    as.is = T, row.names = 1
)
lfsr[1:2, ]
dim(lfsr) # [1] 10198    11
dim(beta)
all(lfsr$ensg == beta$ensg) # [1] TRUE

sum(lfsr$rosban_dPFC < 0.05, na.rm = T)
sum(lfsr$rosban_dPFC < 0.05 & beta$rosban_dPFC > 0, na.rm = T)
sum(lfsr$rosban_dPFC < 0.05 & beta$rosban_dPFC < 0, na.rm = T)


f005 <- as.data.frame(matrix(NA, nrow = 6, ncol = 3))
rownames(f005) <- colnames(lfsr)[1:6]
colnames(f005) <- c("lfsr_005", "lfsr_005.pos", "lfsr_005.neg")
for (rname in rownames(f005)) {
    f005[rname, "lfsr_005"] <- sum(lfsr[, rname] < 0.05, na.rm = T)
    f005[rname, "lfsr_005.pos"] <- sum(lfsr[, rname] < 0.05 & beta[, rname] > 0,
        na.rm = T
    )
    f005[rname, "lfsr_005.neg"] <- sum(lfsr[, rname] < 0.05 & beta[, rname] < 0,
        na.rm = T
    )
}
f005
write.csv(f005, "mashr_result_summary_stats.lfdr_005.csv",
    row.names = T, quote = F
)
