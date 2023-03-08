$l = shift; #list name
$n = shift; #batch size

#$prefix = "split.";
$prefix = shift;

$idx = 0;
open( L, "$l" );
$new_file = $prefix . $idx;
open( O, ">$new_file" );
$total = 0;
while (<L>) {
  $total++;
  #$idx ++;
  if ( ( $total % $n ) == 0 ) { #new batch
    $idx++;
    $new_file = $prefix . $idx;
    open( O, ">$new_file" );
  }
  print O;
}
