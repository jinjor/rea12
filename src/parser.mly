%token <int> INT
%token <string> STRING
%token PLUS MINUS TIMES DIV
%token LPAREN RPAREN
%token LBRACKET RBRACKET
%token QUOTE
%token EOL EOF
%left LINESEP
%left PLUS MINUS
%left TIMES DIV
%nonassoc UMINUS
%start main
%type <Ast.program_ast> main
%%
main:
    statements EOF                { $1 }
;
statements:
    expr                     { Ast.Statements ($1, Ast.EndOfStatements) }
  | expr EOL statements      { Ast.Statements ($1, $3) }
;

expr:
    INT                     { Ast.IntLiteral $1 }
  | QUOTE INT QUOTE %prec STRING { Ast.StringLiteral (string_of_int $2) }
  | LPAREN expr RPAREN      { $2 }
  | expr PLUS expr          { Ast.Add ($1, $3) }
  | expr MINUS expr         { Ast.Substract ($1, $3) }
  | expr TIMES expr         { Ast.Multiply ($1, $3) }
  | expr DIV expr           { Ast.Divide ($1, $3) }
  | MINUS expr %prec UMINUS { Ast.UMinus $2 }
;