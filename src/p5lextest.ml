(*
fun buf ->
    parser
    [ [: `'['; `'<' :] ->
        Plexing.Lexbuf.add '<' (Plexing.Lexbuf.add '[' buf)
    | [: `'['; `':' :] ->
        Plexing.Lexbuf.add ':' (Plexing.Lexbuf.add '[' buf)
    | [: `'[' :] ->
        Plexing.Lexbuf '[' buf ];
        *)