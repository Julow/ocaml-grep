type foo
type t = Foo
type t = { foo : t }
type t = [ `Foo ]
type 'foo t

let foo = ()
let _ = foo
let _ = f foo
let _ = foo ()
let { foo; _ } = ()
let { contents = foo } = ()
let f x = { foo = x }
let f x = x.foo
let f x = x.foo <- 1
let (Foo _) = ()
let (_ as foo) = ()
let f ~foo = ()
let f ?foo = ()
let f ~x:foo = ()
let x : foo = ()
let x = (x : foo)

[@@@foo]

let (x [@foo]) = ()
let x = () [@@foo]

module type FOO = sig
  type foo
  type t = Foo
  type t = { foo : t }
  type t = [ `Foo ]
  type 'foo t

  val foo : t
  val x : foo
  val x : foo:t -> t
end

module Foo = struct end
module X : FOO = struct end
module X = Foo

class foo = object end

class type foo = object end

class x : foo = object end

include Foo
open Foo
