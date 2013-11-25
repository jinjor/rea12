open File_util

let p = Console.print "Compiler"
let np s = p ("\n" ^ s)

let indent i = String.make (i * 2) ' '

type var = Var of string * Ast.function_ast
type return =
  | Return of Ast.lambda_ast
  | Return_statements of Ast.statements_ast
and js_lambda =
  | Js_lambda of (string list) * (var list) * return

let rec js_of_module ast = match ast with
      Ast.Module statements ->
        let func_str = "function(){\n" ^
          (indent 1) ^ (js_of_statements statements 1) ^
          "}"
        in
        "Async.bind(Async.unit()," ^ func_str ^ ")(function(e){console.log(e);});\n"

and js_of_statements ast i = match ast with
      Ast.LastStatement func -> "return Async.unit(" ^ (js_of_function func i) ^ ");\n"
    | Ast.Statements (head, tail) -> (js_of_statement head tail i)

and js_of_statement ast rest i = match ast with
      Ast.DefStatement (Ast.Def (pattern, func)) ->
        let vars = defs_of_pattern_def pattern func i in
        let vars_str = List.map (fun v -> js_of_var v i) vars in
        String.concat "" vars_str ^
        (js_of_statements rest i)
    | Ast.ExpandStatement (Ast.Expand (pattern, func)) ->
      let (args, vars) = str_of_pattern_lambda pattern i in
      let arg2 = js_of_lambda_ (Js_lambda (args, vars, Return_statements rest)) i in
      (indent i) ^ "return Async.bind(" ^ js_of_function func i ^ "," ^ arg2 ^ ");\n"
    | Ast.FuncStatement (Ast.EndOfFunction)-> "" ^
        (js_of_statements rest i)
    | Ast.FuncStatement (func) -> (indent i) ^ js_of_function func i ^
        (js_of_statements rest i)
    | Ast.EmptyStatement -> "" ^
        (js_of_statements rest i)

and defs_of_pattern_def pattern func i : var list = match pattern with
    | Ast.IdPattern (Ast.Id id) -> [Var (id, func)]

and js_of_var var i = match var with
    | Var (name, func) -> "var " ^ name ^ "=" ^ js_of_function func i ^ ";\n"

and str_of_pattern_lambda pattern i = match pattern with
      Ast.IdPattern (Ast.Id id) -> ([id], [])

and js_of_lambda ast i = match ast with
      Ast.Lambda (pattern, lambda) ->
        let (args, vars) = str_of_pattern_lambda pattern i in
        js_of_lambda_ (Js_lambda (args, vars, Return lambda)) i
    | Ast.EndOfLambda func -> js_of_function func i

and js_of_lambda_ js_lambda i = match js_lambda with
    | Js_lambda (args, vars, return) ->
      let def_statements = List.map (fun v -> js_of_var v i) vars in
      "function(" ^ String.concat "," args ^ "){\n" ^
        String.concat "" def_statements ^
        (indent (i + 1)) ^ (js_of_return return (i+1)) ^
        (indent i) ^ "}"

and js_of_return return i = match return with
    | Return lambda -> "return " ^ js_of_lambda lambda i
    | Return_statements statements -> js_of_statements statements i

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
      | Ast.BlockExpression block -> js_of_block block i

and js_of_block ast i = match ast with
    | Ast.LastStatement func ->
      (indent i) ^ "Async.unit(" ^ (js_of_function func i) ^ ")"
    | statements ->
      let f = Js_lambda ([], [], Return_statements statements) in
      let f_str = js_of_lambda_ f (i + 1) in
      "Async.bind(Async.unit()," ^ f_str ^ ")"

exception Unknown

let exec input_file_name output_file_name =
  try
    let source = load_file input_file_name in
    np source;
    let lexbuf = Lexing.from_string source in
    p "start!";
    let result = Parser.main Lexer.token lexbuf in
    let output_str = js_of_module result in
    np output_str;
    write_file output_file_name output_str;
    p "end!"
  with e ->
    p (Printexc.to_string e);
    p "error!"

