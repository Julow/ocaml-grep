(** Keep track of the context and whether it matches the specified rules. *)

type t

val init : Context.rule -> t

val enter : t -> Context.t -> t
(** Enter a context. See {!is_done} and {!is_fail}. *)

val is_fail : t -> bool
(** No more match are possible inside this node. *)

val is_done : t -> bool
(** Context rules are validated *)
