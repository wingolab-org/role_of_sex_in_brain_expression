dirlist=$1

pwd=$(pwd)
for f in $(less $dirlist); do
	g=$(cut -d'/' -f3 <<<$f)
	cd $f
	awk -v ge=$g 'NR==1{print ge,$1}' $g.keep.fam.N
	cd $pwd
done
