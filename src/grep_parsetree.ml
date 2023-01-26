type match_ = Ppxlib.Ast.location -> Context.t list -> string -> unit
type acc = Ppxlib.Ast.location * Context.t list

let init = (Ppxlib.Location.none, [])

let with_context f c' x ((loc, c) as acc) =
  ignore (f x (loc, c' :: c));
  acc

class grepper match_ =
  let open Context in
  object
    inherit [acc] Ppxlib.Ast_traverse.fold as super

    method! loc f t ((_prev_loc, c) as acc) =
      ignore (super#loc f t (t.Ppxlib_ast.Ast.loc, c));
      acc

    method! string s ((loc, c) as acc) =
      match_ loc c s;
      acc

    method! attribute = with_context super#attribute Attr
    method! extension = with_context super#extension Ext

    (** Languages *)

    method! core_type = with_context super#core_type Type
    method! pattern = with_context super#pattern Pattern
    method! expression = with_context super#expression Expr
    method! module_type = with_context super#module_type Module_type_expr
    method! module_expr = with_context super#module_expr Module_expr

    (** Structure items *)

    method! structure = with_context super#structure Str
    method! value_binding = with_context super#value_binding Value
    method! type_declaration = with_context super#type_declaration Type_decl
    method! type_extension = with_context super#type_extension Type_decl
    method! type_exception = with_context super#type_exception Type_decl
    method! module_binding = with_context super#module_binding Module

    method! module_type_declaration =
      with_context super#module_type_declaration Module_type

    method! class_declaration = with_context super#class_declaration Class

    method! class_type_declaration =
      with_context super#class_type_declaration Class_type

    method! open_declaration = with_context super#open_declaration Open
    method! include_declaration = with_context super#include_declaration Include

    (** Signature items *)

    method! signature = with_context super#signature Sig
    method! value_description = with_context super#value_description Value
    method! module_declaration = with_context super#module_declaration Module
    method! module_substitution = with_context super#module_substitution Module
    method! include_description = with_context super#include_description Include
    method! class_description = with_context super#class_description Class
  end

type t = grepper

let grepper match_ = new grepper match_

let impl grepper lexbuf =
  ignore (grepper#structure (Ppxlib.Parse.implementation lexbuf) init)

let intf grepper lexbuf =
  ignore (grepper#signature (Ppxlib.Parse.interface lexbuf) init)
