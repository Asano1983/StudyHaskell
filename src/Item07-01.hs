main = do
  name <- readFile "input.txt"
  writeFile "output.txt" ("Hello " ++ name)
