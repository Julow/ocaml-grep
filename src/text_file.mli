(** Read a text file in memory and query individual lines. *)

type t

val read : string -> t
(** [read path] Reads a file and keeps its content in memory.
    @raises Sys_error *)

val path : t -> string

val lexbuf : t -> Lexing.lexbuf
(** Suitable input for a parser. *)

val line : t -> int -> string
(** Obtain a line of the file, the returned string doesn't contain line endings.
    The first line is at index [1].
    @raises Invalid_argument if the given index is out of bounds. *)

val lines_count : t -> int
(** Number of line in the file. *)
