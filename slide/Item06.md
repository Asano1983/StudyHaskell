
# Item 6 データ抽象

## 代数的データ型とdata宣言

data宣言を使うことによって新しいデータ型をユーザー定義できる。
例えば、列挙型をユーザー定義するときには次のようにする。

```
Prelude> data Animal = Cat | Dog | Monkey deriving Show
Prelude> Cat
Cat
Prelude> :t Cat
Cat :: Animal
Prelude> :t [Cat, Cat, Dog]
[Cat, Cat, Dog] :: [Animal]
```

このCat、Dog、Monkeyを値コンストラクタという。
|は複数の値コンストラクタ名をORで結びつける役割を果たしている。
deriving Showを行うことによって、型Animalは型クラスShowに属する型となり、文字列として出力することができる。

値コンストラクタに引数の型を指定することもできる。
これを用いて、C言語の共用体（union）のように使うこともできる。

```
Prelude> data Number = Integer Integer | Double Double
Prelude> :t Integer
Integer :: Integer -> Number
Prelude> :t Double
Double :: Double -> Number
Prelude> :t Integer 10
Integer 10 :: Number
Prelude> :t Double 3.14
Double 3.14 :: Number
```

上のコードでは値コンストラクタの名前空間と型コンストラクタの名前空間が独立していることを利用している
IntegerやDoubleという名前の値コンストラクタを定義するのはプラクティスとして良くないが、
ユーザー定義型に対して行うことはあるだろう。
また、値コンストラクタは型名と同様に大文字で始めらなければならない。

値コンストラクタに複数の引数の型を指定し、直積型を定義することもできる。
以下に定義されるユーザー定義型Pointは直積型である。

```
Prelude> data Point = Point Integer Integer deriving Show
Prelude> :t Point
Point :: Integer -> Integer -> Point
Prelude> :t Point 10 20
Point 10 20 :: Point
```

dataの後ろのPointは型名、等号の後ろのPointは値コンストラクタ名である。
値コンストラクタが1つであれば、型名と同じ名前を用いることが一般的である。

以上のようなdata宣言によって定義されるデータ型を代数的データ型という。
直積型、直和型を包括した概念であり、C言語の列挙型や共用体、構造体などに似た概念である。

値コンストラクタは関数に非常によく似ているが、
引数を取らなくてもよいこと、これ以上、簡約されることがないことなどの点において関数と異なる。

## レコード構文

レコードとはフィールドラベルの付いたデータ型のことである。
レコード構文を使うことによってレコードをユーザー定義することができる。

```
Prelude> :{
Prelude| data Person = Person { name :: String
Prelude|                      , age :: Int } deriving Show
Prelude| :}
Prelude> :t Person
Person :: String -> Int -> Person
Prelude> :t Person "Taro" 25
Person "Taro" 25 :: Person
Prelude> :t name
name :: Person -> String
Prelude> :t age
age :: Person -> Int
Prelude> let x = Person "Taro" 25
Prelude> name x
"Taro"
Prelude> age x
25
```

このとき、name :: Person -> Stringのようなgetterメソッドが自動生成され、
フィールドの値はname xのように取り出すことができる。

また、一部のフィールドを変更した新しいレコードを生成することができる。
このとき、元のレコードの値は書き換えられない。

```
Prelude> let y = x { age = 26 }
Prelude> y
Person {name = "Taro", age = 26}
Prelude> x
Person {name = "Taro", age = 25}
```

C言語の構造体に似ているが、破壊的代入を行うsetterメソッドはない。

また、フィールドに値を与えずに生成することも可能である（警告は発生する）。
実際にその値を呼び出すまでは例外が投げられない
（OCamlの場合は生成時にエラーになる）。

```
Prelude> let z = Person {name = "Jiro"}

<interactive>:23:9: Warning:
    Fields of ‘Person’ not initialised: age
    In the expression: Person {name = "Jiro"}
    In an equation for ‘z’: z = Person {name = "Jiro"}
Prelude> name z
"Jiro"
Prelude> age z
*** Exception: <interactive>:23:9-30: Missing field in record construction age
```

## パターンマッチ

フィールドの値を取り出すとき、関数nameの代わりにレコードのパターンマッチを使うこともできる。

```
Prelude> let Person {name = a, age = b} = x
Prelude> a
"Taro"
Prelude> b
25
Prelude> let Person {age = c} = y
Prelude> c
26
```

パターンマッチの方が表現力は遥かに高い。
レコードでない代数的データ型について、パターンマッチを使用することもできる。

```
Prelude> data Point = Point Integer Integer deriving Show
Prelude> let p = Point 10 20
Prelude> p
Point 10 20
Prelude> let Point px py = p
Prelude> px
10
Prelude> py
20
```

## 多相的データ型

data宣言において型引数を取ることもでき、多相的データ型を定義することができる

```
Prelude> data Vector a = Vector a a a deriving Show
Prelude> :t Vector
Vector :: a -> a -> a -> Vector a
Prelude> :t Vector "Cat" "Dog" "Lion"
Vector "Cat" "Dog" "Lion" :: Vector [Char]
```

多相的データ型はC++のクラステンプレートに似ている。
このとき、dataの後ろにあるVectorは型名ではなく、型コンストラクタ名である（カインドは* -> *）。

組み込みの型コンストラクタの例として、[]が挙げられる。
[]は型aからリストの型[a]を生成する型コンストラクタである。

データ宣言には型クラス制約を付けることができない（GHC 7.2.1以降で非推奨、Haskell 2012で削除）。
関数の型制限に型クラス制約を付ければ十分である。

## アクセス・コントロール

Haskellの型システムではアクセル・コントロールを行うことはできない。
アクセス・コントロールを行うのはモジュールの役目である。
Haskellにおいて、型の定義と関数の定義は独立している。

Haskellのモジュールにおいては、モジュールの先頭でエクスポートする関数やコンストラクタのリストを記述する。
関数名をこのリストに記述すればpublicなものになり、記述しなければprivateなものになる。

これを用いて、ユーザー定義のデータ型に関する関数やコンストラクタのアクセス・コントロールを行うことができる。
例えば、値コンストラクタを隠蔽して、生成用のヘルパ関数のみを公開することも可能である。

