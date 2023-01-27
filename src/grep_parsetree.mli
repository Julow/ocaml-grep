type t

type match_ = Ppxlib.Ast.location -> string -> unit
(** Match function applied to every strings in the AST. *)

val grepper : Context.rule -> match_ -> t

val impl : t -> Lexing.lexbuf -> unit
(** Parse and grep and implementation file. *)

val intf : t -> Lexing.lexbuf -> unit
(** Parse and grep and interface file. *)
