dirlist=$1
cov=$2
linear=${3:-1}
suf=${4:-keep}
out_suf=${5:-$suf}

if [ $linear -eq 1 ]; then
	cmd='plink --bfile $g.$suf --out $g.$out_suf --allow-no-sex --covar $pwd/$cov --linear hide-covar'
elif [ $linear -eq 2 ]; then
	cmd='plink --bfile $g.$suf --out $g.$out_suf  --allow-no-sex --covar $pwd/$cov --logistic hide-covar'
else
	echo "1(linear) or 2(logistic) for the 3rd argument; exit"
	exit 1
fi

run='pwd=`pwd`; for f in `less $dirlist`;do g=`cut -d'"'"'/'"'"' -f3 <<<$f`; cd $f; '$cmd'; cd $pwd;done' #glue ' by ""
#echo $run
eval "$run"
