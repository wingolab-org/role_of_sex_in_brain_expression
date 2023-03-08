$list = shift; #plink dir and .fam list

$script = shift; #FUSION.compute_weights script
if ( !$script ) {
  $script =
    '~/work_dir/software_install/fusion_twas-master/FUSION.compute_weights.mod.R';
}

$out = shift;    #FUSION out dir name
if ( !$out ) {
  $out = 'fusion.out';
}

$pwd = `pwd`;
chomp($pwd);

open( L, "$list" );
while (<L>) {
  #print;
  if (/(\S+)\/(\S+)\.\w+$/) {
    $path = $pwd . "/$1";
    $name = $2;

    #$out="fusion.out";
    if ( !-e "$path/$out" ) {
      `mkdir $path/$out`;
    }

    $cmd =
      "cd $path; ln -s ./ output; Rscript $script --PATH_gemma=/home/yliu/work_dir/ProteinPrediction/software/GEMMA/gemma-0.98.1-linux-static --PATH_gcta=~/work_dir/software_install/fusion_twas-master/gcta_nr_robust --bfile=$name  --out=$out --tmp=$out/temp --models=blup,lasso,top1,enet,bslmm ; cd $pwd";
    `$cmd`;
  }
}

