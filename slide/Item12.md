
# Item 12 do記法

## do記法の大雑把な解釈

do記法は大雑把には次のルールで解釈されるようなシンタックス・シュガーである。

1. do {e} → e
1. do {e; es} → e >> do {es}
1. do {let decls; es} → let decls in do {es}
1. do {p <- e; es} → e >>= \p -> es

「\p -> es」はpに対してesを返すラムダ式（無名関数）である。
簡単な例で説明する。

```
Prelude> :{
Prelude| do
Prelude|   div2 10
Prelude|   div2 20
Prelude| :}
Just 10
```

このコードはdiv2 10 >> div2 20と解釈される。
前者の計算は成功するので、後者の計算結果であるJust 10を戻す。

```
Prelude> :{
Prelude| do
Prelude|   div2 13
Prelude|   div2 20
Prelude| :}
Nothing
```

このコードはdiv2 13 >> div2 20と解釈される。
前者の計算が失敗するので、Nothingを戻すことになる。

```
Prelude> :{
Prelude| do
Prelude|   let x = 16
Prelude|   div2 x
Prelude| :}
Just 8
```

このコードはlet x = 16 in div2 xと解釈されるので、Just 8を戻すことになる。

```
Prelude> :{
Prelude| do
Prelude|  x <- Just 16
Prelude|  div2 x
Prelude| :}
Just 8
```

このコードはJust 16 >>= \x -> div2 x と解釈されるので、Just 8を戻すことになる。

## do記法の正確な解釈

do記法は正確には次のルールで解釈されるようなシンタックス・シュガーである。

1. do {e} → e
1. do {e; es} → e >> do {es}
1. do {let decls; es} → let decls in do {es}
1. do {p <- e; es} → let ok p = do {es} ; ok _ = fail "..." in e >>= ok

違いは4番目にある。
1行に書くと読みにくいので改行を加えて再掲するが、okの定義にはパターンマッチを使用している。

```
let ok p = do {es} 
    ok _ = fail "..."
  in e >>= ok
```

パターンマッチが成功したときには「大雑把な解釈」と同じことであるが、
パターンマッチが失敗したときに関数failを呼び出す点が異なっている。

関数failは型クラスMonadのインスタンスである型に対して定義されている関数で、
基本的には（オーバーライドしなければ）例外を投げるだけの関数である。

```
Prelude> :t fail
fail :: Monad m => String -> m a
Prelude> fail "..."
*** Exception: user error (...)
```

## Monadの役割

このように型クラスMonadのインスタンスであるような型については、
do記法を用いることができ、命令型言語における命令的記述をエミュレートすることができる。

Maybeは命令型言語における例外をエミュレートしているが、
後述するIOは入出力を、Stateは状態に対する破壊的代入をエミュレートする。
このようにHaskellは純粋関数型言語であり、副作用を持つ文を一切認めないが、
型クラスMonadに属する型を使うことによって、命令型言語における副作用を持つような命令的記述と同等のことをエミュレートできる。

## 具体例

Item 7で次のようなコードを見た。

```
main = do
  name <- readFile "input.txt"
  writeFile "output.txt" ("Hello " ++ name)
```

このdo記法は次のように解釈される。

```
main =
  (readFile "input.txt") >>= \name -> writeFile "output.txt" ("Hello " ++ name)
```


