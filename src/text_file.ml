type t = { path : string; lines : string array }

let read path =
  let ic = open_in path in
  let read_contents () =
    let lines = ref [] in
    try
      while true do
        lines := input_line ic :: !lines
      done;
      assert false
    with End_of_file ->
      let lines = Array.of_list !lines in
      let len = Array.length lines in
      (* reverse *)
      Array.init len (fun i -> lines.(len - i - 1))
  in
  let finally () = close_in ic in
  let lines = Fun.protect ~finally read_contents in
  { path; lines }

let path t = t.path

let lexbuf { path; lines } =
  let line_i = ref 0 in
  let line_off = ref 0 in
  let refill buf n =
    let li = !line_i and lo = !line_off in
    if li = Array.length lines then 0 (* end of file *)
    else
      let line = lines.(li) in
      let n' = min n (String.length line - lo) in
      Bytes.blit_string line lo buf 0 n';
      let lo' = lo + n' in
      if lo' = String.length line && n' < n then (
        (* End of line && Space for newline char *)
        Bytes.set buf n' '\n';
        line_i := li + 1;
        line_off := 0;
        n' + 1)
      else (
        line_off := lo';
        n')
  in
  let lb = Lexing.from_function refill in
  Lexing.set_filename lb path;
  lb

let line t i = t.lines.(i - 1)

let lines_count t = Array.length t.lines
