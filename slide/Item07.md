
# Item 7 入出力

## unit型 ()

unit型 ()は()という何も持たないタプルのみを値として持つ型である。
C言語のvoid型のようなものであり、副作用を持つ関数の戻り値の型に使われる。

## 標準入出力

関数putStrLnは文字列を標準出力へ出力する関数である。
戻り値の型はIO ()という、unit型 ()にIOという「文脈」が付いた型であるが、詳しくは後述する。

```
Prelude> :t putStrLn
putStrLn :: String -> IO ()
```

関数getLineは文字列を標準入力から入力する関数である。
戻り値の型はIO Stringという、String型にIOという「文脈」が付いた型であるが、詳しくは後述する。

```
Prelude> :t getLine
getLine :: IO String
```

## ファイル入出力

関数writeFileは文字列をファイルに出力する関数である。
関数writeFileはファイルに対して文字列を上書き保存する（追記はappendFileで出来る）。

```
Prelude> :t writeFile
writeFile :: FilePath -> String -> IO ()
```

関数readFileは文字列をファイルから取得する関数である。

```
Prelude> :t readFile
readFile :: FilePath -> IO String
```

## do記法による使用例1

do記法（Item 11で後述）を用いて、命令型プログラミングをエミュレートしてみる。

```
Prelude> :{
Prelude| do
Prelude|     name <- getLine
Prelude|     putStrLn ("Hello " ++ name)
Prelude| :}
Taro
Hello Taro
```

do記法の1行目ではgetLineの戻り値（IO String型）の中身をname（String型）で束縛している。
do記法の2行目ではputStrLn ("Hello " ++ name)を実行している。
これは命令型プログラミングにおける逐次実行（をエミュレートしたもの）と考えてよい。
Taroを入力すると、Hello Taroが出力される。

## do記法による使用例2

次のソースファイルItem07-01.hsを作成する。

```
main = do
  name <- readFile "Iteminput.txt"
  writeFile "output.txt" ("Hello " ++ name)
```

2行目ではreadFile "input.txt"の中身をname（String型）で束縛している。
3行目ではwriteFile "output.txt" ("Hello " ++ name)を実行している。
これは命令型プログラミングにおける逐次実行（をエミュレートしたもの）と考えてよい。

input.txtには文字列Taroを入れておく。

```
Prelude> :cd source_codes\\StudyHaskell\\src
Prelude> writeFile "input.txt" "Taro"
Prelude> readFile "input.txt"
Taro"
```

上のソースファイルItem07-01.hsをロードして、実行してみると、
output.txtが生成され、文字列Hello Taroが入っている。

```
Prelude> :cd StudyHaskell\\src
Prelude> :load Item07-01.hs
[1 of 1] Compiling Main             ( Item07-01.hs, interpreted )
Ok, modules loaded: Main.
*Main> main
*Main> readFile "output.txt"
"Hello Taro"
```

