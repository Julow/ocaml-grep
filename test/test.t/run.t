  $ ogrep foo
  ./test.ml:1:type foo
  ./test.ml:5:type t = { foo : t }
  ./test.ml:11:let foo = ()
  ./test.ml:13:let _ = foo
  ./test.ml:15:let _ = f foo
  ./test.ml:17:let _ = foo ()
  ./test.ml:19:let { foo; _ } = ()
  ./test.ml:21:let { contents = foo } = ()
  ./test.ml:25:let (_ as foo) = ()
  ./test.ml:27:let f ~foo = ()
  ./test.ml:29:let f ?foo = ()
  ./test.ml:31:let f ~x:foo = ()
  ./test.ml:33:let x : foo = ()

  $ ogrep Foo
  ./test.ml:3:type t = Foo
  ./test.ml:7:type t = [ `Foo ]
  ./test.ml:23:let (Foo _) = ()
