
# Item 3 ペアとタプル

## ペアとタプル

ペアの型(a, b)はaとbの直積型である。
タプルの型(a1, a2, ... , an)はn個の直積の型である。

## fstとsnd

ペアには1つ目の要素を返す関数fstと2つ目の要素を返す関数sndが定義されている。

```
Prelude> :t fst
fst :: (a, b) -> a
Prelude> fst (10, 3.14)
10
Prelude> :t snd
snd :: (a, b) -> b
Prelude> snd (10, "abc")
"abc"
```

ペアでないタプルに対してfstやsndを作用させるとエラーになる。
```
Prelude> fst (10, 3.14, "abc")

<interactive>:41:5:
    Couldn't match expected type ‘(a, b0)’
                with actual type ‘(Integer, Double, [Char])’
    Relevant bindings include it :: a (bound at <interactive>:41:1)
    In the first argument of ‘fst’, namely ‘(10, 3.14, "abc")’
    In the expression: fst (10, 3.14, "abc")
    In an equation for ‘it’: it = fst (10, 3.14, "abc")
```

## zipとunzip

リストからペアのリストを生成する関数zipが定義されている。
リストの長さは短いほうに合わせられる。
無限リストに作用させることもできる（遅延評価される）。

```
Prelude> :t zip
zip :: [a] -> [b] -> [(a, b)]
Prelude> zip [1,2,3] "abc"
[(1,'a'),(2,'b'),(3,'c')]
Prelude> zip [1,2] "abc"
[(1,'a'),(2,'b')]
Prelude> zip [1,2,3] "ab"
[(1,'a'),(2,'b')]
Prelude> zip [1,2..] "abcde"
[(1,'a'),(2,'b'),(3,'c'),(4,'d'),(5,'e')]
```

ペアのリストからリストのペアを生成する関数unzipも定義されている。
```
Prelude> :t unzip
unzip :: [(a, b)] -> ([a], [b])
Prelude> unzip [(3,2),(1,7),(4,1)]
([3,1,4],[2,7,1])
```

| OCaml        | Haskell  |
|:-------------|----------|
| List.combine | zip      |
| List.split   | unzip    |

