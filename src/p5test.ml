value rec left_assoc op elem =
  let rec op_elem x =
    parser
    [ [: t = op; y = elem; r = op_elem (t x y) :] -> r
    | [: :] -> x ]
  in
  parser [: x = elem; r = op_elem x :] -> r
;

value rec right_assoc op elem =
  let rec op_elem x =
    parser
    [ [: t = op; y = elem; r = op_elem y :] -> t x r
    | [: :] -> x ]
  in
  parser [: x = elem; r = op_elem x :] -> r
;

value expr =
  List.fold_right (fun op elem -> op elem)
    [left_assoc (parser [: `'+' :] -> fun x y -> x +. y);
     left_assoc (parser [: `'*' :] -> fun x y -> x *. y);
     right_assoc (parser [: `'^' :] -> fun x y -> x ** y)]
    (parser [: `('0'..'9' as c) :] -> float (Char.code c - Char.code '0'))
;