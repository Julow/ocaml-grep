type t =
  | Attr
  | Class
  | Class_type
  | Expr
  | Ext
  | Include
  | Module  (** Module decl/def *)
  | Module_expr
  | Module_type  (** Module type decl/def *)
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
    Class_type;
    Expr;
    Ext;
    Include;
    Module;
    Module_expr;
    Module_type;
    Module_type_expr;
    Open;
    Pattern;
    Sig;
    Str;
    Type;
    Type_decl;
    Value;
  ]

type info = { parent : t; str : string; short_description : string }

let info = function
  | Attr -> { str = "attr"; parent = Attr; short_description = "attribute" }
  | Class ->
      { str = "class"; parent = Class; short_description = "class declaration" }
  | Class_type ->
      {
        str = "class-type";
        parent = Class;
        short_description = "class type declaration";
      }
  | Expr -> { str = "expr"; parent = Expr; short_description = "expression" }
  | Ext -> { str = "ext"; parent = Ext; short_description = "extension" }
  | Include ->
      { str = "include"; parent = Module; short_description = "include" }
  | Module ->
      {
        str = "module";
        parent = Module;
        short_description = "module declaration";
      }
  | Module_expr ->
      {
        str = "module-expr";
        parent = Module;
        short_description = "module expression";
      }
  | Module_type ->
      {
        str = "module-type";
        parent = Module;
        short_description = "module type declaration";
      }
  | Module_type_expr ->
      {
        str = "module-type-expr";
        parent = Module;
        short_description = "module type expression";
      }
  | Open -> { str = "open"; parent = Module; short_description = "open" }
  | Pattern ->
      { str = "pattern"; parent = Pattern; short_description = "pattern" }
  | Sig -> { str = "sig"; parent = Sig; short_description = "sig" }
  | Str -> { str = "str"; parent = Str; short_description = "str" }
  | Type ->
      { str = "type"; parent = Type; short_description = "type expression" }
  | Type_decl ->
      {
        str = "type-decl";
        parent = Type;
        short_description = "type declaration";
      }
  | Value ->
      {
        str = "value";
        parent = Value;
        short_description = "value declaration or description";
      }

let to_string t = (info t).str
let short_description t = (info t).short_description
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
