  $ ogrep foo
  ./test.ml:1:()type foo
  ./test.ml:5:()type t = { foo : t }
  ./test.ml:11:(pattern)let foo = ()
  ./test.ml:13:(expr)let _ = foo
  ./test.ml:15:(expr
  expr)let _ = f foo
  ./test.ml:17:(expr
  expr)let _ = foo ()
  ./test.ml:19:(pattern
  pattern)let { foo; _ } = ()
  ./test.ml:21:(pattern
  pattern)let { contents = foo } = ()
  ./test.ml:25:(pattern)let (_ as foo) = ()
  ./test.ml:27:(pattern
  expr)let f ~foo = ()
  ./test.ml:29:(pattern
  expr)let f ?foo = ()
  ./test.ml:31:(pattern
  expr)let f ~x:foo = ()
  ./test.ml:33:(typetype
  pattern)let x : foo = ()

  $ ogrep Foo
  ./test.ml:3:()type t = Foo
  ./test.ml:7:(type)type t = [ `Foo ]
  ./test.ml:23:(pattern)let (Foo _) = ()
