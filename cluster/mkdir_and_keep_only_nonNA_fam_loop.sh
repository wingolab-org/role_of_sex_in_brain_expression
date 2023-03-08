dirlist=$1
dirname=$2
pwd=$(pwd)
for f in $(less $dirlist); do
	g=$(cut -d'/' -f3 <<<$f)
	cd $f
	mkdir $dirname
	cd $dirname
	perl /home/yliu/bin/rm_NA_from_plink_fam.pl ../$g.keep.fam >$g.nonNA_fam
	plink --bfile ../$g.keep --keep $g.nonNA_fam --make-bed --out $g.keep
	wc -l $g.keep.fam | awk '{print $1}' >$g.keep.fam.N
	cd $pwd
done
