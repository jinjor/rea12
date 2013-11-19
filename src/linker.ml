open FileUtil

let p = Console.print "Linker"

let sample = [
  Tsort.Node ("a", [ "b"; "c" ]);
  Tsort.Node ("b", [ "c" ]);
  Tsort.Node ("c", [])
]

let exec () =
  p "*** linker start ! ***";
  let sorted = Tsort.exec sample in
  List.iter p sorted;
  p "*** linker end ! ***"
