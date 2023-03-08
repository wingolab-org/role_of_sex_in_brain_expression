#add_SE_A2_MAF.txt list
list=$1

for f in $(less $list); do
	g=$(cut -d'/' -f3 <<<$f)
	#cd $f;
	awk -v ge=$g 'NR==1{print $0,"GENE"}NR>1{print $0,ge}' $f >$f.addgene
done
