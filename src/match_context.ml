type t = (Context.t option * Context.rule) list
(** Possible rules and parent context that might disable it. *)

let init rule = [ (None, rule) ]
let is_fail t = t = []
let is_done t = List.exists (fun (_, rule) -> rule = Context.Leaf) t

let debug_pp ppf t =
  let _pf = Format.fprintf in
  let pp_sep ppf () = _pf ppf ",@ " in
  let pp_parent ppf parent = _pf ppf "%s@@" (Context.to_string parent) in
  let pp_rule ppf = function
    | _, Context.Leaf -> _pf ppf "<leaf>"
    | parent, rule ->
        _pf ppf "@[<2>%a%a@]"
          Format.(pp_print_option pp_parent)
          parent Context.pp_rule rule
  in
  _pf ppf "@[<hov>%a@]" (Format.pp_print_list ~pp_sep pp_rule) t

let enter_one t ~parent ctx =
  let prune_parent acc ((parent', _) as rule) =
    match parent' with
    | Some parent' when parent <> parent' -> acc
    | _ -> rule :: acc
  in
  let advance_rule acc = function
    | (_, Context.Leaf) as rule -> prune_parent acc rule
    | (_, Direct (ctx', rule')) as rule ->
        if ctx = ctx' then (Some parent, rule') :: acc
        else prune_parent acc rule
    | (_, Indirect (ctx', rule')) as rule ->
        if ctx = ctx' then (Some parent, rule') :: rule :: acc
        else prune_parent acc rule
  in
  let t = List.fold_left advance_rule [] t in
  Logs.debug (fun l ->
      l "%t%s  (%a)" Debug.pp_level (Context.to_string ctx) debug_pp t);
  t

let rec enter t ctx =
  let parent = Context.parent ctx in
  let t = if parent <> ctx then enter t parent else t in
  enter_one t ~parent ctx
