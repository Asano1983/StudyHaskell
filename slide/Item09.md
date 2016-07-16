
## Item 9 型クラス

### 型クラスShow

型クラスShowは文字列として出力できる型の集合である。
deriving Showする代わりにinstance Showすることによって、
show関数をユーザー定義することができる。

```
Prelude> data Animal = Cat | Dog | Monkey
Prelude> :{
Prelude| instance Show Animal where
Prelude|     show Cat = "CAT"
Prelude|     show Dog = "DOG"
Prelude|     show Monkey = "MONKEY"
Prelude| :}
Prelude> Cat
CAT
Prelude> Dog
DOG
```

自動生成されるshow関数で十分であるときはderiving Showで自動導出すればよい。
また、型クラスShowのインスタンスになれば、
showsPrecやshowListなども定義せずに使うことができる。

### 型クラスEq

型クラスEqの定義は

```
class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool
    x == y = not (x /= y)
    x /= y = not (x == y)
```

のようになっており、
deriving Eqするか、
instance Eqして関数(==)か関数(/=)のいずれかを定義すれば型クラスEqのインスタンスとなる。

### 型クラスOrd

型クラスOrdは順序付け可能な型の集合である。
型クラスOrdの定義は

```
class Eq a => Ord a where
  compare :: a -> a -> Ordering
  (<) :: a -> a -> Bool
  (<=) :: a -> a -> Bool
  (>) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  max :: a -> a -> a
  min :: a -> a -> a
  -- いろいろデフォルト実装が書いてある
```

のようになっている。
型クラスOrdに属するためには型クラスEqのインスタンスである必要がある。
型クラスEqのインスタンスに対して、関数compareか関数(<=)を定義すれば型クラスOrdのインスタンスとなる。
compareを定義することの方が効率的であることが多い。

### アドホック多相

上述のようにあるクラス型に属するデータ型を定義する際に、
必要な関数を独自に定義することができる。
このため、例えば、show :: Show a => a -> Stringは1つの関数であるが、
型ごとの実装にディスパッチすることができている。
このようにクラス型を利用することでアドホック多相を実現することができる。

C++やJavaのオーバーライドに似ていなくもないが、クラス型はクラスではないことに注意しよう。
しいて言えば、C++の関数テンプレートのオーバーロードに近い。

