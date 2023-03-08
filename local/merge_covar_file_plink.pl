#left join, C1 as x;
#C1 is the reference

$c1 = shift;
$c2 = shift;

open( C2, "$c2" );
while (<C2>) {
  if (/(\S+)\s+(\S+)\s+(.+)/) {
    $info{$1}{$2} = $3;
  }
}

open( C1, "$c1" );
while (<C1>) {
  if (/(\S+)\s+(\S+)\s+(.+)/) {
    if ( $info{$1}{$2} ) {
      print "$1\t$2\t$3\t$info{$1}{$2}\n";
    }
    else {
      print STDERR "Warning $2 has no covar info in $c2\n";
    }

  }
}
