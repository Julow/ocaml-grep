type t = Context.rule list
(** List of possible rules *)

let init rule = [ rule ]
let is_fail t = t = []
let is_done t = List.mem Context.Leaf t

let enter t ctx =
  List.fold_left
    (fun acc rule ->
      match rule with
      | Context.Leaf -> [ Context.Leaf ]
      | Direct (ctx', rule') as rule ->
          if ctx = ctx' then rule' :: rule :: acc else rule :: acc
      | Indirect (ctx', rule') as rule ->
          if ctx = ctx' then rule' :: acc else rule :: acc)
    [] t

let _pf = Format.fprintf

let pp_internal ppf t =
  let pp_sep ppf () = _pf ppf ",@ " in
  let pp_rule ppf = function
    | Context.Leaf -> _pf ppf "<leaf>"
    | rule -> _pf ppf "@[<2>%a@]" Context.pp_rule rule
  in
  _pf ppf "@[<hov>%a@]" (Format.pp_print_list ~pp_sep pp_rule) t
