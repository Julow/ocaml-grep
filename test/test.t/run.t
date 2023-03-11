  $ ogrep foo
  ./test.ml:1:type foo
  ./test.ml:3:type t = { foo : t }
  ./test.ml:7:let foo = ()
  ./test.ml:8:let _ = foo
  ./test.ml:9:let _ = f foo
  ./test.ml:10:let _ = foo ()
  ./test.ml:11:let { foo; _ } = ()
  ./test.ml:12:let { contents = foo } = ()
  ./test.ml:14:let (_ as foo) = ()
  ./test.ml:15:let f ~foo = ()
  ./test.ml:16:let f ?foo = ()
  ./test.ml:17:let f ~x:foo = ()
  ./test.ml:18:let x : foo = ()
  ./test.ml:19:let x = (x : foo)
  ./test.ml:21:[@@@foo]
  ./test.ml:23:let (x [@foo]) = ()
  ./test.ml:24:let x = () [@@foo]
  ./test.ml:27:  type foo
  ./test.ml:29:  type t = { foo : t }
  ./test.ml:33:  val foo : t
  ./test.ml:34:  val x : foo
  ./test.ml:42:class foo = object end
  ./test.ml:44:class type foo = object end
  ./test.ml:46:class x : foo = object end

  $ ogrep Foo
  ./test.ml:2:type t = Foo
  ./test.ml:4:type t = [ `Foo ]
  ./test.ml:13:let (Foo _) = ()
  ./test.ml:28:  type t = Foo
  ./test.ml:30:  type t = [ `Foo ]
  ./test.ml:38:module Foo = struct end
  ./test.ml:40:module X = Foo
  ./test.ml:48:include Foo
  ./test.ml:49:open Foo

  $ ogrep --type Foo
  ./test.ml:4:type t = [ `Foo ]
  ./test.ml:30:  type t = [ `Foo ]

  $ ogrep --expr foo
  ./test.ml:8:let _ = foo
  ./test.ml:9:let _ = f foo
  ./test.ml:10:let _ = foo ()

  $ ogrep FOO
  ./test.ml:26:module type FOO = sig
  ./test.ml:39:module X : FOO = struct end

Don't match strings in locations:

  $ ogrep ./test.ml
