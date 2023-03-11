By default prints file name and line number:

  $ ogrep x
  ./foo.ml:1:let foo = x
  ./foo.ml:2:let bar = x

Print column number:

  $ ogrep -c x
  ./foo.ml:1:10:let foo = x
  ./foo.ml:2:10:let bar = x

Enable colors:

  $ ogrep --color=always x | tr $'\033' '\\'
  ./foo.ml:1:let foo = \[43mx\[0m
  ./foo.ml:2:let bar = \[43mx\[0m
