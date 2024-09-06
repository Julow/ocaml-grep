type match_ = Ppxlib.Ast.location -> string -> unit
type acc = Ppxlib.Ast.location * Match_context.t

let with_context f c' x ((loc, ctx) as acc) =
  incr Debug.level;
  let ctx = Match_context.enter ctx c' in
  if not (Match_context.is_fail ctx) then ignore (f x (loc, ctx));
  decr Debug.level;
  acc

class grepper match_ =
  let open Context in
  object (self)
    inherit [acc] Ppxlib.Ast_traverse.fold as super

    method! location _ acc = acc
    (** Avoid matching file names in locations. *)

    method! loc f t ((_prev_loc, ctx) as acc) =
      ignore (super#loc f t (t.Ppxlib_ast.Ast.loc, ctx));
      acc

    method! string s ((loc, ctx) as acc) =
      if Match_context.is_done ctx then match_ loc s;
      acc

    method! attribute = with_context super#attribute Attr
    method! extension = with_context super#extension Ext

    (** Languages *)

    method! core_type = with_context super#core_type Type
    method! pattern = with_context super#pattern Pattern
    method! module_type = with_context super#module_type Module_type_expr
    method! module_expr = with_context super#module_expr Module_expr

    (** Expressions *)

    method any_expression = with_context super#expression Expr
    method record_field_set = with_context self#longident_loc Record_field_set
    method record_field_get = with_context self#longident_loc Record_field_get

    method letmodule_decl' (name, me) acc =
      let acc = self#loc (self#option self#string) name acc in
      self#module_expr me acc

    method letmodule_decl = with_context self#letmodule_decl' Module_decl

    method! expression exp acc =
      match exp.pexp_desc with
      | Pexp_apply (lhs, rhs) ->
          let acc = with_context super#expression Expr_applied lhs acc in
          self#list
            (fun (a, b) acc ->
              let acc = self#arg_label a acc in
              self#expression b acc)
            rhs acc
      | Pexp_record (fields, src) ->
          let acc =
            self#list
              (fun (a, b) acc ->
                let acc = self#record_field_set a acc in
                self#expression b acc)
              fields acc
          in
          self#option self#expression src acc
      | Pexp_field (src, field) ->
          let acc = self#expression src acc in
          self#record_field_get field acc
      | Pexp_setfield (src, field, val_) ->
          let acc = self#expression src acc in
          let acc = self#record_field_set field acc in
          self#expression val_ acc
      | Pexp_letmodule (name, me, expr) ->
          let acc = self#letmodule_decl (name, me) acc in
          self#expression expr acc
      | Pexp_letexception (a, b) ->
          let acc = with_context self#extension_constructor Type_decl a acc in
          self#expression b acc
      | _ -> self#any_expression exp acc

    (** Structure items *)

    method! structure = with_context super#structure Str
    method! value_binding = with_context super#value_binding Value
    method! type_declaration = with_context super#type_declaration Type_decl
    method! type_extension = with_context super#type_extension Type_decl
    method! type_exception = with_context super#type_exception Type_decl
    method! module_binding = with_context super#module_binding Module_decl

    method! module_type_declaration =
      with_context super#module_type_declaration Module_type_decl

    method! class_declaration = with_context super#class_declaration Class_decl

    method! class_type_declaration =
      with_context super#class_type_declaration Class_type_decl

    method! open_declaration = with_context super#open_declaration Open
    method! include_declaration = with_context super#include_declaration Include

    (** Signature items *)

    method! signature = with_context super#signature Sig
    method! value_description = with_context super#value_description Value

    method! module_declaration =
      with_context super#module_declaration Module_decl

    method! module_substitution =
      with_context super#module_substitution Module_decl

    method! include_description = with_context super#include_description Include
    method! class_description = with_context super#class_description Class_decl
  end

type t = acc * grepper

let grepper context match_ =
  ((Ppxlib.Location.none, Match_context.init context), new grepper match_)

let impl (init, grepper) lexbuf =
  ignore (grepper#structure (Ppxlib.Parse.implementation lexbuf) init)

let intf (init, grepper) lexbuf =
  ignore (grepper#signature (Ppxlib.Parse.interface lexbuf) init)
