$fam_N = shift
  ; #gene N: e.g /home/yliu/work_dir/ProteinPrediction/Outside_data_10012019/Combine_data_from_ROSMAP_Banner_MSBB/genes.combined_ROSMAP_Banner_MSBB.subset_to_fusion_LDREF/SampleID-map.nonNAfam.fam.N.per_gene.txt
$pos = shift
  ; #train_weights.pos: e.g /home/yliu/work_dir/ProteinPrediction/Outside_data_10012019/Combine_data_from_ROSMAP_Banner_MSBB/genes.combined_ROSMAP_Banner_MSBB.subset_to_fusion_LDREF/SampleID-map.nonNAfam.fusion.WEIGHTS/train_weights.pos

$default = shift;
if ( !$default ) {
  $default = "NA";
}

open( F, "$fam_N" );
while (<F>) {
  if (/(\S+)\s+(\d+)/) {
    $ge_N{$1} = $2;
  }
}

$idx = 0;
open( P, "$pos" );
while (<P>) {
  chomp;

  $idx++;
  if ( $idx == 1 ) {
    print $_, "\tN\n";
    next;
  }

  if (/train_weights\/(\S+?)\./) {
    $gene = $1;
    if ( !$ge_N{$gene} ) {
      $this_N = $default;
    }
    else {
      $this_N = $ge_N{$gene};
    }
    print "$_\t$this_N\n";
  }
}
