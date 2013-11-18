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


let indent i = String.make i '\t'

let rec js_of_statements ast i = match ast with
      Ast.LastStatement expr -> (indent i) ^ "return " ^ js_of_expr expr i ^ ";"
    | Ast.Statements (head, tail) ->
          (js_of_statement head i) ^ ";\n"
              ^ (js_of_statements tail i)



and js_of_statement ast i = match ast with
      Ast.DefStatement (Ast.Def (pattern, lambda)) ->
        (indent i) ^ (js_of_pattern pattern) ^ "=" ^ (js_of_lambda lambda i)
    | Ast.FuncStatement (Ast.EndOfFunction) -> ""
    | Ast.FuncStatement (func) -> (indent i) ^ js_of_function func i
    | Ast.EmptyStatement -> ""

and js_of_pattern ast = match ast with
      Ast.IdPattern (Ast.Id id) -> id

and js_of_lambda ast i = match ast with
      Ast.Lambda (pattern, lambda) ->
        "function(" ^ (js_of_pattern pattern) ^ "){\n"
        ^ (indent (i + 1)) ^ "return " ^ (js_of_lambda lambda i) ^ ";\n"
        ^ (indent i) ^ "}"
    | Ast.EndOfLambda func -> js_of_function func i

and js_of_function ast i = match ast with
      Ast.Function (head, tail) -> (js_of_expr head i) ^ (js_of_function_ tail i)
    | Ast.EndOfFunction -> ""

and js_of_function_ ast i = match ast with
      Ast.Function (head, tail) -> "(" ^ (js_of_expr head i) ^ ")" ^ (js_of_function_ tail i)
    | Ast.EndOfFunction -> ""

and js_of_expr ast i = match ast with
        Ast.IntLiteral _int -> string_of_int _int
      | Ast.StringLiteral s -> "'" ^ s ^ "'"
      | Ast.IdExpression (Ast.Id id) -> id
      | Ast.LambdaExpression lambda -> js_of_lambda lambda i
      | Ast.StatementsExpression statements ->
        "(function(){\n" ^ (js_of_statements statements (i + 1))^ "\n})"

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
    let output_str = js_of_statements result 0 in
    log output_str;
    write_file output_file_name output_str;
    log "end!";
    exit 0
  with e ->
    log (Printexc.to_string e);
    log "error!";
    exit 1


