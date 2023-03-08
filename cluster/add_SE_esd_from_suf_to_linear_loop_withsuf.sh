#.keep suf list
list=$1

#flag to calculate frq or not
flag=${2:-1}

#assoc suf
assocsuf=${3:-assoc.linear}

for f in $(less $list); do

	if [[ $flag -ne 0 ]]; then
		plink --bfile $f --freq --out $f
	fi

	#add SE/A2/Freq
	Rscript ~/bin/add_SE_A2_freq_to_plink_linear_assoc.R $f.$assocsuf $f.frq

	#add .esd
	awk 'NR==1{print "Chr SNP Bp A1 A2 Freq Beta se p"}NR>1{if ($12 != 0 && $9 != "NA"){print $1,$2,$3,$4,$11,$12,$7,$10,$9}}' $f.$assocsuf.add_SE_A2_MAF.txt >$f.$assocsuf.add_SE_A2_MAF.txt.esd
done
