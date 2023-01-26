type t

type match_ = Ppxlib.Ast.location -> Context.t list -> string -> unit
(** Match function applied to every strings in the AST. *)

val grepper : match_ -> t

val impl : t -> Lexing.lexbuf -> unit
(** Parse and grep and implementation file. *)

val intf : t -> Lexing.lexbuf -> unit
(** Parse and grep and interface file. *)
