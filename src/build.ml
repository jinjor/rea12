open File_util

let p = Console.print "Renkon"
let print_help () =
  p "usage";
  p "renkon [main]"

let _ =
  p "*** build start ! ***";
  try
    let main = Sys.argv.(1) in
    let dir = Sys.getcwd() in
    let input_file_name = dir ^ "/" ^ main ^ ".alt" in
    let output_file_name = dir ^ "/" ^ main ^ ".js" in
    Compiler.exec input_file_name output_file_name;
    Linker.exec ();
  with
  | Invalid_argument _ -> print_help ()
  | _ -> p "Error!";
  p "*** build end ! ***"


