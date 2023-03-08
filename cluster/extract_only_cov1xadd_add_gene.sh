#add_SE_A2_MAF.txt list
list=$1

#pwd=`pwd`;

for f in $(less $list); do
	g=$(cut -d'/' -f3 <<<$f)
	#cd $f;
	awk 'NR==1{print $0,"GENE"}' $f >$f.xonly_addgene
	grep ADDxCOV1 $f | awk -v ge=$g '{print $0,ge}' >>$f.xonly_addgene
done
