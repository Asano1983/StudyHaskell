
# Item 2 ���X�g

## head

head�̓��X�g�̐擪�̗v�f��߂��֐��ł���B
Lisp�ɂ�����car�ɑ�������B
�󃊃X�g�ɍ�p������Ɨ�O�𓊂���B

```
Prelude> :t head
head :: [a] -> a
Prelude> head [3,1,4]
3
Prelude> head []
*** Exception: Prelude.head: empty list
```

## tail

tail�̓��X�g�̐擪�̗v�f��������������߂��֐��ł���B
Lisp�ɂ�����cdr�ɑ�������B
�󃊃X�g�ɍ�p������Ɨ�O�𓊂���B

```
Prelude> :t tail
tail :: [a] -> [a]
Prelude> tail [3,1,4]
[1,4]
Prelude> tail []
*** Exception: Prelude.tail: empty list
```

## (:)

(:)��cons���Z�q�Ƃ������B
���X�g�̐擪�ɗv�f��ǉ��������X�g��߂��֐��ł���B
[1,2,3]��1:(2:(3:[]))�̃V���^�b�N�X�E�V���K�[�ł���B

```
Prelude> :t (:)
(:) :: a -> [a] -> [a]
Prelude> 10:[1,2,3]
[10,1,2,3]
```

## ������

"Hello"��['H','e','l','l','o']�̃V���^�b�N�X�E�V���K�[�ł���A
�^String��[Char]�̕ʖ��ɉ߂��Ȃ��B

```
Prelude> :t "Hello"
"Hello" :: [Char]
Prelude> head "Hello"
'H'
Prelude> tail "Hello"
"ello"
Prelude> 'H':"ello"
"Hello"
```

## ���X�g�Ɋւ���֐�

```
Prelude> [3,1,4] ++ [2,7,1]
[3,1,4,2,7,1]
Prelude> concat [[3,1,4],[2,7,1],[100]]
[3,1,4,2,7,1,100]
Prelude> length [3,1,4,1,5,9]
6
Prelude> null [3,1,4]
False
Prelude> null []
True
Prelude> reverse [3,1,4]
[4,1,3]
Prelude> take 3 [3,1,4,1,5,9]
[3,1,4]
Prelude> [3,1,4,1,5,9]!!2
4
Prelude> sum [3,1,4]
8
Prelude> sum []
0
Prelude> product [3,1,4]
12
Prelude> product []
1
```

## �����W

```
Prelude> [1..20]
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
Prelude> [2,4..20]
[2,4,6,8,10,12,14,16,18,20]
Prelude> [3,6..20]
[3,6,9,12,15,18]
Prelude> [20,19..1]
[20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]
Prelude> [20,18..1]
[20,18,16,14,12,10,8,6,4,2]
Prelude> take 24 [13,26..]
[13,26,39,52,65,78,91,104,117,130,143,156,169,182,195,208,221,234,247,260,273,286,299,312]
Prelude> take 10 (cycle [1,2,3])
[1,2,3,1,2,3,1,2,3,1]
Prelude> take 5 (repeat 3)
[3,3,3,3,3]
```

## ���X�g����\�L

```
Prelude> [x*2 | x <- [1..10]]
[2,4,6,8,10,12,14,16,18,20]
Prelude> [x*2 | x <- [1..10], x*2 >= 12]
[12,14,16,18,20]
Prelude> [x+y | x <- [1,2,3], y <- [10,100,1000]]
[11,101,1001,12,102,1002,13,103,1003]
```

