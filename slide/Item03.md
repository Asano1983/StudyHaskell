
# Item 3 �y�A�ƃ^�v��

## �y�A�ƃ^�v��

�y�A�̌^(a, b)��a��b�̒��ό^�ł���B
�^�v���̌^(a1, a2, ... , an)��n�̒��ς̌^�ł���B

## fst��snd

�y�A�ɂ�1�ڂ̗v�f��Ԃ��֐�fst��2�ڂ̗v�f��Ԃ��֐�snd����`����Ă���B

```
Prelude> :t fst
fst :: (a, b) -> a
Prelude> fst (10, 3.14)
10
Prelude> :t snd
snd :: (a, b) -> b
Prelude> snd (10, "abc")
"abc"
```

�y�A�łȂ��^�v���ɑ΂���fst��snd����p������ƃG���[�ɂȂ�B
```
Prelude> fst (10, 3.14, "abc")

<interactive>:41:5:
    Couldn't match expected type �e(a, b0)�f
                with actual type �e(Integer, Double, [Char])�f
    Relevant bindings include it :: a (bound at <interactive>:41:1)
    In the first argument of �efst�f, namely �e(10, 3.14, "abc")�f
    In the expression: fst (10, 3.14, "abc")
    In an equation for �eit�f: it = fst (10, 3.14, "abc")
```

## zip��unzip

���X�g����y�A�̃��X�g�𐶐�����֐�zip����`����Ă���B
���X�g�̒����͒Z���ق��ɍ��킹����B
�������X�g�ɍ�p�����邱�Ƃ��ł���i�x���]�������j�B

```
Prelude> :t zip
zip :: [a] -> [b] -> [(a, b)]
Prelude> zip [1,2,3] "abc"
[(1,'a'),(2,'b'),(3,'c')]
Prelude> zip [1,2] "abc"
[(1,'a'),(2,'b')]
Prelude> zip [1,2,3] "ab"
[(1,'a'),(2,'b')]
Prelude> zip [1,2..] "abcde"
[(1,'a'),(2,'b'),(3,'c'),(4,'d'),(5,'e')]
```

�y�A�̃��X�g���烊�X�g�̃y�A�𐶐�����֐�unzip����`����Ă���B
```
Prelude> :t unzip
unzip :: [(a, b)] -> ([a], [b])
Prelude> unzip [(3,2),(1,7),(4,1)]
([3,1,4],[2,7,1])
```

| OCaml        | Haskell  |
|:-------------|----------|
| List.combine | zip      |
| List.split   | unzip    |

