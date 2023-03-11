By default prints file name and line number:

  $ ogrep x
  ./foo.ml:1:let foo = x
  ./foo.ml:2:let bar = x

Print column number:

  $ ogrep -c x
  ./foo.ml:1:10:let foo = x
  ./foo.ml:2:22:let bar = x
