let p = parser [< '3; '1; '4 >] -> print_string "hogera\n";"hey" in
p [< '3; '1; '4; '1; '5 >]