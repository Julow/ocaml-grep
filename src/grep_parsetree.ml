type context = Type | Expr | Pattern | Root
type acc = Ppxlib.Ast.location * context list

let init = (Ppxlib.Location.none, [])

let with_context f x c' ((loc, c) as acc) =
  ignore (f x (loc, c' :: c));
  acc

class ['a] grepper match_ =
  object
    inherit [acc] Ppxlib.Ast_traverse.fold as super

    method! loc f t ((_prev_loc, c) as acc) =
      ignore (super#loc f t (t.Ppxlib_ast.Ast.loc, c));
      acc

    method! string s ((loc, c) as acc) =
      match_ loc c s;
      acc

    method! core_type typ acc = with_context super#core_type typ Type acc
    method! pattern pat acc = with_context super#pattern pat Pattern acc
    method! expression exp acc = with_context super#expression exp Expr acc
  end

let impl grepper lexbuf =
  ignore (grepper#structure (Ppxlib.Parse.implementation lexbuf) init)

let intf grepper lexbuf =
  ignore (grepper#signature (Ppxlib.Parse.interface lexbuf) init)

let pf = Format.fprintf

let pp_context ppf = function
  | Type -> pf ppf "type"
  | Expr -> pf ppf "expr"
  | Pattern -> pf ppf "pattern"
  | Root -> pf ppf "root"
