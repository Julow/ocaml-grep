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
  ogrep: [DEBUG]  str  (value > expr > type)
  ogrep: [DEBUG]   value  (value@> expr > type, value > expr > type)
  ogrep: [DEBUG]    pattern  (value > expr > type)
  ogrep: [DEBUG]     pattern  (value > expr > type)
  ogrep: [DEBUG]     type  (value > expr > type)
  ogrep: [DEBUG]      type  (value > expr > type)
  ogrep: [DEBUG]    expr  (value > expr > type, expr@> type)
  ogrep: [DEBUG]     expr  (expr@> type, value > expr > type)
  ogrep: [DEBUG]     type  (<leaf>, value > expr > type)
  ogrep: [DEBUG]       "bar"  (1:10)
  ogrep: [DEBUG]   value  (value@> expr > type, value > expr > type)
  ogrep: [DEBUG]    pattern  (value > expr > type)
  ogrep: [DEBUG]     pattern  (value > expr > type)
  ogrep: [DEBUG]     type  (value > expr > type)
  ogrep: [DEBUG]      type  (value > expr > type)
  ogrep: [DEBUG]    expr  (value > expr > type, expr@> type)
  ogrep: [DEBUG]     expr  (expr@> type, value > expr > type)
  ogrep: [DEBUG]     type  (<leaf>, value > expr > type)
  ogrep: [DEBUG]       "bar"  (2:8)
  ./test.ml:1:let foo : bar = x
  ./test.ml:2:let x : bar = foo

  $ ogrep -vv --val --direct --expr foo
  ogrep: [DEBUG] Context rules: [ value > expr ]
  ogrep: [DEBUG]  str  (value > expr)
  ogrep: [DEBUG]   value  (value@> expr, value > expr)
  ogrep: [DEBUG]    pattern  (value > expr)
  ogrep: [DEBUG]     pattern  (value > expr)
  ogrep: [DEBUG]     type  (value > expr)
  ogrep: [DEBUG]      type  (value > expr)
  ogrep: [DEBUG]    expr  (value > expr, <leaf>)
  ogrep: [DEBUG]     expr  (<leaf>, value > expr)
  ogrep: [DEBUG]       "x"  (1:16)
  ogrep: [DEBUG]     type  (value > expr)
  ogrep: [DEBUG]   value  (value@> expr, value > expr)
  ogrep: [DEBUG]    pattern  (value > expr)
  ogrep: [DEBUG]     pattern  (value > expr)
  ogrep: [DEBUG]     type  (value > expr)
  ogrep: [DEBUG]      type  (value > expr)
  ogrep: [DEBUG]    expr  (value > expr, <leaf>)
  ogrep: [DEBUG]     expr  (<leaf>, value > expr)
  ogrep: [DEBUG]       "foo"  (2:14)
  ogrep: [DEBUG]     type  (value > expr)
  ./test.ml:2:let x : bar = foo

  $ ogrep -vv --val --direct --expr --direct --expr foo
  ogrep: [DEBUG] Context rules: [ value > expr > expr ]
  ogrep: [DEBUG]  str  (value > expr > expr)
  ogrep: [DEBUG]   value  (value@> expr > expr, value > expr > expr)
  ogrep: [DEBUG]    pattern  (value > expr > expr)
  ogrep: [DEBUG]     pattern  (value > expr > expr)
  ogrep: [DEBUG]     type  (value > expr > expr)
  ogrep: [DEBUG]      type  (value > expr > expr)
  ogrep: [DEBUG]    expr  (value > expr > expr, expr@> expr)
  ogrep: [DEBUG]     expr  (<leaf>, value > expr > expr)
  ogrep: [DEBUG]       "x"  (1:16)
  ogrep: [DEBUG]     type  (value > expr > expr)
  ogrep: [DEBUG]   value  (value@> expr > expr, value > expr > expr)
  ogrep: [DEBUG]    pattern  (value > expr > expr)
  ogrep: [DEBUG]     pattern  (value > expr > expr)
  ogrep: [DEBUG]     type  (value > expr > expr)
  ogrep: [DEBUG]      type  (value > expr > expr)
  ogrep: [DEBUG]    expr  (value > expr > expr, expr@> expr)
  ogrep: [DEBUG]     expr  (<leaf>, value > expr > expr)
  ogrep: [DEBUG]       "foo"  (2:14)
  ogrep: [DEBUG]     type  (value > expr > expr)
  ./test.ml:2:let x : bar = foo
