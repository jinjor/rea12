{
open Parser        (* The type token is defined in parser.mli *)
open Lexing
exception Eof

let buf = Buffer.create 100
let store lexbuf = Buffer.add_string buf (lexeme lexbuf)
let reset() = Buffer.reset buf
let contents() = Buffer.contents buf
}

let digit1 = ['1'-'9']
let digit = '0' | digit1
let lchar = ['a'-'z']
let uchar = ['A'-'Z']
let char = lchar | uchar
let id = lchar (char | digit)*
let escape_char = "\\n" | "\\t" | "\\\"" | "\\\\"


rule token = parse
  | [' ' '\t']     { token lexbuf }
  | ['\n']         { EOL }
  | (digit1 digit*) as lxm { INT(int_of_string lxm) }
  | "->"           { RARROW }
  | "="            { EQ }
  | '('            { LPAREN }
  | ')'            { RPAREN }
  | '{'            { LBRACKET }
  | '}'            { RBRACKET }
  | id as s        { ID s }
  | '"' {
      reset();
      let pmin = lexeme_start lexbuf in
      let pmax = string lexbuf in
      let str = contents() in
      STRING str
    }
  | eof            { EOF }

and string = parse
  | eof { raise Exit }
  (*| '\n' | '\r' | "\r\n" { store lexbuf; string lexbuf }*)
  | "\\\"" { store lexbuf; string lexbuf }
  | "\\\\" { store lexbuf; string lexbuf }
  | '\\' { store lexbuf; string lexbuf }
  | '"' { lexeme_end lexbuf }
  | [^'"' '\\' '\r' '\n']+ { store lexbuf; string lexbuf }






