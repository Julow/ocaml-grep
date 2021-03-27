type 'a acc = Ppxlib.Ast.location * 'a list

let init = (Ppxlib.Location.none, [])

class ['a] grepper match_ =
  object
    inherit ['a acc] Ppxlib.Ast_traverse.fold as super

    method! loc f t (prev_loc, acc) =
      let _, acc' = super#loc f t (t.Ppxlib_ast.Ast.loc, acc) in
      (prev_loc, acc')

    method! string s (loc, acc) = (loc, match_ loc s acc)
  end

let impl grepper lexbuf =
  snd (grepper#structure (Ppxlib.Parse.implementation lexbuf) init)

let intf grepper lexbuf =
  snd (grepper#signature (Ppxlib.Parse.interface lexbuf) init)
