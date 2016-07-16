
# Item 8 例外

## 例外

HaskellではNothingやLeftを使って大域脱出できる。

NothingはMaybe a型の値であり、何らかの計算の失敗を意味する。

```
Prelude> :t Nothing
Nothing :: Maybe a
```

LeftはEither a b型の値を戻す関数であり、エラーメッセージなどを持たせることができる。

```
Prelude> :t Left
Left :: a -> Either a b
```

## do記法による使用例1

do記法（Item 11で後述）を用いて、命令型プログラミングをエミュレートしてみる。

```
Prelude> :{
Prelude| do
Prelude|     let x = 3 + 5
Prelude|     return x
Prelude| :}
8
```

このdo記法は単に上から逐次的実行を行っている。

```
Prelude> :{
Prelude| do
Prelude|     let x = 3 + 5
Prelude|     Nothing
Prelude|     return x
Prelude| :}
Nothing
```

do記法の2行目ではNothing（Maybe Int型）を実行し、大域脱出している。
3行目のreturn xは実行されない。

```
Prelude> :{
Prelude| do
Prelude|     let x = 3 + 5
Prelude|     Left("Error")
Prelude|     return x
Prelude| :}
Left "Error"
```

do記法の2行目ではLeft("Error")（Either String Int型）を実行し、大域脱出している。
3行目のreturn xは実行されない。
Leftを使うことによって、単に失敗したことを伝えるだけではなく、
エラーメッセージなどの情報を付け加えることができる。

