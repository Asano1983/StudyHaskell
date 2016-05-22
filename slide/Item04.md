
# Item 4 制御構造

## パターンマッチ

分岐はパターンマッチで、ループは再帰を使って実現できる。
パターンマッチは命令型プログラミングのswitch文に似ているが、表現力はより高い。

```
Prelude> :{
Prelude| let factorial :: Int -> Int
Prelude|     factorial 0 = 1
Prelude|     factorial n = n * factorial (n - 1)
Prelude| :}
Prelude> factorial 0
1
Prelude> factorial 5
120
```

パターンが網羅的でないとき、予期していない値を入力すると例外が投げられる。
関数定義時には警告されないことに注意しよう（OCamlは警告してくれる）。

```
Prelude> :{
Prelude| let charName :: Char -> String
Prelude|     charName 'a' = "Alice"
Prelude|     charName 'b' = "Bob"
Prelude|     charName 'c' = "Carol"
Prelude| :}
Prelude> charName 'a'
"Alice"
Prelude> charName 'b'
"Bob"
Prelude> charName 'h'
"*** Exception: <interactive>:(44,5)-(46,26): Non-exhaustive patterns in function charName
```

全てにマッチするパターンを最後に入れておくと安全である。

```
Prelude> :{
Prelude| let charName :: Char -> String
Prelude|     charName 'a' = "Alice"
Prelude|     charName 'b' = "Bob"
Prelude|     charName 'c' = "Carol"
Prelude|     charName x   = "No Name"
Prelude| :}
Prelude> charName 'a'
"Alice"
Prelude> charName 'b'
"Bob"
Prelude> charName 'h'
"No Name"
```

パターンマッチはタプルに対しても使える。
次の関数addVectorsはパターンマッチを使って定義できる。
fstやsndを使う必要がないので簡潔である。

```
Prelude> :{
Prelude| let addVectors :: (Double, Double) -> (Double, Double) -> (Double,Double)
Prelude|     addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)
Prelude| :}
Prelude> addVectors (2,3) (5,8)
(7.0,11.0)
```

ワイルドカード_を使うこともできる。
トリプルから1つ目の要素を返す関数firstを次のように定義できる。

```
Prelude> :{
Prelude| let first :: (a, b, c) -> a
Prelude|     first (x, _, _) = x
Prelude| :}
Prelude> first (10, 3.14, 'a')
10
```

パターンマッチはリスト内法表記においても有用である。

```
Prelude> let xs = [(1,3),(4,3),(2,4),(5,3),(5,6),(3,1)]
Prelude> [a+b | (a, b) <- xs]
[4,7,6,8,11,4]
Prelude> [x*100+3 | (x,3) <- xs]
[103,403,503]
```

リストの1つ目の要素を返す関数head'をパターンマッチを使って実装してみる。

```
Prelude> :{
Prelude| let head' :: [a] -> a
Prelude|     head' [] = error "Can't call head on an empty list, dummy!"
Prelude|     head' (x:_) = x
Prelude| :}
Prelude> head' [1,2,3,4,5]
1
Prelude> head' []
*** Exception: Can't call head on an empty list, dummy!
```

## ガード節

範囲など条件で分岐するときはガード節が有用である。

```
Prelude> :{
Prelude| let factorial' :: Int -> Int
Prelude|     factorial' n
Prelude|       | n < 0     = error "out of range"
Prelude|       | n == 0    = 1
Prelude|       | otherwise = n * factorial' (n - 1)
Prelude| :}
Prelude> factorial' 0
1
Prelude> factorial' 5
120
Prelude> factorial' (-1)
*** Exception: out of range
```

## where節とlet式

where節やlet式を使うと、局所変数を定義することができる。
let式は式なので、どこにでも書ける。
where節は関数定義内にしか書けない。

```
Prelude> let x = 10 in x ^ 2
100
Prelude> let func x = a ^ 2 where a = x + 1
Prelude> func 10
121
```

パターンマッチにおいて用いることも有用である。

```
Prelude> :{
Prelude| let bmiTell :: Double -> Double -> String
Prelude|     bmiTell weight height
Prelude|       | bmi <= 18.5 = "You're underweight"
Prelude|       | bmi <= 25.0 = "You're normal"
Prelude|       | bmi <= 30.0 = "You're fat"
Prelude|       | otherwise   = "You're a whale"
Prelude|       where bmi = weight / height ^ 2
Prelude| :}
Prelude> bmiTell 85 1.90
"You're normal"
Prelude> bmiTell 60 1.90
"You're underweight"
Prelude> bmiTell 200 1.90
"You're a whale"
```

## 再帰

命令型プログラミングにおけるループで実現できることは、常に再帰で実現できる。

```
Prelude> :{
Prelude| let maximum' :: (Ord a) => [a] -> a
Prelude|     maximum' [] = error "maximum of empty list!"
Prelude|     maximum' [x] = x
Prelude|     maximum' (x:xs) = max x (maximum' xs)
Prelude| :}
Prelude> maximum' [3,1,4,1,5,9,2]
9
Prelude> maximum' [1,2,3,4,5]
5
```

関数quicksortも簡潔に定義できる。

```
Prelude> :{
Prelude| let quicksort :: (Ord a) => [a] ->[a]
Prelude|     quicksort [] = []
Prelude|     quicksort (x:xs) =
Prelude|         let smallerOrEqual = [a | a <- xs, a <= x]
Prelude|             larger = [a | a <- xs, a > x]
Prelude|         in  quicksort smallerOrEqual ++ [x] ++ quicksort larger
Prelude| :}
Prelude> quicksort [3,1,4,1,5,9,2]
[1,1,2,3,4,5,9]
```

型クラスOrdは順序をつけられる型の集合である。

## 再帰と末尾再帰

末尾再帰で記述すると、ループとしてコンパイルされる。
数値を返す関数は末尾再帰を用いた方がよいことが多い。
遅延データ（リストなど）を返す関数は（末尾再帰でない）普通の再帰を用いた方がよいことが多い。

例えば、平坦化されたリストを返すconcatは（末尾再帰でない）普通の再帰によって定義されている。

```
concat :: [[a]] -> [a]
concat []       = []
concat (xs:xss) = (++) xs (concat xss)
```

 