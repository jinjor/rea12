
.SUFFIXES : .ml .mli .cmo .cmi .cmx .mll .mly

all2: bin/calc bin/p5test

bin/calc: tmp/lexer.cmo tmp/parser.cmo tmp/calc.cmo
	ocamlc -o bin/calc tmp/lexer.cmo tmp/parser.cmo tmp/calc.cmo
tmp/calc.cmo: src/calc.ml
	ocamlc -c -I tmp -w -26 -warn-error P -o tmp/calc src/calc.ml

tmp/parser.cmi: tmp/parser.mli
	ocamlc -c -I tmp -w -26 tmp/parser.mli
tmp/lexer.cmo: tmp/lexer.ml tmp/parser.cmo
	ocamlc -c -I tmp -w -26 tmp/lexer.ml
tmp/parser.cmo: tmp/parser.ml
	ocamlc -c -I tmp -w -26 tmp/parser.ml

tmp/lexer.ml: src/lexer.mll
	ocamllex -o tmp/lexer.ml src/lexer.mll
tmp/parser.ml: src/parser.mly
	ocamlyacc -b tmp/parser src/parser.mly
tmp/ast.cmi: src/ast.ml
	ocamlc -c -o tmp/ast src/ast.ml


bin/p5test: tmp/p5test.cmo
	ocamlc -o bin/p5test tmp/p5test.cmo

tmp/p5test.cmo: src/p5test.ml
	ocamlc -pp "camlp5o pr_o.cmo" -I +camlp5 -c -o tmp/p5test src/p5test.ml


all:
	mkdir -p tmp
	mkdir -p bin

	#export OCAMLRUNPARAM='p'

	ocamllex -o tmp/lexer.ml src/lexer.mll       # generates lexer.ml
	ocamlyacc -b tmp/parser src/parser.mly     # generates parser.ml and parser.mli
	ocamlc -c -o tmp/ast src/ast.ml
	#ocamlc -c -o tmp/ast src/err.ml
	ocamlc -c -I tmp -w -26 tmp/parser.mli
	ocamlc -c -I tmp -w -26 tmp/lexer.ml
	ocamlc -c -I tmp -w -26 tmp/parser.ml

	ocamlc -c -I tmp -w -26 -warn-error P -o tmp/calc src/calc.ml
	ocamlc -o bin/calc tmp/lexer.cmo tmp/parser.cmo tmp/calc.cmo

	ocamlc -pp "camlp5o pr_o.cmo" -I +camlp5 -c -o tmp/p5test src/p5test.ml
	ocamlc -o bin/p5test tmp/p5test.cmo


clean:
	rm tmp/*
