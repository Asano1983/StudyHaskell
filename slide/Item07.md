
# Item 7 ���o��

## unit�^ ()

unit�^ ()��()�Ƃ������������Ȃ��^�v���݂̂�l�Ƃ��Ď��^�ł���B
C�����void�^�̂悤�Ȃ��̂ł���A����p�����֐��̖߂�l�̌^�Ɏg����B

## �W�����o��

�֐�putStrLn�͕������W���o�͂֏o�͂���֐��ł���B
�߂�l�̌^��IO ()�Ƃ����Aunit�^ ()��IO�Ƃ����u�����v���t�����^�ł��邪�A�ڂ����͌�q����B

```
Prelude> :t putStrLn
putStrLn :: String -> IO ()
```

�֐�getLine�͕������W�����͂�����͂���֐��ł���B
�߂�l�̌^��IO String�Ƃ����AString�^��IO�Ƃ����u�����v���t�����^�ł��邪�A�ڂ����͌�q����B

```
Prelude> :t getLine
getLine :: IO String
```

## �t�@�C�����o��

�֐�writeFile�͕�������t�@�C���ɏo�͂���֐��ł���B
�֐�writeFile�̓t�@�C���ɑ΂��ĕ�������㏑���ۑ�����i�ǋL��appendFile�ŏo����j�B

```
Prelude> :t writeFile
writeFile :: FilePath -> String -> IO ()
```

�֐�readFile�͕�������t�@�C������擾����֐��ł���B

```
Prelude> :t readFile
readFile :: FilePath -> IO String
```

## do�L�@�ɂ��g�p��1

do�L�@�iItem 11�Ō�q�j��p���āA���ߌ^�v���O���~���O���G�~�����[�g���Ă݂�B

```
Prelude> :{
Prelude| do
Prelude|     name <- getLine
Prelude|     putStrLn ("Hello " ++ name)
Prelude| :}
Taro
Hello Taro
```

do�L�@��1�s�ڂł�getLine�̖߂�l�iIO String�^�j�̒��g��name�iString�^�j�ő������Ă���B
do�L�@��2�s�ڂł�putStrLn ("Hello " ++ name)�����s���Ă���B
����͖��ߌ^�v���O���~���O�ɂ����钀�����s�i���G�~�����[�g�������́j�ƍl���Ă悢�B
Taro����͂���ƁAHello Taro���o�͂����B

## do�L�@�ɂ��g�p��2

���̃\�[�X�t�@�C��Item07-01.hs���쐬����B

```
main = do
  name <- readFile "Iteminput.txt"
  writeFile "output.txt" ("Hello " ++ name)
```

2�s�ڂł�readFile "input.txt"�̒��g��name�iString�^�j�ő������Ă���B
3�s�ڂł�writeFile "output.txt" ("Hello " ++ name)�����s���Ă���B
����͖��ߌ^�v���O���~���O�ɂ����钀�����s�i���G�~�����[�g�������́j�ƍl���Ă悢�B

input.txt�ɂ͕�����Taro�����Ă����B

```
Prelude> :cd source_codes\\StudyHaskell\\src
Prelude> writeFile "input.txt" "Taro"
Prelude> readFile "input.txt"
Taro"
```

��̃\�[�X�t�@�C��Item07-01.hs�����[�h���āA���s���Ă݂�ƁA
output.txt����������A������Hello Taro�������Ă���B

```
Prelude> :cd StudyHaskell\\src
Prelude> :load Item07-01.hs
[1 of 1] Compiling Main             ( Item07-01.hs, interpreted )
Ok, modules loaded: Main.
*Main> main
*Main> readFile "output.txt"
"Hello Taro"
```

