csv=$1
AD=$2

prefix=$(sed 's/.csv//' <<<$csv)
#echo $prefix

#sva covar
Rscript ~/bin/sva_covar_from_expr.R $csv $AD

#adjust sva
Rscript ~/bin/regress_covar_from_expr_csv.R $csv $prefix.sva_covar.txt 0 $prefix.svaAdj.csv >$prefix.svaAdj.stdout

#colnames
#Rscript ~/bin/column_names_from_df.R $prefix.svaAdj.csv 1 1 >$prefix.svaAdj.colnames
Rscript ~/bin/row_or_colnames_for_expr_csv.R $prefix.svaAdj.csv 2 >$prefix.svaAdj.colnames
