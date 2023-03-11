type t =
  | Attr
  | Class  (** Parent *)
  | Class_decl
  | Class_type_decl
  | Expr
  | Expr_applied
  | Record_field
  | Ext
  | Include
  | Module  (** Parent *)
  | Module_decl
  | Module_expr
  | Module_type_decl
  | Module_type_expr
  | Open
  | Pattern
  | Sig
  | Str
  | Type  (** Type expr *)
  | Type_decl
  | Value  (** Value/external decl/def *)

type rule = Leaf | Direct of t * rule | Indirect of t * rule

let all =
  [
    Attr;
    Class;
    Class_decl;
    Class_type_decl;
    Expr;
    Expr_applied;
    Record_field;
    Ext;
    Include;
    Module;
    Module_decl;
    Module_expr;
    Module_type_decl;
    Module_type_expr;
    Open;
    Pattern;
    Sig;
    Str;
    Type;
    Type_decl;
    Value;
  ]

type info = { parent : t; str : string; desc : string }

let[@inline always] _mk ~parent str desc = { parent; str; desc }

let info = function
  | Attr -> _mk ~parent:Attr "attr" "attribute"
  | Class -> _mk ~parent:Class "class" "class"
  | Class_decl -> _mk ~parent:Class "class-decl" "class declaration"
  | Class_type_decl -> _mk ~parent:Class "class-type-decl" "class type declaration"
  | Expr -> _mk ~parent:Expr "expr" "expression"
  | Expr_applied -> _mk ~parent:Expr "applied" "applied expression"
  | Record_field -> _mk ~parent:Record_field "field" "record field"
  | Ext -> _mk ~parent:Ext "ext" "extension"
  | Include -> _mk ~parent:Module "include" "include"
  | Module -> _mk ~parent:Module "module" "module"
  | Module_decl -> _mk ~parent:Module "module-decl" "module declaration"
  | Module_expr -> _mk ~parent:Module "module-expr" "module expression"
  | Module_type_decl -> _mk ~parent:Module "module-type-decl" "module type declaration"
  | Module_type_expr -> _mk ~parent:Module "module-type-expr" "module type expression"
  | Open -> _mk ~parent:Module "open" "open"
  | Pattern -> _mk ~parent:Pattern "pattern" "pattern"
  | Sig -> _mk ~parent:Sig "sig" "sig"
  | Str -> _mk ~parent:Str "str" "str"
  | Type -> _mk ~parent:Type "type" "type expression"
  | Type_decl -> _mk ~parent:Type "type-decl" "type declaration"
  | Value -> _mk ~parent:Value "value" "value declaration or description"

let to_string t = (info t).str
let description t = (info t).desc
let parent t = (info t).parent
let _pf = Format.fprintf

let rec pp_rule ppf = function
  | Leaf -> ()
  | Direct (ctx, right) -> _pf ppf "> %s%a" (to_string ctx) pp_rule_tl right
  | Indirect (ctx, right) -> _pf ppf "%s%a" (to_string ctx) pp_rule_tl right

and pp_rule_tl ppf = function
  | Leaf -> ()
  | rule ->
      _pf ppf "@ ";
      pp_rule ppf rule
