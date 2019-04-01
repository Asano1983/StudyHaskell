
# Item 5 ���K�֐�

## map��filter

map��filter�͍ł���{�I�ȍ��K�֐��ł���B
map�̓��X�g�̊e�v�f�Ɋ֐�����p���������ʂ̃��X�g�𐶐����鍂�K�֐��A
filter�͏����ɖ������v�f����Ȃ郊�X�g�𐶐����鍂�K�֐��ł���B

```
Prelude> :t map
map :: (a -> b) -> [a] -> [b]
Prelude> map (+3) [1,5,3,1,6]
[4,8,6,4,9]
Prelude> :t filter
filter :: (a -> Bool) -> [a] -> [a]
Prelude> filter (>3) [1,5,3,2,1,6,4,3,2,1]
[5,6,4]
```

| C++            | OCaml       | Haskell  |
|:---------------|-------------|----------|
| std::transform | List.map    | map      |
| std::copy_if   | List.filter | filter   |

## zipWith

zip��ėp���������K�֐�zipWith����{�I�ŗL�p�ł���B

```
Prelude> :t zipWith
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
Prelude> zipWith (+) [3,1,4] [2,7,1]
[5,8,5]
```

| OCaml        | Haskell  |
|:-------------|----------|
| List.combine | zip      |
| List.split   | unzip    |
| List.map2    | zipwith  |

## ��ݍ���

Haskell�ɂ͍���ݍ��݂̍��K�֐�foldl�ƉE��ݍ��݂̍��K�֐�foldr���p�ӂ���Ă���B

| C++             | Python | JavaScript | OCaml           | Haskell |
|:----------------|--------|------------|-----------------|---------|
| std::accumulate | reduce | inject     | List.fold_left  | foldl   |
|                 |        |            | List.fold_right | foldr   |

```
Prelude> :t foldl
foldl :: Foldable t => (b -> a -> b) -> b -> t a -> b
Prelude> :t foldr
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
```

�^�N���XFoldable�͍��K�̌^�N���X�ł���iFoldable�̃J�C���h��* -> *�ł���j�B
���X�g��c���[�͌^�N���XFoldable�ɑ�����B
�Ƃ肠�����̓��X�g�݂̂��l����̂ŁA

```
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f z []     = z
foldl f z (x:xs) = foldl f (f z x) xs
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z []     = z
fordr f z (x:xs) = f x (foldr f z xs)
```

�ƍl���悤�B
foldl�͖����ċA�ł��邪�Afoldr�͖����ċA�ł͂Ȃ��B

����ݍ���foldl��p���āAsuml���`���邱�Ƃ��ł���B

```
Prelude> :{
Prelude| let suml :: (Num a) => [a] -> a
Prelude|     suml = foldl (+) 0
Prelude| :}
Prelude> suml [1,5,3,2,1]
12
```

���̊֐��͎��̂悤�ɕ]������A����ݍ��݂��������Ă���B
suml [1,5,3,2,1]
 �� foldl (+) 0 [1,5,3,2,1]
 �� foldl (+) 0 (1:[5,3,2,1])
 �� foldl (+) (0 + 1) [5,3,2,1]
 �� foldl (+) ((0 + 1) + 5) [3,2,1]
 �� foldl (+) (((0 + 1) + 5) + 3) [2,1]
 �� foldl (+) ((((0 + 1) + 5) + 3) + 2) [1]
 �� foldl (+) (((((0 + 1) + 5) + 3) + 2) + 1) []
 �� (((((0 + 1) + 5) + 3) + 2) + 1)
 �� (((6 + 3) + 2) + 1)
 �� ((9 + 2) + 1)
 �� (11 + 1)
 �� 12

�E��ݍ���foldr��sumr���`����ƁA
sumr [1,5,3,2,1]
 �� foldr (+) 0 [1,5,3,2,1]
 �� foldr (+) 0 (1:[5,3,2,1])
 �� (+) 1 (foldr (+) 0 [5,3,2,1])
 �� (+) 1 ( (+) 5 (foldr (+) 0 [3,2,1]))
 �� (+) 1 ( (+) 5 ( (+) 3 (foldr (+) 0 [2,1])))
 �� (+) 1 ( (+) 5 ( (+) 3 ( (+) 2 (foldr (+) 0 [1]))))
 �� (+) 1 ( (+) 5 ( (+) 3 ( (+) 2 ( (+) 1 (foldr (+) 0 [])))))
 �� (+) 1 ( (+) 5 ( (+) 3 ( (+) 2 ( (+) 1 0))))
 �� (+) 1 ( (+) 5 ( (+) 3 ( (+) 2 1)))
 �� (+) 1 ( (+) 5 ( (+) 3 3))
 �� (+) 1 ( (+) 5 6)
 �� (+) 1 11
 �� 12
�̂悤�ɕ]�������B
���@�͉E������s����邪�A���X�g�̑������͍̂�����s���Ă��邱�Ƃɒ��ӂ��悤�B

�E��ݍ���foldr�͖������X�g��]�����邱�Ƃ��ł���B
�Ⴆ�΁A�E��ݍ��݂Œ�`���ꂽandr�𖳌����X�grepeat False�ɍ�p�������False��Ԃ��B

```
Prelude> :{
Prelude| let andr:: [Bool] -> Bool
Prelude|     andr xs = foldr (&&) True xs
Prelude| :}
Prelude> andr (repeat False)
False
```

andr (repeat False)
 �� foldr (&&) True (repeat False)
 �� foldr (&&) True (False: repeat False))
 �� (&&) False (foldr (&&) True (repeat False))
 �� False
�ƂȂ�B

�������A����ݍ��݂Œ�`���ꂽandl�𖳌����X�grepeat False�ɍ�p������Ɩ������[�v�Ɋׂ�B

```
Prelude> :{
Prelude| let andl:: [Bool] -> Bool
Prelude|     andl xs = foldl (&&) True xs
Prelude| :}
Prelude> andl (repeat False)
```

�ƒ�`����ƁA
andl (repeat False)
 �� foldl (&&) True (repeat False)
 �� foldl (&&) True (False: (repeat False))
 �� foldl (&&) ( (&&) True False ) (repeat False)
 �� foldl (&&) False (False: repeat False)
 �� foldl (&&) False (False: repeat False)
 �� foldl (&&) ( (&&) False False ) (repeat False)
�ƂȂ�A�]���i�Ȗ�j���I���Ȃ��B

��ʂɒl��Ԃ��֐���foldl��p�����ق����ǂ����Ƃ������̂����A
�����Ɏ��֐��i���̗�ł�(&&)�̂��Ɓj���񐳊i�ŁA
�Z���]���iFalse�����������_�ő����I���j���s�������ꍇ��foldr��p���邱�ƂɂȂ�B
foldl�̓��X�g�̑S�v�f�𑖍����Ă��܂����Ƃɒ��ӂ��悤�ifoldr��萳�i���������j�B

�⑫�Frepeat��

```
repeat :: a -> [a]
repeat x = xs where xs = x:xs
```

�Œ�`����Ă���B

# �ċA�A��ݍ��݁Amap��filter

�ċA�A��ݍ��݁Amap��filter�̏��ɕ\���͂������B
map��filter�ŕ\���ł�����͍̂ċA���g�킸��map��filter�ŏ����������ǐ��������B

# foldl'

Data.List���W���[���ɂ͐��i�ł̍���ݍ���foldl'����`����Ă���B
�قƂ�ǂ̏ꍇ�Afoldl���foldl'���g���������������ǂ��B

```
foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' f a []     = a
foldl' f a (x:xs) = let a' = f a x in a' `seq` foldl' f a' xs
```

����foldl'��p����ƁA
 �� foldl' (+) 0 [1,5,3,2,1]
 �� foldl' (+) 0 (1:[5,3,2,1])
 �� foldl' (+) 1 [5,3,2,1]
 �� foldl' (+) 6 [3,2,1]
 �� foldl' (+) 9 [2,1]
 �� foldl' (+) 11 [1]
 �� foldl' (+) 12 []
 �� 12
�̂悤�ɐ��i�ɍ���ݍ��݂��s�����Ƃ��ł���B

�����Ɏ��֐�f�����i�֐��̂Ƃ���foldl'�̕���foldl�����������ǂ��B
f���񐳊i�֐��ł���A�Z���]����K�v�Ƃ���Ƃ���foldr���g�����ƂɂȂ邽�߁A
�񐳊i��foldl���g���ׂ��ǖʂ͂��܂�Ȃ��B
foldl�̓��X�g�̑S�v�f�𑖍����Ă��܂����߁A�x���������r���[�ł���A���p���ɂ͖R�����i�w�K��͒�`���킩��₷�����j�B

