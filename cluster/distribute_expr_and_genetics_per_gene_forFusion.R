# setwd("/Users/yueliu/temp/stage_to_mv")
suppressMessages(library("optparse"))

option_list <- list(
  make_option("--expr",
    action = "store", default = NA, type = "character",
    help = "gene/individual expr matrix csv file [required]"
  ),
  make_option("--anno",
    action = "store", default = NA, type = "character",
    help = "gene anno file with gene coordiante [required]"
  ),
  make_option("--plink",
    action = "store", default = NA, type = "character",
    help = "plink file prefix ;genetics data in plink format  [required]"
  ),
  make_option("--PATH_plink",
    action = "store", default = "plink", type = "character",
    help = "Path to plink executable [%default]"
  ),
  make_option("--outdir",
    action = "store", default = NA, type = "character",
    help = "dir name to output per gene files [required]"
  ),
  make_option("--window_size",
    action = "store", default = NA, type = "double",
    help = "window size around the gene [required]"
  ),
  make_option("--verbose",
    action = "store", default = 1, type = "integer",
    help = "How much chatter to print: 1=minimal; 2=all [default: %default]"
  )
)

opt <- parse_args(OptionParser(option_list = option_list))

if (opt$verbose == 2) {
  SYS_PRINT <- F
} else {
  SYS_PRINT <- T
}

# create output dir
# test_out="forFusion/gene-windowsize-100k"
# opt$outdir="forFusion/gene-windowsize-100k"
if (!dir.exists(opt$outdir)) {
  arg <- paste0("mkdir -p ", opt$outdir)
  system(arg, ignore.stdout = SYS_PRINT, ignore.stderr = SYS_PRINT)
}

# opt$expr="test.expr.csv"
expr <- read.csv(opt$expr, check.names = F, row.names = 1, header = T, as.is = T)
# expr[1:2,1:2]
# opt$anno="ALL_CEU_RNA_Seq_SVAadusted_DiagnosisRegressed.anno.autosome.txt"
anno <- read.table(opt$anno,
  check.names = F, header = T, as.is = T
)
colnames(anno) <- toupper(colnames(anno))
anno <- anno[!duplicated(anno$GENEID), ]
rownames(anno) <- anno$GENEID
# anno[1:2,]
genes <- intersect(rownames(expr), rownames(anno))
# genes
if (length(genes) == 0) {
  cat("no shared gene between expr and anno; id check?\n")
  q()
} else if (length(genes) < 10) {
  cat("fewer than 10 shared gene between expr and anno; id check?\n")
  # q()
}

# opt$plink="All_CEU_ToTrainForTWAS.update_id"
fam_name <- paste0(opt$plink, ".fam")
fam <- read.table(fam_name, header = F, check.names = F, as.is = T)
iids <- intersect(fam$V2, colnames(expr))
# iids
if (length(iids) == 0) {
  cat("no shared samples between expr and plink; id check?\n")
  q()
} else if (length(iids) < 10) {
  cat("fewer than 10 shared samples between expr and plink; id check?\n")
  # q()
}

expr <- expr[genes, iids]
# dim(expr)

for (gene in genes) {
  # cat(gene,"\n")

  #--mkdir
  gene_dir <- paste0(opt$outdir, "/", gene)
  if (!dir.exists(gene_dir)) {
    arg <- paste0("mkdir -p ", gene_dir)
    system(arg, ignore.stdout = SYS_PRINT, ignore.stderr = SYS_PRINT)
  }

  #--extract genetics from plink
  out_plink <- paste0(gene_dir, "/", gene, ".plink")
  start <- as.numeric(anno[gene, "START"]) - opt$window_size
  if (start < 1) {
    start <- 1
  }
  end <- as.numeric(anno[gene, "END"]) + opt$window_size
  arg <- paste0(
    opt$PATH_plink, " --bfile ", opt$plink, " --chr ",
    anno[gene, "CHR"], " --from-bp ", start, " --to-bp ", end,
    " --make-bed --out ", out_plink
  )
  system(arg, ignore.stdout = SYS_PRINT, ignore.stderr = SYS_PRINT)

  #--extract expr
  gene_expr <- as.data.frame(t(expr[gene, ]))
  gene_expr$V2 <- rownames(gene_expr)
  gene_expr$V3 <- rownames(gene_expr)
  gene_expr <- gene_expr[, c(2, 3, 1)]
  out_pheno <- paste0(gene_dir, "/", gene, ".pheno")
  write.table(gene_expr, out_pheno, row.names = F, col.names = F, quote = F)

  #--update final plink file with both genetics and expr
  out_keep <- paste0(gene_dir, "/", gene, ".keep")
  arg <- paste0(
    opt$PATH_plink, " --bfile ", out_plink, " --keep ", out_pheno,
    " --pheno ", out_pheno, " --make-bed --out ", out_keep
  )
  system(arg, ignore.stdout = SYS_PRINT, ignore.stderr = SYS_PRINT)
}
