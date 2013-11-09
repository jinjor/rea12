let load_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = String.create n in
  really_input ic s 0 n;
  close_in ic;
  (s)

let log s =
  print_string s;
  print_newline()

let rec js_of_statements ast =
  match ast with
      Ast.EndOfStatements -> ""
    | Ast.Statements (head, tail) ->
        match tail with
            Ast.EndOfStatements -> (js_of_expr head)
          | _ -> (js_of_expr head) ^ "\n" ^ (js_of_statements tail)

and js_of_expr ast =
  match ast with
        Ast.IntLiteral i -> string_of_int i
      | Ast.StringLiteral s -> "'" ^ s ^ "'"
      | Ast.Add (e1, e2) -> (js_of_expr e1) ^ "+" ^ (js_of_expr e2)
      | Ast.Substract (e1, e2) -> (js_of_expr e1) ^ "-" ^ (js_of_expr e2)
      | Ast.Multiply (e1, e2) -> (js_of_expr e1) ^ "*" ^ (js_of_expr e2)
      | Ast.Divide (e1, e2) -> (js_of_expr e1) ^ "/" ^ (js_of_expr e2)
      | Ast.UMinus (e) -> "-" ^ (js_of_expr e)




exception Unknown
let write_file file_name s : unit =
  let out = open_out file_name in
  try
    output_string out s;
  with
  | _ -> print_string ("error while writing file" ^ file_name);
  close_out out

let _ =
  try
    let dir = Sys.getcwd() in
    let source_name = "sample1" in
    let input_file_name = dir ^ "/sample/" ^ source_name ^ ".alt" in
    let output_file_name = dir ^ "/sample/" ^ source_name ^ ".js" in

    let source = load_file input_file_name in
    log source;
    let lexbuf = Lexing.from_string source in
    log "start!";
    let result = Parser.main Lexer.token lexbuf in
    let output_str = js_of_statements result in
    log output_str;
    write_file output_file_name output_str;
    log "end!";
    exit 0
  with _ ->
    log "error!";
    exit 1


