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

let to_string = function
  | Attr -> "attr"
  | Class -> "class"
  | Class_type -> "class-type"
  | Expr -> "expr"
  | Ext -> "ext"
  | Include -> "include"
  | Module -> "module"
  | Module_expr -> "module-expr"
  | Module_type -> "module-type"
  | Module_type_expr -> "module-type-expr"
  | Open -> "open"
  | Pattern -> "pattern"
  | Sig -> "sig"
  | Str -> "str"
  | Type -> "type"
  | Type_decl -> "type-decl"
  | Value -> "value"

let short_description = function
  | Attr -> "attribute"
  | Class -> "class declaration"
  | Class_type -> "class type declaration"
  | Expr -> "expression"
  | Ext -> "extension"
  | Include -> "include"
  | Module -> "module declaration"
  | Module_expr -> "module expression"
  | Module_type -> "module type declaration"
  | Module_type_expr -> "module type expression"
  | Open -> "open"
  | Pattern -> "pattern"
  | Sig -> "sig"
  | Str -> "str"
  | Type -> "type expression"
  | Type_decl -> "type declaration"
  | Value -> "value declaration or description"
