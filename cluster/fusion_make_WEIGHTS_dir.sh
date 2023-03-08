RDat_dir=$(readlink -f $1)
WEIGHTS=$2
gene=/home/yliu/work_dir/ProteinPrediction/Gene_annotation/ensembl/Homo_sapiens.GRCh37.87.chr.gff3.gene

mkdir -p $WEIGHTS/train_weights/

cd $WEIGHTS/
cp $RDat_dir/*.RDat train_weights/
ls train_weights/*.RDat >train_weights.fof
perl ~/bin/WEIGHTS.pos_file_for_fusion.pl train_weights.fof $gene >train_weights.pos
cd ../
