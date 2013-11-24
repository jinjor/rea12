open File_util

let p = Console.print "Compiler"
let indent i = String.make (i * 2) ' '

let rec js_of_module ast = match ast with
      Ast.Module statements -> "Async.bind(Async.unit(), function(){\n" ^
        (js_of_statements statements 1) ^
        "})(function(){});\n"

and js_of_statements ast i = match ast with
      Ast.LastStatement func -> (indent i) ^ "return Async.unit(" ^ (js_of_function func i) ^ ");\n"
    | Ast.Statements (head, tail) ->
          (js_of_statement head tail i)

and js_of_statement ast rest i = match ast with
      Ast.DefStatement (Ast.Def (pattern, func)) ->
        let defs = defs_of_pattern_def pattern func i in
        String.concat "" defs ^
        (js_of_statements rest i)
    | Ast.ExpandStatement (Ast.Expand (pattern, func)) ->
      let (args, defs) = str_of_pattern_lambda pattern i in
      let arg2 = "function(" ^ String.concat "," args ^ "){\n" ^
        String.concat "" defs ^
        (js_of_statements rest (i + 1)) ^ "\n" ^
        (indent i) ^ "}"
      in
      (indent i) ^ "return Async.bind(" ^ js_of_function func i ^ "," ^ arg2 ^ ");\n"
    | Ast.FuncStatement (Ast.EndOfFunction) -> "" ^
        (js_of_statements rest i)
    | Ast.FuncStatement (func) -> (indent i) ^ js_of_function func i ^
        (js_of_statements rest i)
    | Ast.EmptyStatement -> "" ^
        (js_of_statements rest i)

and defs_of_pattern_def pattern func i = match pattern with
      Ast.IdPattern (Ast.Id id) -> [(indent i) ^ "var " ^ id ^ "=" ^ (js_of_function func i) ^ ";\n"]

and str_of_pattern_lambda pattern i = match pattern with
      Ast.IdPattern (Ast.Id id) -> ([id], [])

and js_of_lambda ast i = match ast with
      Ast.Lambda (pattern, lambda) ->
        let (args, defs) = str_of_pattern_lambda pattern i in
        let def_statements = List.map (fun s -> (indent (i + 1)) ^ s ^ "\n") defs in
        "function(" ^ String.concat "," args ^ "){\n" ^
        String.concat "" def_statements ^
        (indent (i + 1)) ^ "return " ^ (js_of_lambda lambda (i+1)) ^ ";\n" ^
        (indent i) ^ "}"
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
        "(function(){\n" ^ (js_of_statements statements (i + 1))^ "\n" ^
          (indent i) ^ "})"


exception Unknown

let exec input_file_name output_file_name =
  try
    let source = load_file input_file_name in
    p source;
    let lexbuf = Lexing.from_string source in
    p "start!";
    let result = Parser.main Lexer.token lexbuf in
    let output_str = js_of_module result in
    p output_str;
    write_file output_file_name output_str;
    p "end!"
  with e ->
    p (Printexc.to_string e);
    p "error!"

