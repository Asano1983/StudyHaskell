
# Item 4 ����\��

## �p�^�[���}�b�`

����̓p�^�[���}�b�`�ŁA���[�v�͍ċA���g���Ď����ł���B
�p�^�[���}�b�`�͖��ߌ^�v���O���~���O��switch���Ɏ��Ă��邪�A�\���͂͂�荂���B

```
Prelude> :{
Prelude| let factorial :: Int -> Int
Prelude|     factorial 0 = 1
Prelude|     factorial n = n * factorial (n - 1)
Prelude| :}
Prelude> factorial 0
1
Prelude> factorial 5
120
```

�p�^�[�����ԗ��I�łȂ��Ƃ��A�\�����Ă��Ȃ��l����͂���Ɨ�O����������B
�֐���`���ɂ͌x������Ȃ����Ƃɒ��ӂ��悤�iOCaml�͌x�����Ă����j�B

```
Prelude> :{
Prelude| let charName :: Char -> String
Prelude|     charName 'a' = "Alice"
Prelude|     charName 'b' = "Bob"
Prelude|     charName 'c' = "Carol"
Prelude| :}
Prelude> charName 'a'
"Alice"
Prelude> charName 'b'
"Bob"
Prelude> charName 'h'
"*** Exception: <interactive>:(44,5)-(46,26): Non-exhaustive patterns in function charName
```

�S�ĂɃ}�b�`����p�^�[�����Ō�ɓ���Ă����ƈ��S�ł���B

```
Prelude> :{
Prelude| let charName :: Char -> String
Prelude|     charName 'a' = "Alice"
Prelude|     charName 'b' = "Bob"
Prelude|     charName 'c' = "Carol"
Prelude|     charName x   = "No Name"
Prelude| :}
Prelude> charName 'a'
"Alice"
Prelude> charName 'b'
"Bob"
Prelude> charName 'h'
"No Name"
```

�p�^�[���}�b�`�̓^�v���ɑ΂��Ă��g����B
���̊֐�addVectors�̓p�^�[���}�b�`���g���Ē�`�ł���B
fst��snd���g���K�v���Ȃ��̂ŊȌ��ł���B

```
Prelude> :{
Prelude| let addVectors :: (Double, Double) -> (Double, Double) -> (Double,Double)
Prelude|     addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)
Prelude| :}
Prelude> addVectors (2,3) (5,8)
(7.0,11.0)
```

���C���h�J�[�h_���g�����Ƃ��ł���B
�g���v������1�ڂ̗v�f��Ԃ��֐�first�����̂悤�ɒ�`�ł���B

```
Prelude> :{
Prelude| let first :: (a, b, c) -> a
Prelude|     first (x, _, _) = x
Prelude| :}
Prelude> first (10, 3.14, 'a')
10
```

�p�^�[���}�b�`�̓��X�g���@�\�L�ɂ����Ă��L�p�ł���B

```
Prelude> let xs = [(1,3),(4,3),(2,4),(5,3),(5,6),(3,1)]
Prelude> [a+b | (a, b) <- xs]
[4,7,6,8,11,4]
Prelude> [x*100+3 | (x,3) <- xs]
[103,403,503]
```

���X�g��1�ڂ̗v�f��Ԃ��֐�head'���p�^�[���}�b�`���g���Ď������Ă݂�B

```
Prelude> :{
Prelude| let head' :: [a] -> a
Prelude|     head' [] = error "Can't call head on an empty list, dummy!"
Prelude|     head' (x:_) = x
Prelude| :}
Prelude> head' [1,2,3,4,5]
1
Prelude> head' []
*** Exception: Can't call head on an empty list, dummy!
```

## �K�[�h��

�͈͂ȂǏ����ŕ��򂷂�Ƃ��̓K�[�h�߂��L�p�ł���B

```
Prelude> :{
Prelude| let factorial' :: Int -> Int
Prelude|     factorial' n
Prelude|       | n < 0     = error "out of range"
Prelude|       | n == 0    = 1
Prelude|       | otherwise = n * factorial' (n - 1)
Prelude| :}
Prelude> factorial' 0
1
Prelude> factorial' 5
120
Prelude> factorial' (-1)
*** Exception: out of range
```

## where�߂�let��

where�߂�let�����g���ƁA�Ǐ��ϐ����`���邱�Ƃ��ł���B
let���͎��Ȃ̂ŁA�ǂ��ɂł�������B
where�߂͊֐���`���ɂ��������Ȃ��B

```
Prelude> let x = 10 in x ^ 2
100
Prelude> let func x = a ^ 2 where a = x + 1
Prelude> func 10
121
```

�p�^�[���}�b�`�ɂ����ėp���邱�Ƃ��L�p�ł���B

```
Prelude> :{
Prelude| let bmiTell :: Double -> Double -> String
Prelude|     bmiTell weight height
Prelude|       | bmi <= 18.5 = "You're underweight"
Prelude|       | bmi <= 25.0 = "You're normal"
Prelude|       | bmi <= 30.0 = "You're fat"
Prelude|       | otherwise   = "You're a whale"
Prelude|       where bmi = weight / height ^ 2
Prelude| :}
Prelude> bmiTell 85 1.90
"You're normal"
Prelude> bmiTell 60 1.90
"You're underweight"
Prelude> bmiTell 200 1.90
"You're a whale"
```

## �ċA

���ߌ^�v���O���~���O�ɂ����郋�[�v�Ŏ����ł��邱�Ƃ́A��ɍċA�Ŏ����ł���B

```
Prelude> :{
Prelude| let maximum' :: (Ord a) => [a] -> a
Prelude|     maximum' [] = error "maximum of empty list!"
Prelude|     maximum' [x] = x
Prelude|     maximum' (x:xs) = max x (maximum' xs)
Prelude| :}
Prelude> maximum' [3,1,4,1,5,9,2]
9
Prelude> maximum' [1,2,3,4,5]
5
```

�֐�quicksort���Ȍ��ɒ�`�ł���B

```
Prelude> :{
Prelude| let quicksort :: (Ord a) => [a] ->[a]
Prelude|     quicksort [] = []
Prelude|     quicksort (x:xs) =
Prelude|         let smallerOrEqual = [a | a <- xs, a <= x]
Prelude|             larger = [a | a <- xs, a > x]
Prelude|         in  quicksort smallerOrEqual ++ [x] ++ quicksort larger
Prelude| :}
Prelude> quicksort [3,1,4,1,5,9,2]
[1,1,2,3,4,5,9]
```

�^�N���XOrd�͏�����������^�̏W���ł���B

## �ċA�Ɩ����ċA

�����ċA�ŋL�q����ƁA���[�v�Ƃ��ăR���p�C�������B
���l��Ԃ��֐��͖����ċA��p���������悢���Ƃ������B
�x���f�[�^�i���X�g�Ȃǁj��Ԃ��֐��́i�����ċA�łȂ��j���ʂ̍ċA��p���������悢���Ƃ������B

�Ⴆ�΁A���R�����ꂽ���X�g��Ԃ�concat�́i�����ċA�łȂ��j���ʂ̍ċA�ɂ���Ē�`����Ă���B

```
concat :: [[a]] -> [a]
concat []       = []
concat (xs:xss) = (++) xs (concat xss)
```

 