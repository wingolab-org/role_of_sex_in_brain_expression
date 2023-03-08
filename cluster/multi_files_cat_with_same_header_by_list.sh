list=$1
out=$2
#header
for f in $(less $list); do
	head -n1 $f >$out
	break
done
#content
for f in $(less $list); do awk 'NR>1{print}' $f >>$out; done
