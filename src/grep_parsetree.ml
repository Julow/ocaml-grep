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

let parse_source_file path f =
  let ic = open_in path in
  let finally () = close_in ic in
  Fun.protect ~finally (fun () ->
      let lexbuf = Lexing.from_channel ic in
      Lexing.set_filename lexbuf path;
      f lexbuf)

let impl grepper path =
  List.rev
    (snd
       (grepper#structure
          (parse_source_file path Ppxlib.Parse.implementation)
          init))

let intf grepper path =
  List.rev
    (snd
       (grepper#signature (parse_source_file path Ppxlib.Parse.interface) init))
