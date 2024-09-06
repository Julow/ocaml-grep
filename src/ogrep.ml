type output_options = { column : bool; separate_matches : bool }

let rec scan_path f path =
  match Sys.is_directory path with
  | exception Sys_error msg -> Logs.err (fun l -> l "%s" msg)
  | true -> scan_dir f path
  | false -> f path

and scan_dir f parent =
  match Sys.readdir parent with
  | exception Sys_error msg -> Logs.err (fun l -> l "%s" msg)
  | files ->
    Array.sort String.compare files;
    Array.iter (fun child -> scan_path f (Filename.concat parent child)) files

let match_ matches ~pattern (loc : Ppxlib.Ast.location) s =
  if loc.loc_ghost then ()
  else
    let { Ppxlib.Ast.pos_lnum; pos_cnum; pos_bol; _ } = loc.loc_start in
    let cnum = pos_cnum - pos_bol in
    Logs.debug (fun l -> l "%t  %S  (%d:%d)" Debug.pp_level s pos_lnum cnum);
    if String.equal pattern s then
      matches := (pos_lnum, cnum, String.length s) :: !matches
    else ()

let show_matches ~output_options file matches =
  let group_matches =
    let rec loop acc = function
      | [] -> List.rev acc
      | ((lnum, _, _) as hd) :: tl ->
          let extra_matches, tl = gather_group [] lnum tl in
          loop ((hd, extra_matches) :: acc) tl
    and gather_group acc lnum = function
      | ((lnum', _, _) as hd) :: tl when lnum = lnum' ->
          gather_group (hd :: acc) lnum tl
      | tl -> (List.rev acc, tl)
    in
    loop []
  in
  let separate_matches = List.map (fun m -> (m, [])) in
  let maybe_group_matches =
    if output_options.separate_matches then separate_matches else group_matches
  in
  let pp_column ppf cnum =
    if output_options.column then Fmt.pf ppf ":%d" cnum else ()
  in
  let pp_line_str ppf (((lnum, _, _) as first_match), extra_matches) =
    let str = Text_file.line file lnum in
    let print_match printed_col (_, cnum, len) =
      if printed_col < cnum then
        Fmt.string ppf (String.sub str printed_col (cnum - printed_col));
      Fmt.styled (`Bg `Yellow) Fmt.string ppf (String.sub str cnum len);
      cnum + len
    in
    let printed_col =
      List.fold_left print_match (print_match 0 first_match) extra_matches
    in
    Fmt.string ppf
      (String.sub str printed_col (String.length str - printed_col))
  in
  let pr_match (((lnum, cnum, _), _) as matches) =
    Fmt.pr "%s:%d%a:%a\n" (Text_file.path file) lnum pp_column cnum pp_line_str
      matches
  in
  matches
  |> List.sort_uniq (fun (a, a', _) (b, b', _) ->
         let d = a - b in
         if d = 0 then a' - b' else d)
  |> maybe_group_matches |> List.iter pr_match

let run_on_file ~output_options run_grepper ~context ~pattern path =
  let file = Text_file.read path in
  let matches = ref [] in
  let grepper = Grep_parsetree.grepper context (match_ matches ~pattern) in
  match run_grepper grepper (Text_file.lexbuf file) with
  | exception _ -> Fmt.epr "%s: Syntax error@\n" path
  | () -> show_matches ~output_options file !matches

let run () output_options context pattern inputs =
  Logs.debug (fun l -> l "Context rules: [ %a ]" Context.pp_rule context);
  List.iter
    (scan_path (fun path ->
         match Filename.extension path with
         | ".ml" ->
             run_on_file ~output_options Grep_parsetree.impl ~pattern ~context
               path
         | ".mli" ->
             run_on_file ~output_options Grep_parsetree.intf ~pattern ~context
               path
         | _ -> ()))
    inputs

open Cmdliner

let context_docs = "CONTEXT MATCHING"
let rules_docs = "CONTEXT COMBINATORS"

(** Context rule arguments. *)
let context =
  let mk_ctx_flag ctx =
    let doc = Context.description ctx and docs = context_docs in
    (`Ctx ctx, Arg.info ~docs ~doc [ Context.to_string ctx ])
  in
  let mk_rule_flag r name doc = (r, Arg.info ~docs:rules_docs ~doc [ name ]) in
  let flags =
    [ mk_rule_flag `Direct "direct" "Match a directly nested context" ]
    @ List.map mk_ctx_flag Context.all
  in
  let mk_context flags =
    let open Context in
    let _, components =
      List.fold_left
        (fun (op, acc) flag ->
          (* Pair contextes and operators, in reverse order. *)
          match flag with
          | (`Direct | `Indirect) as x -> (x, acc)
          | `Ctx ctx -> (`Indirect, (op, ctx) :: acc))
        (`Indirect, [])
        flags
    in
    List.fold_left
      (fun acc (op, ctx) ->
        match op with
        | `Direct -> Direct (ctx, acc)
        | `Indirect -> Indirect (ctx, acc))
      Leaf components
  in
  Term.(const mk_context $ Arg.(value & vflag_all [] flags))

let output_options =
  let column =
    let doc = "Output the column number, counted in bytes starting from 1." in
    Arg.(value & flag & info [ "c"; "column" ] ~doc)
  and separate_matches =
    let doc =
      "Output matches in the same line separately. This implies $(b,--column)."
    in
    Arg.(value & flag & info [ "S"; "separate" ] ~doc)
  in
  let mk column separate_matches =
    let column = column || separate_matches in
    { column; separate_matches }
  in
  Term.(const mk $ column $ separate_matches)

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
  let term =
    Term.(
      const run $ logs $ output_options $ context $ pos_pattern $ pos_inputs)
  in
  Cmd.(v (info "ogrep" ~doc) term)

let () = exit (Cmd.eval cmd)
