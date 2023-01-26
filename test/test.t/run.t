  $ ogrep foo
  ./test.ml:1:(type-decl, str)type foo
  ./test.ml:3:(type-decl, str)type t = { foo : t }
  ./test.ml:7:(pattern, value, str)let foo = ()
  ./test.ml:8:(expr, value, str)let _ = foo
  ./test.ml:9:(expr, expr, value, str)let _ = f foo
  ./test.ml:10:(expr, expr, value, str)let _ = foo ()
  ./test.ml:11:(pattern, pattern, value, str)let { foo; _ } = ()
  ./test.ml:12:(pattern, pattern, value, str)let { contents = foo } = ()
  ./test.ml:14:(pattern, value, str)let (_ as foo) = ()
  ./test.ml:15:(pattern, expr, value, str)let f ~foo = ()
  ./test.ml:16:(pattern, expr, value, str)let f ?foo = ()
  ./test.ml:17:(pattern, expr, value, str)let f ~x:foo = ()
  ./test.ml:18:(type, expr, value, str)let x : foo = ()
  ./test.ml:20:(attr, str)[@@@foo]
  ./test.ml:22:(attr, pattern, value, str)let (x [@foo]) = ()
  ./test.ml:23:(attr, value, str)let x = () [@@foo]
  ./test.ml:26:(type-decl, sig, module-type-expr, module-type, str)  type foo
  ./test.ml:28:(type-decl, sig, module-type-expr, module-type, str)  type t = { foo : t }
  ./test.ml:32:(value, sig, module-type-expr, module-type, str)  val foo : t
  ./test.ml:33:(type, value, sig, module-type-expr, module-type, str)  val x : foo
  ./test.ml:41:(class, str)class foo = object end
  ./test.ml:43:(class-type, str)class type foo = object end
  ./test.ml:45:(class, str)class x : foo = object end

  $ ogrep Foo
  ./test.ml:2:(type-decl, str)type t = Foo
  ./test.ml:4:(type, type-decl, str)type t = [ `Foo ]
  ./test.ml:13:(pattern, value, str)let (Foo _) = ()
  ./test.ml:27:(type-decl, sig, module-type-expr, module-type, str)  type t = Foo
  ./test.ml:29:(type, type-decl, sig, module-type-expr, module-type, str)  type t = [ `Foo ]
  ./test.ml:37:(module, str)module Foo = struct end
  ./test.ml:39:(module-expr, module, str)module X = Foo
  ./test.ml:47:(module-expr, include, str)include Foo
  ./test.ml:48:(module-expr, open, str)open Foo

  $ ogrep --type Foo
  ./test.ml:4:(type, type-decl, str)type t = [ `Foo ]
  ./test.ml:29:(type, type-decl, sig, module-type-expr, module-type, str)  type t = [ `Foo ]

  $ ogrep --expr foo
  ./test.ml:8:(expr, value, str)let _ = foo
  ./test.ml:9:(expr, expr, value, str)let _ = f foo
  ./test.ml:10:(expr, expr, value, str)let _ = foo ()

  $ ogrep FOO
  ./test.ml:25:(module-type, str)module type FOO = sig
  ./test.ml:38:(module-type-expr, module-expr, module, str)module X : FOO = struct end
