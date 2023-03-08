dirlist=$1
male=$2
female=$3
suf=${4:-keep}

pwd=$(pwd)
for f in $(less $dirlist); do
	g=$(cut -d'/' -f3 <<<$f)
	cd $f
	mkdir $g.$suf.male
	cd $g.$suf.male
	plink --bfile ../$g.$suf --keep $pwd/$male --make-bed --out $g.$suf
	cd ../
	mkdir $g.$suf.female
	cd $g.$suf.female
	plink --bfile ../$g.$suf --keep $pwd/$female --make-bed --out $g.$suf
	cd ../
	cd $pwd
done
