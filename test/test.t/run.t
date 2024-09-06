  $ ogrep foo
  ./test.ml:1:type foo
  ./test.ml:3:type t = { foo : t }
  ./test.ml:7:let foo = ()
  ./test.ml:8:let _ = foo
  ./test.ml:9:let _ = f foo
  ./test.ml:10:let _ = foo ()
  ./test.ml:11:let { foo; _ } = ()
  ./test.ml:12:let { contents = foo } = ()
  ./test.ml:13:let f x = { foo = x }
  ./test.ml:14:let f x = x.foo
  ./test.ml:15:let f x = x.foo <- 1
  ./test.ml:17:let (_ as foo) = ()
  ./test.ml:18:let f ~foo = ()
  ./test.ml:19:let f ?foo = ()
  ./test.ml:20:let f ~x:foo = ()
  ./test.ml:21:let x : foo = ()
  ./test.ml:22:let x = (x : foo)
  ./test.ml:24:[@@@foo]
  ./test.ml:26:let (x [@foo]) = ()
  ./test.ml:27:let x = () [@@foo]
  ./test.ml:30:  type foo
  ./test.ml:32:  type t = { foo : t }
  ./test.ml:36:  val foo : t
  ./test.ml:37:  val x : foo
  ./test.ml:45:class foo = object end
  ./test.ml:47:class type foo = object end
  ./test.ml:49:class x : foo = object end

  $ ogrep Foo
  ./test.ml:2:type t = Foo
  ./test.ml:4:type t = [ `Foo ]
  ./test.ml:16:let (Foo _) = ()
  ./test.ml:31:  type t = Foo
  ./test.ml:33:  type t = [ `Foo ]
  ./test.ml:41:module Foo = struct end
  ./test.ml:43:module X = Foo
  ./test.ml:51:include Foo
  ./test.ml:52:open Foo

  $ ogrep --type Foo
  ./test.ml:2:type t = Foo
  ./test.ml:4:type t = [ `Foo ]
  ./test.ml:31:  type t = Foo
  ./test.ml:33:  type t = [ `Foo ]

  $ ogrep --expr foo
  ./test.ml:8:let _ = foo
  ./test.ml:9:let _ = f foo
  ./test.ml:10:let _ = foo ()

  $ ogrep FOO
  ./test.ml:29:module type FOO = sig
  ./test.ml:42:module X : FOO = struct end

'--field-get' and '--field-set' should be disjoint and '--field' should be the
addition of both:

  $ ogrep --field foo
  ./test.ml:13:let f x = { foo = x }
  ./test.ml:14:let f x = x.foo
  ./test.ml:15:let f x = x.foo <- 1
  $ ogrep --field-get foo
  ./test.ml:14:let f x = x.foo
  $ ogrep --field-set foo
  ./test.ml:13:let f x = { foo = x }
  ./test.ml:15:let f x = x.foo <- 1

Don't match strings in locations:

  $ ogrep ./test.ml
