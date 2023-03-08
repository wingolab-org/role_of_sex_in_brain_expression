#in /home/yliu/work_dir/ProteinPrediction/sex_specific_proteomics/QC_together.svaProtectSex/protein_GenoxSex/combined_rosmap_bannercombined_rosmap_banner/

#SampleID-map.xonly_addgene.plus_chrX.list.cat
$f = shift;

#gene list: snpXsex.fdr_010.clumped_r2_05.gene
$gl = shift;
open( G, "$gl" );
while (<G>) {
  if (/(\S+)/) {
    $have{$1} = 1;
  }
}

open( F, "$f" );
while (<F>) {
  chomp;
  @ay = split( /\s+/, $_ );
  if ( $have{ $ay[12] } ) {
    print $ay[1], "\n";
  }
}
