#p1e04.merge_sb-pQTL-and-sb-gwas.format_trait.snp_trait
$f = shift;
open( F, "$f" );
while (<F>) {
  if (/(\S+)\s+(\S+)/) {
    $snp = $1;
    $f   = $2;

    $fh = "fh." . $f;
    if ( !$have{$f} ) {
      `mkdir $f`;
      open( $fh, ">$f.target_snps" );
      $have{$f} = 1;
    }
    print $fh "$snp\n";
  }
}
