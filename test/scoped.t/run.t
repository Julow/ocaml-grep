A context stops matching when entering a context with a different "parent".

3 type:

  $ ogrep -S --type foo
  ./test.ml:1:10:let foo : foo = fun { foo = (foo : foo) } -> foo (foo : foo)
  ./test.ml:1:35:let foo : foo = fun { foo = (foo : foo) } -> foo (foo : foo)
  ./test.ml:1:56:let foo : foo = fun { foo = (foo : foo) } -> foo (foo : foo)

2 expressions:

  $ ogrep -S --expr foo
  ./test.ml:1:45:let foo : foo = fun { foo = (foo : foo) } -> foo (foo : foo)
  ./test.ml:1:50:let foo : foo = fun { foo = (foo : foo) } -> foo (foo : foo)

3 patterns

  $ ogrep -S --pattern foo
  ./test.ml:1:4:let foo : foo = fun { foo = (foo : foo) } -> foo (foo : foo)
  ./test.ml:1:22:let foo : foo = fun { foo = (foo : foo) } -> foo (foo : foo)
  ./test.ml:1:29:let foo : foo = fun { foo = (foo : foo) } -> foo (foo : foo)
