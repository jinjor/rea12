exception LexErr of string
exception ParseErr of string

let error msg start finish  =
    Printf.sprintf "(line %d: char %d..%d): %s" start.pos_lnum
          (start.pos_cnum -start.pos-bol) (finish.pos_cnum - finish.pos_bol) msg

let lex_error lexbuf =
    raise ( LexErr (error (lexeme lexbuf) (lexeme_start_p lexbuf) (lexeme_end_p lexbuf)))

let parse_error msg nterm =
    raise ( ParseErr (error msg (rhs_start_p nterm) (rhs_end_p nterm)))