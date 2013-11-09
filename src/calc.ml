let load_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = String.create n in
  really_input ic s 0 n;
  close_in ic;
  (s)

let _ =
  let dir = Sys.getcwd() in
  let source = load_file (dir ^ "/sample/sample1.alt") in
  print_string (source ^ "\n");
  try
    let lexbuf = Lexing.from_string source in
    print_string "start!\n";
    let result = Parser.main Lexer.token lexbuf in
    print_int result;
    print_newline();
    print_string "end!\n";
    exit 0
  with _ ->
    print_string "error!\n";
    exit 1