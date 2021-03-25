let rec scan_file f path =
  if Sys.is_directory path then scan_dir f path else f path

and scan_dir f parent =
  let files = Sys.readdir parent in
  Array.sort String.compare files;
  Array.iter (fun child -> scan_file f (Filename.concat parent child)) files

let match_ pattern loc s =
  if String.equal pattern s then
    let { Ppxlib.Ast.pos_fname; pos_lnum; pos_cnum; _ } =
      loc.Ppxlib.Ast.loc_start
    in
    Printf.printf "%s:%d:%d\n" pos_fname pos_lnum pos_cnum

let run pattern inputs =
  let grepper = new Grep_parsetree.grepper (match_ pattern) in
  List.iter
    (scan_file (fun path ->
         match Filename.extension path with
         | ".ml" -> Grep_parsetree.impl grepper path
         | ".mli" -> Grep_parsetree.intf grepper path
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
