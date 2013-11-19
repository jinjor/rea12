type 'a node = Node of 'a * ('a list)

exception Node_not_found of string

let not_visited visited name =
  try
    let _ = List.find (fun s -> s = name) visited in
    false
  with
  | Not_found -> true

let rec visit (Node (a, parents)) visited l get_node =
  if not_visited visited a then
    let visited_ = a :: visited in
    let visit_each_parent = fun (visited, l) -> fun parent ->
      match get_node parent with
      | Some n -> visit n visited l get_node
      | None -> raise (Node_not_found parent)
    in
    let (visited__, l_) = List.fold_left visit_each_parent (visited_, l) parents in
    (visited__, (a :: l_))
  else (visited, l)

let exec (all : (_ node) list) =
  let get_node = fun name ->
    try
      let found = List.find (fun (Node (_name, _)) -> name = _name) all in
      Some found
    with
    | Not_found -> None
  in
  let visit_each = (fun (visited, l) -> fun n -> visit n visited l get_node) in
  let (visited, l) = List.fold_left visit_each ([], []) all in
  l
