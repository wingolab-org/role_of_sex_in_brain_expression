$key_list = shift; #key list
#two column list; e.g snp and ME:
#rs150992957 brown
#rs56225520 brown

$value_list = shift; #value list

$col1 = shift;       #value column 1; e.g snp column in value list
$col2 = shift;       #value column 2; e.g ME column in value list

$key_head_flag   = shift;
$value_head_flag = shift;

$idx = 0;
if ( $key_list =~ /\.gz$/ ) {
  open( K, "gunzip -c $key_list|" );
}
else {
  open( K, "$key_list" );
}
#open (K,"$key_list");
while (<K>) {
  s/^\s+//;
  $idx++;
  if ( $key_head_flag and $idx == 1 ) {
    #print;
    next;
  }

  if (/(\S+)\s+(\S+)/) {
    $have{$1}{$2} = 1;
  }
}

$idx = 0;
if ( $value_list =~ /\.gz$/ ) {
  open( V, "gunzip -c $value_list|" );
}
else {
  open( V, "$value_list" );
}
#open (V,"$value_list");
while (<V>) {
  s/^\s+//;

  $idx++;
  if ( $value_head_flag and $idx == 1 ) {
    print;
    next;
  }

  @ay     = split( /\s+/, $_ );
  $col1_v = $ay[ $col1 - 1 ];
  $col2_v = $ay[ $col2 - 1 ];
  if ( $have{$col1_v}{$col2_v} ) {
    print;
  }

}

