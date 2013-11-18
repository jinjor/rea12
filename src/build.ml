open FileUtil



let _ =
  print_string ("*** build start ! ***\n");
  let dir = Sys.getcwd() in
  let source_name = "sample1" in
  let input_file_name = dir ^ "/sample/" ^ source_name ^ ".alt" in
  let output_file_name = dir ^ "/sample/" ^ source_name ^ ".js" in
  Compiler.exec input_file_name output_file_name;
  Linker.exec ();
  print_string ("*** build end ! ***\n")


