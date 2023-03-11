The contextes are shaped like this:

| Value
|   "foo"
|   Expr
|     Type
|       "bar"
|     Expr
|       "x"
| Value
|   "x"
|   Expr
|     Type
|       "bar"
|     Expr
|       "foo"

  $ ogrep -vv --val --expr --type bar
  ogrep: [DEBUG] Context rules: [ value > expr > type ]
  ogrep: [DEBUG] String in context: 1:10: "bar"
  ogrep: [DEBUG] String in context: 2:26: "bar"
  ./test.ml:1:let foo : bar = x
  ./test.ml:2:let x : bar = foo

  $ ogrep -vv --val --expr foo
  ogrep: [DEBUG] Context rules: [ value > expr ]
  ogrep: [DEBUG] String in context: 1:16: "x"
  ogrep: [DEBUG] String in context: 1:10: "bar"
  ogrep: [DEBUG] String in context: 2:32: "foo"
  ogrep: [DEBUG] String in context: 2:26: "bar"
  ./test.ml:2:let x : bar = foo
  $ ogrep -vv --val --expr --expr foo
  ogrep: [DEBUG] Context rules: [ value > expr > expr ]
  ogrep: [DEBUG] String in context: 1:16: "x"
  ogrep: [DEBUG] String in context: 2:32: "foo"
  ./test.ml:2:let x : bar = foo

The following queries shouldn't match anything.

  $ ogrep --val --expr --type foo
  $ ogrep --val --expr --type x
