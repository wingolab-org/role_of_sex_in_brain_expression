# setwd("/Users/yueliu/temp/temp1/sex_specific_pQTLs")
args <- commandArgs(trailingOnly = T)
library(tidyverse)
library(qvalue)

# the discovery set; e.g: the fdr<0.05 set
# args[1]="snpXsex.fdr_005.clumped_r2_05"
fdr_f <- args[1]
# the replication set
# args[2]="snpXsex.fdr_005.clumped_r2_05.in_msbb_results"
rep_f <- args[2]

# out suffix args[3]
if (length(args) > 2) {
  out <- args[3]
} else {
  out <- "merge_fdr_and_replication_set"
}




this_fdr <- read.table(fdr_f, header = T, as.is = T)
this_rep <- read.table(rep_f, header = T, as.is = T)

this_fdr$pQTL_id <- paste0(
  this_fdr$GENE, ":",
  this_fdr$SNP
)
this_rep$pQTL_id <- paste0(
  this_rep$GENE, ":",
  this_rep$SNP
)
this_fdr <- this_fdr %>% select(
  pQTL_id, GENE, A1, A2, NMISS, MAF,
  BETA, SE, P
)
this_rep <- this_rep %>% select(
  pQTL_id, A1, A2, NMISS, MAF,
  BETA, SE, P
)

both <- inner_join(this_fdr, this_rep,
  by = "pQTL_id",
  suffix = c(".fdr_set", ".replication_set")
)

both$BETA.replication_set.new <- ifelse(both$A1.fdr_set == both$A1.replication_set &
  both$A2.fdr_set == both$A2.replication_set, both$BETA.replication_set,
ifelse(both$A1.fdr_set == both$A2.replication_set &
  both$A2.fdr_set == both$A1.replication_set,
-both$BETA.replication_set, NA
)
)

both$BETA.replication_set <- both$BETA.replication_set.new
both <- both %>% select(-c(A1.replication_set, A2.replication_set, BETA.replication_set.new))
# colnames(both)
colnames(both)[3:4] <- c("A1", "A2")
both <- both[!is.na(both$BETA.replication_set), ]

this_lead <- both
this_lead <- this_lead[order(this_lead$P.fdr_set), ]
this_lead <- this_lead[!duplicated(this_lead$GENE), ]

write.table(both, paste0(out, ".txt"),
  row.names = F,
  col.names = T, quote = F
)
write.table(this_lead, paste0(out, ".lead_snp.txt"),
  row.names = F,
  col.names = T, quote = F
)

pi0 <- pi0est(p = both$P.replication_set)
pi <- 1 - pi0$pi0
lead_pi0 <- pi0est(p = this_lead$P.replication_set)
lead_pi <- 1 - lead_pi0$pi0

# nrow(this_lead)
# nrow(both)
# temp=this_fdr
# temp=temp[order(temp$P),]
# temp=temp[!duplicated(temp$GENE),]
# nrow(temp)

cat("----replication of pQTLs summary----\n")
cat("replication pi rate of pQTLs in fdr and replication set: ", round(pi, 4), "\n")
cat("pQTLs in both fdr and replication set: ", nrow(both), "\n")
cat("pQTLs with nominal pval<0.05 in replication set: ", sum(both$P.replication_set < 0.05), "\n")
cat(
  "pQTLs with nominal pval<0.05 in replication set, and same beta sign as in fdr set: ",
  sum(both$P.replication_set < 0.05 & both$BETA.fdr_set * both$BETA.replication_set > 0), "\n"
)

cat("\n----replication of lead pQTLs summary----\n")
cat("replication pi rate of lead pQTLs in fdr and replication set: ", round(lead_pi, 4), "\n")
cat("Lead pQTLs in both fdr and replication set: ", nrow(this_lead), "\n")
cat("Lead pQTLs with nominal pval<0.05 in replication set: ", sum(this_lead$P.replication_set < 0.05), "\n")
cat(
  "Lead pQTLs with nominal pval<0.05 in replication set, and same beta sign as in fdr set: ",
  sum(this_lead$P.replication_set < 0.05 & this_lead$BETA.fdr_set * this_lead$BETA.replication_set > 0), "\n"
)
