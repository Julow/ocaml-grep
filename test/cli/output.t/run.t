By default prints file name and line number:

  $ ogrep x
  ./foo.ml:1:let foo = x

Print column number:

  $ ogrep -c x
  ./foo.ml:1:10:let foo = x

Enable colors:

  $ ogrep --color=always x | tr $'\033' '\\'
  ./foo.ml:1:let foo = \[43mx\[0m

Several matches on the same line:

  $ ogrep --color=always bar | tr $'\033' '\\'
  ./foo.ml:2:let \[43mbar\[0m = \[43mbar\[0m
