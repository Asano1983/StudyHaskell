
# Item 8 Maybe

## Maybeの定義

リストの型を生成する[]は組み込みの型コンストラクタであった。
[]は型aを引数に取って、型[a]を戻す。

```
Prelude> :i []
data [] a = [] | a : [a]
Prelude> :k []
[] :: * -> *
```

Maybeも同様に型aを引数に取って、型Maybe aを戻す型コンストラクタである。

```
Prelude> :i Maybe
data Maybe a = Nothing | Just a
Prelude> :k Maybe
Maybe :: * -> *
```

型Maybe aは型aにNothingを付け加えた型（直和型）であり、
Just :: a -> Maybe aによってaはMaybe aに埋め込まれている。
関数の戻り値の型がMaybe aであることは、その関数が失敗する可能性があることを意味している。

```
Prelude> :{
Prelude| let div2 :: Int -> Maybe Int
Prelude|     div2 x = if even x then Just (x `div` 2)
Prelude|                        else Nothing
Prelude| :}
Prelude> div2 10
Just 5
Prelude> div2 13
Nothing
```

この関数div2は命令型言語における「例外を投げるかもしれない関数」に似ている。
Haskellは参照透過な関数のみを取り扱うが、このような形で例外という命令型言語の機能を実現することができる。

## 型クラスFunctorと関数fmap

次のコードはエラーになる。
div2 10の型はMaybe Intであり、1の型はIntであるからである。

```
Prelude> div2 10 + 1

<interactive>:57:9:
    No instance for (Num (Maybe Int)) arising from a use of ‘+’
    In the expression: div2 10 + 1
    In an equation for ‘it’: it = div2 10 + 1
```

関数fmapを用いると、(+ 1) :: Int -> Int をMaybe Int -> Maybe Int に自然に拡張することができる。

```
Prelude> :t fmap
fmap :: Functor f => (a -> b) -> f a -> f b
Prelude> :t fmap (+ 1)
fmap (+ 1) :: (Functor f, Num b) => f b -> f b
Prelude> fmap (+ 1) (div2 10)
Just 6
Prelude> fmap (+ 1) (div2 13)
Nothing
```

型クラスFunctorは上述の関数fmapがうまく定義されているような高階の型クラスである（カインドが* -> *）。
Maybeは型クラスFunctorのインスタンスであり、Maybeにおける関数fmapは

```
instance Functor Maybe where
    fmap f (Just x) = Just (f x)
    fmap f Nothing  = Nothing
```

のように定義されている。

## 型クラスMonadと関数(>>=)

fmapは便利であるが、fmapだけでは不十分なことがある。
例えば、16に対して関数div2を2回作用させたいとする。
このとき、fmap div2の型はMaybe Int -> Maybe (Maybe Int)のようになってしまい、
戻り値はJust (Just 4)になってしまう。

```
Prelude> :t fmap div2
fmap div2 :: Functor f => f Int -> f (Maybe Int)
Prelude> (fmap div2) (div2 16)
Just (Just 4)
Prelude> (fmap div2) (div2 14)
Just Nothing
Prelude> (fmap div2) (div2 13)
Nothing
```

これは不便である。
16に対して関数div2を2回作用したときはJust 4が戻ってきて欲しいはずである。

関数(>>=)を用いると、div2 :: Int -> Maybe IntをMaybe Int -> Maybe Intのように使うことができる。
(>>=)はbind演算子ともいう。

```
Prelude> :t (>>=)
(>>=) :: Monad m => m a -> (a -> m b) -> m b
Prelude> Just 16 >>= div2
Just 8
Prelude> Just 16 >>= div2 >>= div2
Just 4
Prelude> Just 16 >>= div2 >>= div2 >>= div2
Just 2
```

型クラスMonadは上述の関数(>>=)などがうまく定義されているような高階の型クラスである（カインドが* -> *）。
Maybeは型クラスMonadのインスタンスでもあり、Maybeにおける関数(>>=)は

```
instance Monad Maybe where
    Nothing >>= f = Nothing
    Just x >>= f  = f x
```

のように定義されている。

このように関数(>>=)を使うことによって、
div2のような「失敗するかもしれない関数」を複数回合成することができる。

## 関数(>>)

型クラスMonadのインスタンスである型には自動的に関数(>>)が

```
m >> k = m >>= \_ -> k
```

によって定義される（恒等的にkを返すa -> m b型の関数を(>>=)の第2引数に与える）。
関数(>>)はthenと呼ばれることもあり、型は以下のとおりである。

```
Prelude> :t (>>)
(>>) :: Monad m => m a -> m b -> m b
```

Maybe Int型においては次のように動く。

```
Prelude> Just 10 >> Just 20
Just 20
Prelude> Nothing >> Just 20
Nothing
Prelude> Just 10 >> Nothing
Nothing
Prelude> Nothing >> Nothing
Nothing
```

命令型言語において逐次実行したときの結果を返すことに似ている。
上の例においては、m >> kは計算が成功しているときはkの値を返すのであるが、mの計算が失敗したときはNothingを返す。
この関数(>>)は次項でのdo記法と深い関わりを持つ。

## 関数join

理論的に取り扱うとき、関数(>>=)よりも関数joinを考えた方が理解がしやすいことがある。

```
join :: Maybe (Maybe a) -> Maybe a
join Nothing = Nothing
join Just x  = x
```

この関数joinを用いると、関数(>>=)は

```
x >>= f = join (fmap f x)
```

と書ける。
つまり、関数(>>=)が行っていることは、
fmapすることでMaybe (Maybe a)のようになってしまった戻り値を
joinによってMaybe aに潰していると考えられる。

逆に(>>=)によってjoinを表すことも可能である。

```
join x = x >>= id
```

このため、(>>=)を定義することと、joinを定義することは同じことである。
コードを書く上では(>>=)の方が便利であるが、
理論的理解の上ではjoinの方が単純で分かりやすいことが多々ある。

