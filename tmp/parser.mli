type token =
  | INT of (int)
  | STRING of (string)
  | PLUS
  | MINUS
  | TIMES
  | DIV
  | LPAREN
  | RPAREN
  | LBRACKET
  | RBRACKET
  | QUOTE
  | EOL
  | EOF

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.program_ast
