main =
  (readFile "Item10-input.txt") >>= \name -> writeFile "Item10-output1.txt" ("Hello " ++ name)
