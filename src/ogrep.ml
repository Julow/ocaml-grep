let rec scan_path f path =
  if Sys.is_directory path then scan_dir f path else f path

and scan_dir f parent =
  let files = Sys.readdir parent in
  Array.sort String.compare files;
  Array.iter (fun child -> scan_path f (Filename.concat parent child)) files

let match_ matches ~pattern (loc : Ppxlib.Ast.location) s =
  if loc.loc_ghost then ()
  else
    let { Ppxlib.Ast.pos_lnum; pos_cnum; _ } = loc.loc_start in
    Logs.debug (fun l -> l "String in context: %d:%d: %S" pos_lnum pos_cnum s);
    if String.equal pattern s then matches := (pos_lnum, pos_cnum) :: !matches
    else ()

let show_matches file matches =
  matches
  |> List.sort_uniq (fun (a, a') (b, b') ->
         let d = a - b in
         if d = 0 then a' - b' else d)
  |> List.fold_left
       (fun last_printed (lnum, _) ->
         if last_printed < lnum then
           Printf.printf "%s:%d:%s\n" (Text_file.path file) lnum
             (Text_file.line file lnum);
         lnum)
       (-1)
  |> ignore

let run_on_file run_grepper ~context ~pattern path =
  let file = Text_file.read path in
  let matches = ref [] in
  let grepper = Grep_parsetree.grepper context (match_ matches ~pattern) in
  run_grepper grepper (Text_file.lexbuf file);
  show_matches file !matches

let run () context pattern inputs =
  Logs.debug (fun l -> l "Context rules: [ %a ]" Context.pp_rule context);
  List.iter
    (scan_path (fun path ->
         match Filename.extension path with
         | ".ml" -> run_on_file Grep_parsetree.impl ~pattern ~context path
         | ".mli" -> run_on_file Grep_parsetree.intf ~pattern ~context path
         | _ -> ()))
    inputs

open Cmdliner

let pat_context_docs = "PATTERN CONTEXT"

let context =
  let mk_ctx_flag ctx =
    let doc = Context.short_description ctx and docs = pat_context_docs in
    (ctx, Arg.info ~docs ~doc [ Context.to_string ctx ])
  in
  let flags = List.map mk_ctx_flag Context.all in
  let mk_context flags =
    let open Context in
    List.fold_left (fun acc c' -> Indirect (c', acc)) Leaf flags
  in
  Term.(const mk_context $ Arg.(value & vflag_all [] flags))

let pos_pattern =
  let doc = "A regular expression accepted by OCaml's Str library." in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"PATTERN" ~doc)

let pos_inputs =
  let doc =
    "Files or directories to search. Directories are searched recursively."
  in
  Arg.(value & pos_right 1 string [ "." ] & info [] ~docv:"INPUTS" ~doc)

let logs =
  let setup_logs style_renderer level =
    Fmt_tty.setup_std_outputs ?style_renderer ();
    Logs.set_level level;
    Logs.set_reporter (Logs_fmt.reporter ())
  in
  Term.(const setup_logs $ Fmt_cli.style_renderer () $ Logs_cli.level ())

let cmd =
  let doc =
    "Grep OCaml source code. Matches a $(b,pattern) against every names \
     present in source code."
  in
  let term = Term.(const run $ logs $ context $ pos_pattern $ pos_inputs) in
  Cmd.(v (info "ogrep" ~doc) term)

let () = exit (Cmd.eval cmd)
