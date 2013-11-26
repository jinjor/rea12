open File_util

let p = Console.print "Linker"

let sample = [
  Tsort.Node ("a", [ "b"; "c" ]);
  Tsort.Node ("c", [ "b" ]);
  Tsort.Node ("b", [])
]

let all_in_one out_file_name in_file_names =
  loan_out out_file_name (fun out ->
    let write_each = fun name ->
      let text = load_file name in
      p ("writing " ^ name);
      output_string out text
    in
    List.iter write_each in_file_names
  )

let exec () =
  p "*** linker start ! ***";
  let sorted = Tsort.exec sample in
  List.iter p sorted;
  let dir = Sys.getcwd () in
  let out_file_name = dir ^ "/sample/all.js" in
  let in_names = [dir ^ "/bin/predef.js"; dir ^ "/sample/sample1.js"] in
  all_in_one out_file_name in_names;
  p "*** linker end ! ***"
