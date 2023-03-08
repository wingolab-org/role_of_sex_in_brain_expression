#for single line file
#R may think base T as bool TRUE
#change it back to T
while (<>) {
  ~s/TRUE/T/g;
  print;
}
