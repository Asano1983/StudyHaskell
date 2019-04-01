
# Item 11 IO（作成中）

## IOの定義

IOは型aを引数に取って、型IO aを戻す型コンストラクタである。
関数の戻り値の型がIO aであることは、その関数が入出力を行っている可能性があることを意味している。

```
Prelude> :i IO
newtype IO a
  = GHC.Types.IO (GHC.Prim.State# GHC.Prim.RealWorld
                  -> (# GHC.Prim.State# GHC.Prim.RealWorld, a #))
```

クライアントから隠蔽するために複雑な型名になっているが、
簡単に書けば、RealWorld -> (RealWorld, a)型のことである。
計算前の世界を引数に取って「計算後の世界（RealWorld型）と計算結果（a型）」を返す関数の型である。

## ファイル入出力

ファイル入出力の関数writeFileとreadFileにIOの定義を当てはめると次のようになる。

文字列をファイルに出力する関数writeFileの型はFilePath -> String -> IO ()である。
ファイルパスと文字列を引数に取って、「世界に対して、書き込み後の世界を返す関数」を返す。
この場合、世界をファイルの状態と思ってもよい。
関数writeFileはファイルに対して文字列を上書き保存する（追記はappendFileで出来る）。

```
Prelude> :t writeFile
writeFile :: FilePath -> String -> IO ()
```

文字列をファイルから取得する関数readFileの型はFilePath -> IO Stringである。
ファイルパスとを引数に取って、「計算前の世界に対して「計算後の世界とString型の計算結果」を返す関数」を返す。
この場合、世界をファイルの状態と思ってもよく、readFileはファイルの状態を変えないので、世界については恒等的である。

```
Prelude> :t readFile
readFile :: FilePath -> IO String
```

## 関数fmap

型IO aは型クラスFunctorに属しており、fmapを使うことができる。

```
*Main> let x = readFile "Item10-input.txt"
*Main> :t x
x :: IO String
*Main> fmap ("Hello " ++ ) x
"Hello Taro"
```

ここで("Hello " ++)はString -> String型の関数であり、
ここでのfmapはこの関数とIO String型のxを引数に取って、IO String型の値を戻す高階関数である。

型IO aにおける`fmap :: (a -> b) -> IO a -> IO b`は次のように定義されている。

```
instance Functor IO where
    fmap f m = \s -> let (t, x) = m s in (t, f x)
```

日本語で書くと次のようになる。
fmapは(a -> b)型の関数fとIO a型の値mを引数に取る高階関数である。
IO a型はRealWorld -> (RealWorld, a)型のことであった。
fmapはIO b型の値、つまりRealWorld -> (RealWorld, b)型の関数を戻す。
この戻される関数は
「sに対してm s :: (RealWorld, a)の1つ目の要素をt、2つ目の要素をxとして、タプル(t, f x)を戻す関数」である

```
fmap :: (a -> b) -> IO a -> IO b
fmap f m = \s -> (fst (m s), f snd (m s))
```

のように書いた方がパターンマッチに慣れていない人にはわかりやすいかもしれない。
元々、mは\s -> (fst (m s), snd (m s))なのだから、
fmap f mは1つ目の要素についてはmと同様に戻し、2つ目の要素についてのみfを作用させた値を戻す関数である。

IO a型において、fmapはtrivialである。
文脈側には何もせず、中身に対して作用させるだけのことである。

## 関数(>>=)

型IO aは型クラスMonadに属しており、(>>=)を使うことができる。
型IO aにおいては、(>>=)の方が非自明であり、fmapよりも本質的な役割を果たす（Maybeにおいては(>>=)よりもfmapが本質的であった）。

型IO aにおける`(>>=) :: IO a -> (a -> IO b) -> IO b`は次のように定義されていると思ってよい。

```
instance Monad IO where
m >>= f = \s -> let (t x) = m s 
                    (u y) = (f x) t
                    in (u y)
```

日本語で書くと次のようになる。
(>>=)はIO a型の値mと(a -> IO b)型の関数fを引数に取る高階関数である。
(>>=)はIO b型の値、つまりRealWorld -> (RealWorld, b)型の関数を戻す。
この戻される関数は
「sに対してm sの1つ目の要素をt::RealWorld、2つ目の要素をx::aとする。
f x::IO bはRealWorld -> (RealWorld, b)型の関数であるから、(f x) sは(RealWorld, b)型となる。
このタプル(u y)を戻す関数」である

```
(>>=) :: IO a -> (a -> IO b) -> IO b
m >>= f = \s -> (f snd (m s)) fst (m s)
```

のように書いた方がパターンマッチに慣れていない人にはわかりやすいかもしれない。
世界の側だけを見ると、引数に世界sを取って、世界sに対してmを作用した世界をtとし、世界tに対してf xを作用した世界をuとしているので、逐次的である。

```haskell:Item10-02.hs
main = 
  (readFile "Item10-input.txt") >>= \name -> writeFile "Item10-output.txt" ("Hello " ++ name)
```

これの意味は次のようになる。
(readFile "Item10-input.txt")は世界sを取って、世界tと"Taro"という文字列を返す関数である。
この文字列に`\name -> writeFile "Item10-output.txt" ("Hello " ++ name)`を作用させると、
`writeFile "Item10-output.txt" ("Hello Taro") :: IO()`となり、これをtに作用させ、ファイルを書き込んだ後の世界uを戻す。
つまり、文字列としてはreadFileの中身を取り出して変数nameに束縛して利用し、世界（文脈）としては逐次的に実行している
（この例の場合、readFileはファイルの状態を変えないので、世界sと世界tは同じ状態であるが）。

この関数(>>=)を用意することによって、入出力を行う関数を自由に合成することができる。

## 関数(>>)

型クラスMonadのインスタンスである型には自動的に関数(>>)が

```
(>>) :: Monad m => m a -> m b -> m b
m >> k = m >>= \_ -> k
```

によって定義されるのであった。
IOに限定すると次のようになる。

```
(>>) :: IO a -> IO b -> IO b
m >>= f = \s -> let (t _) = m s 
                    (u y) = k t
                    in (u y)
```

命令型言語における逐次的実行に相当することがわかるだろう。

```
*Main> let x = appendFile "Item10-output2.txt" "Hello, "
*Main> let y = appendFile "Item10-output2.txt" "World!"
*Main> x >> y
*Main> readFile "Item10-output2.txt"
"Hello, World!"
```

## 関数join

型クラスMonadに属する型については関数joinを考えることもできる。

```
*Main> let join m = m >>= id
*Main> :t join
join :: Monad m => m (m b) -> m b
```

IOにおける関数joinは次のようになる。

```
join m = \s -> let (t x) = m s 
                    (u y) = x t
                    in (u y)
```

世界sに対してm :: IO (IO a)を作用させて世界tと戻り値x :: IO aが得られる。
このtに対してxを作用させ、世界uと戻り値yを得る。
join mは世界sに対してこのようなタプルを戻す関数である。

