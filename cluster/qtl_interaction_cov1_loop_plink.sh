dirlist=$1
cov=$2
tepN=$(awk 'NR==1{print NF}' $cov)
suf=${3:-keep}
out_suf=${4:-$suf}

pwd=$(pwd)
for f in $(less $dirlist); do
	g=$(cut -d'/' -f3 <<<$f)
	cd $f
	plink --bfile $g.$suf --out $g.$out_suf --allow-no-sex --covar $pwd/$cov \
		--linear --interaction --parameters 1-$tepN
	awk 'NR==1{print}NR>1{if ($5=="ADD"||$5=="COV1"||$5=="ADDxCOV1"){print}}' \
		$g.$out_suf.assoc.linear >$g.$out_suf.assoc.linear.cov1xadd
	rm -f $g.$out_suf.assoc.linear
	cd $pwd
done
