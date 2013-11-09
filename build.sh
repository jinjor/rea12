ocamllex -o tmp/lexer.ml src/lexer.mll       # generates lexer.ml
ocamlyacc -b tmp/parser src/parser.mly     # generates parser.ml and parser.mli
ocamlc -c tmp/parser.mli
ocamlc -c -I tmp tmp/lexer.ml
ocamlc -c -I tmp tmp/parser.ml
ocamlc -c -I tmp -o tmp/calc src/calc.ml
ocamlc -o bin/calc tmp/lexer.cmo tmp/parser.cmo tmp/calc.cmo