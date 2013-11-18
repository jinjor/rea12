%token <int> INT
%token <string> STRING
%token <string> ID
%token EQ
%token RARROW
%token LPAREN RPAREN
%token LBRACKET RBRACKET
%token QUOTE
%token EOL EOF
%start main
%type <Ast.program_ast> main
%%


main:
    statements EOF          { $1 }
;
statement:
    func                    { Ast.FuncStatement ($1) }
  | def                     { Ast.DefStatement ($1) }
;
statements:
  | statement EOL statements  { Ast.Statements ($1, $3) }
  | expr                      { Ast.LastStatement ($1) }
;
pattern:
    id                      { Ast.IdPattern $1 }
;
lambda:
    func                    { Ast.EndOfLambda ($1) }
  | pattern RARROW lambda   { Ast.Lambda ($1, $3) }
;
def:
    pattern EQ lambda       { Ast.Def ($1, $3) }
;
func:
    expr                    { Ast.Function ($1, Ast.EndOfFunction) }
  | expr func               { Ast.Function ($1, $2) }
;
expr:
  | INT                     { Ast.IntLiteral $1 }
  | STRING                  { Ast.StringLiteral $1 }
  | id                      { Ast.IdExpression $1 }
  | LPAREN lambda RPAREN    { Ast.LambdaExpression $2 }
  | LBRACKET statements RBRACKET { Ast.StatementsExpression $2 }
;
id:
  ID                        { Ast.Id $1 }
;


