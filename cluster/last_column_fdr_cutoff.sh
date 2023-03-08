#assoc results with fdr last column
fdr=$1
#cut=${2:-"5e-08"}
cut=${2:-"0.05"}
awk -v cut=$cut 'NR==1{print}NR>1{if ($NF<cut){print}}' $fdr
