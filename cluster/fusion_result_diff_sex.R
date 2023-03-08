# setwd("/Users/yueliu/temp/temp1/sex_specific_fusion")
library(tidyverse)
args <- commandArgs(trailingOnly = T)

# male args[1]
# args[1]="Jansen_AD.male.all_fusion.dat.merge.bonf-adj.csv"
male <- read.csv(args[1], as.is = T, check.names = F)

# female args[2]
# args[2]="Jansen_AD.female.all_fusion.dat.merge.bonf-adj.csv"
female <- read.csv(args[2], as.is = T, check.names = F)

# out suffix args[3]
if (length(args) > 2) {
  out <- args[3]
} else {
  out <- "fusion_assoc_diff_sex"
}


#---1. maleYes_femaleNo: male fdr<0.05 and female p>0.05
male05 <- male %>% filter(TWAS.P.fdr < 0.05)
male05 <- left_join(male05 %>% select(-c(PANEL, FILE)),
  female %>% select(-c(PANEL, FILE, CHR, P0, P1)),
  by = "ID", suffix = c(".male", ".female")
)
male05[1:2, ]
# male fdr<0.05 and female p>0.05
male05 <- male05 %>% filter(is.na(TWAS.P.female) | TWAS.P.female > 0.05)
write.csv(male05, paste0(out, ".maleYes_femaleNo.csv"),
  row.names = F, quote = F
)
write.table(male05 %>% select(1, 6), paste0(out, ".maleYes_femaleNo.gene_EQTL"),
  row.names = F, quote = F
)

#---2. femaleYes_maleNo: female fdr<0.05 and male p>0.05
female05 <- female %>% filter(TWAS.P.fdr < 0.05)

female05 <- left_join(female05 %>% select(-c(PANEL, FILE)),
  male %>% select(-c(PANEL, FILE, CHR, P0, P1)),
  by = "ID", suffix = c(".female", ".male")
)
female05[1:2, ]
# female fdr<0.05 and male p>0.05
female05 <- female05 %>% filter(is.na(TWAS.P.male) | TWAS.P.male > 0.05)
write.csv(female05, paste0(out, ".femaleYes_maleNo.csv"),
  row.names = F, quote = F
)
write.table(female05 %>% select(1, 6), paste0(out, ".femaleYes_maleNo.gene_EQTL"),
  row.names = F, quote = F
)
