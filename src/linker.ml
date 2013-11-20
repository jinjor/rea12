open File_util

let p = Console.print "Linker"

let sample = [
  Tsort.Node ("a", [ "b"; "c" ]);
  Tsort.Node ("c", [ "b" ]);
  Tsort.Node ("b", [])
]

let exec all_in_one sorted_file_names = ()

let exec () =
  p "*** linker start ! ***";
  let sorted = Tsort.exec sample in
  List.iter p sorted;
  p "*** linker end ! ***"
