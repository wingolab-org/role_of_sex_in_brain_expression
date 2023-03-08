#mRNA gene name is already the ENSG name, e.g: /home/yliu/work_dir/ProteinPrediction/Outside_data_10012019/TWAS/Sage_All_CEU_06202020/SampleID-map.regressed_apoe4.fusion.list

$list = shift; #list of fusion Rdat files
#$ens=shift; #proteo to ensg map: e.g: n391_residual_log2_batchMSsexPMIageStudy.remove-space.csv.id.in-ensWithKg.plus-miss-in-UniprotEnsg.ENSG-map

$out_dir = shift;
if ( !-e $out_dir ) {
  `mkdir $out_dir`;
}

#open (E,"$ens");
#while (<E>){
#   if (/(\S+)\s+(\S+)/){
#	$g{$1}=$2;
#  }
#}

open( L, "$list" );
while (<L>) {
  chomp;

  if (/genes\S+?\/(\w+)/) {
    $name = $1;

  }

  #$new="$out_dir/$name.$add.wgt.RDat";
  $new = "$out_dir/$name.wgt.RDat";
  `cp $_ $new`;

}

