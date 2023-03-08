library(tidyverse)
args <- commandArgs(trailingOnly = T)

df <- read.table(args[1], header = T, as.is = T)
dim(df)
df$pQTL_id <- paste0(df$GENE, ":", df$SNP)
df[1:2, ]

# per gene, sort by Pval
df1 <- df[order(df$GENE, df$P), ]
df1[1:2, ]

# top pQTL per gene
df1top <- df1[!duplicated(df1$GENE), ]

# beta and se for mashr
write.csv(df %>% select(pQTL_id, BETA), paste0(args[1], ".for_mashr.beta.csv"),
    row.names = F, quote = F
)
write.csv(df %>% select(pQTL_id, SE), paste0(args[1], ".for_mashr.se.csv"),
    row.names = F, quote = F
)

# top pQTL per gene for mashr
write.csv(df1top, paste0(args[1], ".for_mashr.top_pQTL.csv"),
    row.names = F, quote = F
)
write.csv(df1top %>% select(pQTL_id, BETA), paste0(args[1], ".for_mashr.top_pQTL.beta.csv"),
    row.names = F, quote = F
)
write.csv(df1top %>% select(pQTL_id, SE), paste0(args[1], ".for_mashr.top_pQTL.se.csv"),
    row.names = F, quote = F
)
