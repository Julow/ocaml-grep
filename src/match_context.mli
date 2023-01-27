(** Keep track of the context and whether it matches the specified rules. *)

type t

val init : Context.rule -> t
val enter : t -> Context.t -> t
val is_fail : t -> bool
val is_done : t -> bool

val pp_internal : Format.formatter -> t -> unit
(** Print internal states. *)
