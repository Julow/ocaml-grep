let rec scan_file f path =
  if Sys.is_directory path then scan_dir f path else f path

and scan_dir f parent =
  let files = Sys.readdir parent in
  Array.sort String.compare files;
  Array.iter (fun child -> scan_file f (Filename.concat parent child)) files

let match_ pattern (loc : Ppxlib.Ast.location) s acc =
  if (not loc.loc_ghost) && String.equal pattern s then
    let { Ppxlib.Ast.pos_lnum; pos_cnum; _ } = loc.loc_start in
    (pos_lnum, pos_cnum) :: acc
  else acc

let show_matches file matches =
  List.fold_left
    (fun last_printed (lnum, _) ->
      if last_printed < lnum then
        Printf.printf "%s:%d:%s\n" (Text_file.path file) lnum
          (Text_file.line file lnum);
      lnum)
    (-1) matches
  |> ignore

let run_on_file do_grep path =
  let file = Text_file.read path in
  do_grep (Text_file.lexbuf file)
  |> List.sort_uniq (fun (a, a') (b, b') ->
         let d = a - b in
         if d = 0 then a' - b' else d)
  |> show_matches file

let run pattern inputs =
  let grepper = new Grep_parsetree.grepper (match_ pattern) in
  List.iter
    (scan_file (fun path ->
         match Filename.extension path with
         | ".ml" -> run_on_file (Grep_parsetree.impl grepper) path
         | ".mli" -> run_on_file (Grep_parsetree.intf grepper) path
         | _ -> ()))
    inputs

open Cmdliner

let pos_pattern =
  let doc = "A regular expression accepted by OCaml's Str library." in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"PATTERN" ~doc)

let pos_inputs =
  let doc =
    "Files or directories to search. Directories are searched recursively."
  in
  Arg.(value & pos_right 1 string [ "." ] & info [] ~docv:"INPUTS" ~doc)

let cmd =
  let doc =
    "Grep OCaml source code. Matches a $(e,pattern) against every names \
     present in source code."
  in
  Term.(const run $ pos_pattern $ pos_inputs, info "ogrep" ~doc)

let () = Term.exit @@ Term.eval cmd
