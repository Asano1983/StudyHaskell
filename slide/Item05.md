
# Item 5 高階関数

## mapとfilter

mapとfilterは最も基本的な高階関数である。
mapはリストの各要素に関数を作用させた結果のリストを生成する高階関数、
filterは条件に満たす要素からなるリストを生成する高階関数である。

```
Prelude> :t map
map :: (a -> b) -> [a] -> [b]
Prelude> map (+3) [1,5,3,1,6]
[4,8,6,4,9]
Prelude> :t filter
filter :: (a -> Bool) -> [a] -> [a]
Prelude> filter (>3) [1,5,3,2,1,6,4,3,2,1]
[5,6,4]
```

| C++            | OCaml       | Haskell  |
|:---------------|-------------|----------|
| std::transform | List.map    | map      |
| std::copy_if   | List.filter | filter   |

## zipWith

zipを汎用化した高階関数zipWithも基本的で有用である。

```
Prelude> :t zipWith
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
Prelude> zipWith (+) [3,1,4] [2,7,1]
[5,8,5]
```

| OCaml        | Haskell  |
|:-------------|----------|
| List.combine | zip      |
| List.split   | unzip    |
| List.map2    | zipwith  |

## 畳み込み

Haskellには左畳み込みの高階関数foldlと右畳み込みの高階関数foldrが用意されている。

| C++             | Python | JavaScript | OCaml           | Haskell |
|:----------------|--------|------------|-----------------|---------|
| std::accumulate | reduce | inject     | List.fold_left  | foldl   |
|                 |        |            | List.fold_right | foldr   |

```
Prelude> :t foldl
foldl :: Foldable t => (b -> a -> b) -> b -> t a -> b
Prelude> :t foldr
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
```

型クラスFoldableは高階の型クラスである（Foldableのカインドは* -> *である）。
リストやツリーは型クラスFoldableに属する。
とりあえずはリストのみを考えるので、

```
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f z []     = z
foldl f z (x:xs) = foldl f (f z x) xs
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z []     = z
fordr f z (x:xs) = f x (foldr f z xs)
```

と考えよう。
foldlは末尾再帰であるが、foldrは末尾再帰ではない。

左畳み込みfoldlを用いて、sumlを定義することができる。

```
Prelude> :{
Prelude| let suml :: (Num a) => [a] -> a
Prelude|     suml = foldl (+) 0
Prelude| :}
Prelude> suml [1,5,3,2,1]
12
```

この関数は次のように評価され、左畳み込みが実現している。
suml [1,5,3,2,1]
 → foldl (+) 0 [1,5,3,2,1]
 → foldl (+) 0 (1:[5,3,2,1])
 → foldl (+) (0 + 1) [5,3,2,1]
 → foldl (+) ((0 + 1) + 5) [3,2,1]
 → foldl (+) (((0 + 1) + 5) + 3) [2,1]
 → foldl (+) ((((0 + 1) + 5) + 3) + 2) [1]
 → foldl (+) (((((0 + 1) + 5) + 3) + 2) + 1) []
 → (((((0 + 1) + 5) + 3) + 2) + 1)
 → (((6 + 3) + 2) + 1)
 → ((9 + 2) + 1)
 → (11 + 1)
 → 12

右畳み込みfoldrでsumrを定義すると、
sumr [1,5,3,2,1]
 → foldr (+) 0 [1,5,3,2,1]
 → foldr (+) 0 (1:[5,3,2,1])
 → (+) 1 (foldr (+) 0 [5,3,2,1])
 → (+) 1 ( (+) 5 (foldr (+) 0 [3,2,1]))
 → (+) 1 ( (+) 5 ( (+) 3 (foldr (+) 0 [2,1])))
 → (+) 1 ( (+) 5 ( (+) 3 ( (+) 2 (foldr (+) 0 [1]))))
 → (+) 1 ( (+) 5 ( (+) 3 ( (+) 2 ( (+) 1 (foldr (+) 0 [])))))
 → (+) 1 ( (+) 5 ( (+) 3 ( (+) 2 ( (+) 1 0))))
 → (+) 1 ( (+) 5 ( (+) 3 ( (+) 2 1)))
 → (+) 1 ( (+) 5 ( (+) 3 3))
 → (+) 1 ( (+) 5 6)
 → (+) 1 11
 → 12
のように評価される。
加法は右から実行されるが、リストの走査自体は左から行われていることに注意しよう。

右畳み込みfoldrは無限リストを評価することができる。
例えば、右畳み込みで定義されたandrを無限リストrepeat Falseに作用させるとFalseを返す。

```
Prelude> :{
Prelude| let andr:: [Bool] -> Bool
Prelude|     andr xs = foldr (&&) True xs
Prelude| :}
Prelude> andr (repeat False)
False
```

andr (repeat False)
 → foldr (&&) True (repeat False)
 → foldr (&&) True (False: repeat False))
 → (&&) False (foldr (&&) True (repeat False))
 → False
となる。

しかし、左畳み込みで定義されたandlを無限リストrepeat Falseに作用させると無限ループに陥る。

```
Prelude> :{
Prelude| let andl:: [Bool] -> Bool
Prelude|     andl xs = foldl (&&) True xs
Prelude| :}
Prelude> andl (repeat False)
```

と定義すると、
andl (repeat False)
 → foldl (&&) True (repeat False)
 → foldl (&&) True (False: (repeat False))
 → foldl (&&) ( (&&) True False ) (repeat False)
 → foldl (&&) False (False: repeat False)
 → foldl (&&) False (False: repeat False)
 → foldl (&&) ( (&&) False False ) (repeat False)
となり、評価（簡約）が終わらない。

一般に値を返す関数はfoldlを用いたほうが良いことが多いのだが、
引数に取る関数（この例では(&&)のこと）が非正格で、
短絡評価（Falseを見つけた時点で走査終了）を行いたい場合はfoldrを用いることになる。
foldlはリストの全要素を走査してしまうことに注意しよう（foldrより正格性が強い）。

補足：repeatは

```
repeat :: a -> [a]
repeat x = xs where xs = x:xs
```

で定義されている。

# 再帰、畳み込み、mapとfilter

再帰、畳み込み、mapとfilterの順に表現力が高い。
mapとfilterで表現できるものは再帰を使わずにmapとfilterで書いた方が可読性が高い。

# foldl'

Data.Listモジュールには正格版の左畳み込みfoldl'が定義されている。
ほとんどの場合、foldlよりfoldl'を使った方が効率が良い。

```
foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' f a []     = a
foldl' f a (x:xs) = let a' = f a x in a' `seq` foldl' f a' xs
```

このfoldl'を用いると、
 → foldl' (+) 0 [1,5,3,2,1]
 → foldl' (+) 0 (1:[5,3,2,1])
 → foldl' (+) 1 [5,3,2,1]
 → foldl' (+) 6 [3,2,1]
 → foldl' (+) 9 [2,1]
 → foldl' (+) 11 [1]
 → foldl' (+) 12 []
 → 12
のように正格に左畳み込みを行うことができる。

引数に取る関数fが正格関数のときはfoldl'の方がfoldlよりも効率が良い。
fが非正格関数であり、短絡評価を必要とするときはfoldrを使うことになるため、
非正格のfoldlを使うべき局面はあまりない。
foldlはリストの全要素を走査してしまうため、遅延性が中途半端であり、実用性には乏しい（学習上は定義がわかりやすいが）。

