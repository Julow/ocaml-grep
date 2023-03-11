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

  $ ogrep -vv --val --direct --expr --direct --type bar
  ogrep: [DEBUG] Context rules: [ value > expr > type ]
  ogrep: [DEBUG] String in context: 1:10: "bar"
  ogrep: [DEBUG] String in context: 2:8: "bar"
  ./test.ml:1:let foo : bar = x
  ./test.ml:2:let x : bar = foo

  $ ogrep -vv --val --direct --expr foo
  ogrep: [DEBUG] Context rules: [ value > expr ]
  ogrep: [DEBUG] String in context: 1:16: "x"
  ogrep: [DEBUG] String in context: 1:10: "bar"
  ogrep: [DEBUG] String in context: 2:14: "foo"
  ogrep: [DEBUG] String in context: 2:8: "bar"
  ./test.ml:2:let x : bar = foo

  $ ogrep -vv --val --direct --expr --direct --expr foo
  ogrep: [DEBUG] Context rules: [ value > expr > expr ]
  ogrep: [DEBUG] String in context: 1:16: "x"
  ogrep: [DEBUG] String in context: 2:14: "foo"
  ./test.ml:2:let x : bar = foo
