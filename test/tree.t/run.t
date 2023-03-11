Test scanning of directories.

  $ mkdir -p {a,b,c}/{1,2,3}
  $ for f in {a,b,c}/{1,2,3}/foo.ml {a,b,c,.}/{foo,bar,baz}.ml; do echo "let foo = 1" > $f; done

Expecting 21 matches:

  $ ogrep foo
  ./a/1/foo.ml:1:let foo = 1
  ./a/2/foo.ml:1:let foo = 1
  ./a/3/foo.ml:1:let foo = 1
  ./a/bar.ml:1:let foo = 1
  ./a/baz.ml:1:let foo = 1
  ./a/foo.ml:1:let foo = 1
  ./b/1/foo.ml:1:let foo = 1
  ./b/2/foo.ml:1:let foo = 1
  ./b/3/foo.ml:1:let foo = 1
  ./b/bar.ml:1:let foo = 1
  ./b/baz.ml:1:let foo = 1
  ./b/foo.ml:1:let foo = 1
  ./bar.ml:1:let foo = 1
  ./baz.ml:1:let foo = 1
  ./c/1/foo.ml:1:let foo = 1
  ./c/2/foo.ml:1:let foo = 1
  ./c/3/foo.ml:1:let foo = 1
  ./c/bar.ml:1:let foo = 1
  ./c/baz.ml:1:let foo = 1
  ./c/foo.ml:1:let foo = 1
  ./foo.ml:1:let foo = 1
