(* exception File_util_exception of string *)

let loan_in file_name f : string =
  let ic = open_in file_name in
  try
    let ret = f ic in
    close_in ic;
    ret
  with
  | e ->
    close_in ic;
    raise e


let load_file file_name =
  let f:in_channel -> string = fun ic ->
    let n = in_channel_length ic in
    let s = String.create n in
    really_input ic s 0 n;
    (s)
  in
  loan_in file_name f

let loan_out file_name f =
  let out = open_out file_name in
  try
    f out;
  with
  | e ->
    close_out out;
    raise e
  close_out out

let write_file file_name s : unit =
  loan_out file_name (fun out -> output_string out s)