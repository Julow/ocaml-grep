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

let (Foo _) = ()

let (_ as foo) = ()

let f ~foo = ()

let f ?foo = ()

let f ~x:foo = ()

let x : foo = ()
