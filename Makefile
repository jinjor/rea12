
.SUFFIXES : .ml .mli .cmo .cmi .cmx .mll .mly

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

	ocamlc -c -I tmp -w -26 -warn-error P -o tmp/tsort src/tsort.ml
	ocamlc -c -I tmp -w -26 -warn-error P -o tmp/file_util src/file_util.ml
	ocamlc -c -I tmp -w -26 -warn-error P -o tmp/console src/console.ml
	ocamlc -c -I tmp -w -26 -warn-error P -o tmp/compiler src/compiler.ml
	ocamlc -c -I tmp -w -26 -warn-error P -o tmp/linker src/linker.ml
	ocamlc -c -I tmp -w -26 -warn-error P -o tmp/build src/build.ml

	#ocamlc -o bin/compiler tmp/lexer.cmo tmp/parser.cmo tmp/compiler.cmo
	ocamlc -o bin/build tmp/tsort.cmo tmp/file_util.cmo tmp/console.cmo tmp/lexer.cmo tmp/parser.cmo tmp/compiler.cmo tmp/linker.cmo tmp/build.cmo

	ocamlc -pp "camlp5r pa_lexer.cmo" -o tmp/p5lextest src/p5lextest.ml
	ocamlc -pp "camlp5r pa_rp.cmo" -o tmp/p5test src/p5test.ml
	ocamlc -o bin/p5test tmp/p5test.cmo


clean:
	rm tmp/*
