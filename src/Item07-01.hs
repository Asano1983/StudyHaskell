main = do
  name <- readFile "Item10-input.txt"
  writeFile "Item10-output1.txt" ("Hello " ++ name)
