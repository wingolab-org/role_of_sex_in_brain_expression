$key_list   = shift; #key list
$value_list = shift; #value list

$key_col = shift;
$key_col = 1 if !$key_col;

$val_col = shift;
$val_col = 1 if !$val_col;

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

  @ay = split( /\s+/, $_ );

  $have{ $ay[ $key_col - 1 ] } = 1;

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

  @ay = split( /\s+/, $_ );

  if ( $have{ $ay[ $val_col - 1 ] } ) {
    print;
  }

}
