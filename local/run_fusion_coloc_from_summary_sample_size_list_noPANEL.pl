$list = shift
  ; #e.g:/home/yliu/work_dir/ProteinPrediction/Outside_data_10012019/fusion_and_coloc_multi_datasets/panel_and_weights.ROSMAP_Banner_MSBB.dict.dir/gwas_summary_list.with_sample_size.06202020.txt

$WEIGHTS = shift; #WEIGHTS/ dir path; default in current dir;
if ( !$WEIGHTS ) {
  $WEIGHTS = "WEIGHTS";
}

$idx = 0;
open( L, "$list" );
while (<L>) {
  $idx++;
  next if $idx == 1;

  if (/(\S+)\s+(\S+)/) {
    $z     = $1; #gwas Z summary
    $gwasN = $2;

    $cmd =
      "~/bin/fusion_assoc_cp_WEIGHTS_dir_with_coloc_and_mkdir_noPANEL.sh $z  $WEIGHTS $gwasN";
    `qsub2 \"$cmd\"`;
  }
}

