main =
  (readFile "input.txt") >>= \name -> writeFile "output.txt" ("Hello " ++ name)
