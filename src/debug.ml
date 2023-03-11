(** Updated during tree traversal. *)
let level = ref 0

let pp_level ppf = Format.fprintf ppf "%*s" !level ""
