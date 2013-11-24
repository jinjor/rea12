open File_util

let p = Console.print "Compiler"
let indent i = String.make (i * 2) ' '

let rec js_of_statements ast i = match ast with
      Ast.LastStatement func -> (indent i) ^ "return Async.unit(" ^ (js_of_function func i) ^ ");"
    | Ast.Statements (head, tail) ->
          (js_of_statement head tail i)

and js_of_statement ast rest i = match ast with
      Ast.DefStatement (Ast.Def (pattern, lambda)) ->
        (indent i) ^ "var " ^ (js_of_pattern pattern) ^ "=" ^ (js_of_lambda lambda i) ^ ";\n" ^
        (js_of_statements rest i)
    | Ast.ExpandStatement (Ast.Expand (pattern, func)) ->
        (indent i) ^ "return Async.bind(" ^ js_of_function func i ^ ",function(" ^ (js_of_pattern pattern) ^ "){\n" ^
          (js_of_statements rest (i + 1)) ^ "\n" ^
          (indent i) ^ "});\n"
    | Ast.FuncStatement (Ast.EndOfFunction) -> "" ^
        (js_of_statements rest i)
    | Ast.FuncStatement (func) -> (indent i) ^ js_of_function func i ^
        (js_of_statements rest i)
    | Ast.EmptyStatement -> "" ^
        (js_of_statements rest i)

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

let exec input_file_name output_file_name =
  try
    let source = load_file input_file_name in
    p source;
    let lexbuf = Lexing.from_string source in
    p "start!";
    let result = Parser.main Lexer.token lexbuf in
    let output_str = js_of_statements result 0 in
    p output_str;
    write_file output_file_name output_str;
    p "end!"
  with e ->
    p (Printexc.to_string e);
    p "error!"

