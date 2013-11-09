type expression_ast =
    StringLiteral of string
  | IntLiteral of int
  | Add of expression_ast * expression_ast
  | Substract of expression_ast * expression_ast
  | Multiply of expression_ast * expression_ast
  | Divide of expression_ast * expression_ast
  | UMinus of expression_ast

type statements_ast =
    Statements of expression_ast * statements_ast
  | EndOfStatements

type program_ast = statements_ast