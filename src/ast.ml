type expression_ast =
    StringLiteral of string
  | IntLiteral of int
  | LambdaExpression of lambda_ast
  | IdExpression of id_ast
  | StatementsExpression of statements_ast

and function_ast =
    Function of expression_ast * function_ast
  | EndOfFunction

and id_ast =
    Id of string

and pattern_ast =
    IdPattern of id_ast

and lambda_ast =
    Lambda of pattern_ast * lambda_ast
  | EndOfLambda of function_ast

and def_ast =
    Def of pattern_ast * lambda_ast

and statement_ast =
    FuncStatement of function_ast
  | DefStatement of def_ast
  | EmptyStatement

and statements_ast =
    Statements of statement_ast * statements_ast
  | EndOfStatements

and program_ast = statements_ast