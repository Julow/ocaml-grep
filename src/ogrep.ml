let rec scan_path f path =
  if Sys.is_directory path then scan_dir f path else f path

and scan_dir f parent =
  let files = Sys.readdir parent in
  Array.sort String.compare files;
  Array.iter (fun child -> scan_path f (Filename.concat parent child)) files

let match_ matches pattern (loc : Ppxlib.Ast.location) context s =
  if (not loc.loc_ghost) && String.equal pattern s then
    let { Ppxlib.Ast.pos_lnum; pos_cnum; _ } = loc.loc_start in
    matches := (pos_lnum, pos_cnum, context) :: !matches
  else ()

let show_matches file matches =
  matches
  |> List.sort_uniq (fun (a, a', _) (b, b', _) ->
         let d = a - b in
         if d = 0 then a' - b' else d)
  |> List.fold_left
       (fun last_printed (lnum, _, context) ->
         if last_printed < lnum then
           Format.printf "%s:%d:(%a)%s\n" (Text_file.path file) lnum
             (Format.pp_print_list Grep_parsetree.pp_context)
             context (Text_file.line file lnum);
         lnum)
       (-1)
  |> ignore

let run_on_file run_grepper ~pattern path =
  let file = Text_file.read path in
  let matches = ref [] in
  let grepper = new Grep_parsetree.grepper (match_ matches pattern) in
  run_grepper grepper (Text_file.lexbuf file);
  show_matches file !matches

let run pattern inputs =
  List.iter
    (scan_path (fun path ->
         match Filename.extension path with
         | ".ml" -> run_on_file Grep_parsetree.impl ~pattern path
         | ".mli" -> run_on_file Grep_parsetree.intf ~pattern path
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
  let term = Term.(const run $ pos_pattern $ pos_inputs) in
  Cmd.(v (info "ogrep" ~doc) term)

let () = exit (Cmd.eval cmd)
