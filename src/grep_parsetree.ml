class grepper match_ =
  object
    inherit [_] Ppxlib.Ast_traverse.map_with_context as super

    method! loc f _ t = super#loc f t.Ppxlib_ast.Ast.loc t

    method! string loc s =
      match_ loc s;
      s
  end

let parse_source_file path f =
  let ic = open_in path in
  let finally () = close_in ic in
  Fun.protect ~finally (fun () ->
      let lexbuf = Lexing.from_channel ic in
      Lexing.set_filename lexbuf path;
      f lexbuf)

let impl grepper path =
  ignore
    (grepper#structure Ppxlib.Location.none
       (parse_source_file path Ppxlib.Parse.implementation))

let intf grepper path =
  ignore
    (grepper#signature Ppxlib.Location.none
       (parse_source_file path Ppxlib.Parse.interface))
