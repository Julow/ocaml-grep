type t = Context.t list

let rec match_ pat_context context =
  match (pat_context, context) with
  | [], _ -> true
  | _ :: _, [] -> false
  | a :: a', b :: b' -> a = b && match_ a' b'
