let load_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = String.create n in
  really_input ic s 0 n;
  close_in ic;
  (s)

let write_file file_name s : unit =
  let out = open_out file_name in
  try
    output_string out s;
  with
  | _ -> print_string ("error while writing file" ^ file_name);
  close_out out