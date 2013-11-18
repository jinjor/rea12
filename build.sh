mkdir -p tmp
mkdir -p bin

#export OCAMLRUNPARAM='p'

ocamllex -o tmp/lexer.ml src/lexer.mll       # generates lexer.ml
ocamlyacc -b tmp/parser src/parser.mly     # generates parser.ml and parser.mli
ocamlc -c -o tmp/ast src/ast.ml
#ocamlc -c -o tmp/ast src/err.ml
for f in parser.mli lexer.ml parser.ml
do
echo tmp/$f
ocamlc -c -I tmp -w -26 tmp/$f
done
ocamlc -c -I tmp -w -26 -warn-error P -o tmp/calc src/calc.ml
ocamlc -o bin/calc tmp/lexer.cmo tmp/parser.cmo tmp/calc.cmo


