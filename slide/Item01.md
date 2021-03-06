
# Item 1 型と多相性

## Haskellの特徴

Haskellは純粋関数型の静的型付け言語である。
純粋関数型とはすべての関数が参照透過で、副作用を持たないことである。
Haskellには式は存在するが、（命令的な）文は存在しない。
また、遅延評価をデフォルトとする（F#やOCamlは正格評価をデフォルトとする）。

|            | 命令型                   | 非純粋関数型   | 純粋関数型 |
|:-----------|--------------------------|----------------|------------|
| 静的型付け | C, C++, Java, C#         | F#, OCaml (ML) | Haskell    |
| 動的型付け | Python, Ruby, JavaScript | Lisp           | ×         |

## 多相性

Haskellでは型変数によるパラメータ多相のほかに、型クラスのオーバーロードによるアドホック多相を実現している。
Haskellに継承と仮想関数による多相（部分型多相）はない。
また、型の違う関数に共通の名前を付けることはできない。

|                      |      | C++                 | OCaml        | Haskell  |
|:---------------------|------|---------------------|--------------|----------|
| パラメータ多相       | 静的 | 関数テンプレート    | 型変数       | 型変数   |
| アドホック多相       | 静的 | オーバーロード      | ×           | 型クラス |
| 名前的部分型多相     | 動的 | 継承と仮想関数      | ×           | ×       |
| 構造的部分型多相     | 動的 | 型消去              | 構造的部分型 | ×       |

## 型変数

リストの先頭の要素を返す関数headは型[a] -> aの多相的関数である。
より丁寧にforall a. [a] -> aと書くこともできる。
このaのように様々な型を表すための変数を型変数という。
型変数によってパラメータ多相を実現することができる。
C++の関数テンプレートのテンプレート引数に似ている。
Haskellでは具体的な型の名前を大文字で始め、型変数の名前は小文字で始める。

```
Prelude> :t head
head :: [a] -> a
```

ペアから1つ目の要素を取り出す関数fstは型(a,b) -> aの多相的関数である。
forall a b. (a,b) -> aと書くこともできる。

```
Prelude> :t fst
fst :: (a, b) -> a
```

## 型クラス

三角関数sinは型Floating a => a -> aの多相的関数である。
型クラスFloatingは浮動小数点で表現される型の集合であり、FloatやDoubleを含む。
sinは型クラスFloatingに属する型に対してのみ定義される。

```
Prelude> :t sin
sin :: Floating a => a -> a
```

型クラスはC++の抽象基底クラスに似ていなくもないが、型クラスは（型の集合であって）型ではないことに注意しよう。
C++のコンセプトに似ている。

## 型推論

Haskellでは副作用を認めず、全ての状態を関数の入出力で表現する。
高階関数によって「多相的」な振る舞いを実現することも多いので、型が複雑になりがちであり、
型を明示的に記述することはコードの生産性に影響する。

Haskellの型推論は強力であり、関数についても型推論を行ってくれる。
但し、プラクティスとしてトップレベルの関数の型については型を明記することが望ましい
（型注釈を行わなかった場合、GHCでは警告が出る）。

```
Prelude> let double x = x + x
Prelude> :t double
double :: Num a => a -> a
```

一般にプログラミング言語の設計において、多相性と型推論はトレードオフである。
C++やJavaのように動的な部分型多相を実現している言語で、仮想関数の型推論を行うことは難しい。
Haskellにおいても型クラスによって型推論が複雑なものになっている。
複数の型変数を持つ型クラスなどを考えると、型推論ができないこともある。
OCamlの型推論は完全であるが、型安全性を保証するために、多相性には制約が掛けられている。
型が動的な状態に依存するような多相は（何らかの制約を掛けなければ）型安全でない。

## 組み込みの型

よく使われる組み込みの型をいくつか挙げる。

| 型名         | 用途           |
|:-------------|----------------|
| Integer      | 整数値         |
| Float        | 浮動小数点値   |
| Bool         | 真偽値         |
| char         | 文字           |
| string       | 文字列         |
| ()           | ユニット型     |

後述するように、stringはcharのリストの型[char]の別名に過ぎない。

## 数値リテラル

Haskellの数値リテラルは多相的である。

```
Prelude> :t 10
10 :: Num a => a
Prelude> :t 3.14
3.14 :: Fractional a => a
Prelude> :t (+)
(+) :: Num a => a -> a -> a
Prelude> :t 10 + 3.14
10 + 3.14 :: Fractional a => a
```

多相的であるため、型注釈が必要になることもある。

```
Prelude> :t read
read :: Read a => String -> a
Prelude> read "10" + 5
15
Prelude> :t read "10" + 5
read "10" + 5 :: (Num a, Read a) => a
Prelude> read "10"
*** Exception: Prelude.read: no parse
Prelude> :t read "10"
read "10" :: Read a => a
Prelude> read "10"::Int
10
Prelude> :t read "10"::Int
read "10"::Int :: Int
```

