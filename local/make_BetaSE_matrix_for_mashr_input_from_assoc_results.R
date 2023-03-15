# setwd("/Users/yueliu/YueLiu_OneDrive/Projects/sex_specific_proteomics/QC_together.svaProtectSex/mashr")
library(tidyverse)
library(plyr)
args <- commandArgs(trailingOnly = T)

# input is a assoc result file list, with beta and se info: e.g:
# metal.rosmap_banner.stderr_scheme.1.tbl.add_fdr.add_col.csv     rosban_dPFC
# n186_residual_log2_batchPMIageCDR.ensgID_unique_most_abun.scale.lm_sex_with_sva.pval.csv        msbb_pgyrus

# NOTE: the rowname is the id

flist <- read.table(args[1], as.is = T)

output_prefix <- args[2]


if (length(args) > 2) {
  beta_name <- args[3]
} else {
  beta_name <- "BETA"
}

if (length(args) > 3) {
  se_name <- args[4]
} else {
  se_name <- "SE"
}

betalist <- list()
selist <- list()

for (i in 1:nrow(flist)) {
  if (file.exists(flist[i, 1])) {
    assoc <- read.csv(flist[i, 1], row.names = 1, check.names = F, as.is = T)
    cond <- flist[i, 2]

    this_beta <- data.frame(v1 = assoc[[beta_name]], v2 = rownames(assoc))
    colnames(this_beta) <- c(cond, "join_id")
    betalist[[i]] <- this_beta

    this_se <- data.frame(v1 = assoc[[se_name]], v2 = rownames(assoc))
    colnames(this_se) <- c(cond, "join_id")
    selist[[i]] <- this_se
  } else {
    cat(flist[i, 1], " file doesn't exist; quit\n", file = stderr())
    q()
  }
}

all_beta <- join_all(betalist, by = "join_id", type = "full")
rownames(all_beta) <- all_beta$join_id
all_beta <- all_beta %>% select(-join_id)

all_se <- join_all(selist, by = "join_id", type = "full")
rownames(all_se) <- all_se$join_id
all_se <- all_se %>% select(-join_id)

write.csv(all_beta, paste0(output_prefix, ".full_join.beta.csv"),
  row.names = T, quote = F
)
write.csv(all_se, paste0(output_prefix, ".full_join.se.csv"),
  row.names = T, quote = F
)
