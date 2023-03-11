type t = (Context.t option * Context.rule) list
(** Possible rules and parent context that might disable it. *)

let init rule = [ (None, rule) ]
let is_fail t = t = []
let is_done t = List.exists (fun (_, rule) -> rule = Context.Leaf) t

let enter t ctx =
  let parent = Context.parent ctx in
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
  List.fold_left advance_rule [] t
