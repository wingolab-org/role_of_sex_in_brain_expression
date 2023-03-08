list=$1
cmd=$2
n=${3:-400}
args=${4:-""}
split_list_dir_and_batches.sh $list $n
for f in $(less $list.$n.split.list); do echo "$cmd $f $args" | qsub1; done
