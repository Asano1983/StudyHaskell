
# Item 8 Maybe

## Maybe�̒�`

���X�g�̌^�𐶐�����[]�͑g�ݍ��݂̌^�R���X�g���N�^�ł������B
[]�͌^a�������Ɏ���āA�^[a]��߂��B

```
Prelude> :i []
data [] a = [] | a : [a]
Prelude> :k []
[] :: * -> *
```

Maybe�����l�Ɍ^a�������Ɏ���āA�^Maybe a��߂��^�R���X�g���N�^�ł���B

```
Prelude> :i Maybe
data Maybe a = Nothing | Just a
Prelude> :k Maybe
Maybe :: * -> *
```

�^Maybe a�͌^a��Nothing��t���������^�i���a�^�j�ł���A
Just :: a -> Maybe a�ɂ����a��Maybe a�ɖ��ߍ��܂�Ă���B
�֐��̖߂�l�̌^��Maybe a�ł��邱�Ƃ́A���̊֐������s����\�������邱�Ƃ��Ӗ����Ă���B

```
Prelude> :{
Prelude| let div2 :: Int -> Maybe Int
Prelude|     div2 x = if even x then Just (x `div` 2)
Prelude|                        else Nothing
Prelude| :}
Prelude> div2 10
Just 5
Prelude> div2 13
Nothing
```

���̊֐�div2�͖��ߌ^����ɂ�����u��O�𓊂��邩������Ȃ��֐��v�Ɏ��Ă���B
Haskell�͎Q�Ɠ��߂Ȋ֐��݂̂���舵�����A���̂悤�Ȍ`�ŗ�O�Ƃ������ߌ^����̋@�\���������邱�Ƃ��ł���B

## �^�N���XFunctor�Ɗ֐�fmap

���̃R�[�h�̓G���[�ɂȂ�B
div2 10�̌^��Maybe Int�ł���A1�̌^��Int�ł��邩��ł���B

```
Prelude> div2 10 + 1

<interactive>:57:9:
    No instance for (Num (Maybe Int)) arising from a use of �e+�f
    In the expression: div2 10 + 1
    In an equation for �eit�f: it = div2 10 + 1
```

�֐�fmap��p����ƁA(+ 1) :: Int -> Int ��Maybe Int -> Maybe Int �Ɏ��R�Ɋg�����邱�Ƃ��ł���B

```
Prelude> :t fmap
fmap :: Functor f => (a -> b) -> f a -> f b
Prelude> :t fmap (+ 1)
fmap (+ 1) :: (Functor f, Num b) => f b -> f b
Prelude> fmap (+ 1) (div2 10)
Just 6
Prelude> fmap (+ 1) (div2 13)
Nothing
```

�^�N���XFunctor�͏�q�̊֐�fmap�����܂���`����Ă���悤�ȍ��K�̌^�N���X�ł���i�J�C���h��* -> *�j�B
Maybe�͌^�N���XFunctor�̃C���X�^���X�ł���AMaybe�ɂ�����֐�fmap��

```
instance Functor Maybe where
    fmap f (Just x) = Just (f x)
    fmap f Nothing  = Nothing
```

�̂悤�ɒ�`����Ă���B

## �^�N���XMonad�Ɗ֐�(>>=)

fmap�͕֗��ł��邪�Afmap�����ł͕s�\���Ȃ��Ƃ�����B
�Ⴆ�΁A16�ɑ΂��Ċ֐�div2��2���p���������Ƃ���B
���̂Ƃ��Afmap div2�̌^��Maybe Int -> Maybe (Maybe Int)�̂悤�ɂȂ��Ă��܂��A
�߂�l��Just (Just 4)�ɂȂ��Ă��܂��B

```
Prelude> :t fmap div2
fmap div2 :: Functor f => f Int -> f (Maybe Int)
Prelude> (fmap div2) (div2 16)
Just (Just 4)
Prelude> (fmap div2) (div2 14)
Just Nothing
Prelude> (fmap div2) (div2 13)
Nothing
```

����͕s�ւł���B
16�ɑ΂��Ċ֐�div2��2���p�����Ƃ���Just 4���߂��Ă��ė~�����͂��ł���B

�֐�(>>=)��p����ƁAdiv2 :: Int -> Maybe Int��Maybe Int -> Maybe Int�̂悤�Ɏg�����Ƃ��ł���B
(>>=)��bind���Z�q�Ƃ������B

```
Prelude> :t (>>=)
(>>=) :: Monad m => m a -> (a -> m b) -> m b
Prelude> Just 16 >>= div2
Just 8
Prelude> Just 16 >>= div2 >>= div2
Just 4
Prelude> Just 16 >>= div2 >>= div2 >>= div2
Just 2
```

�^�N���XMonad�͏�q�̊֐�(>>=)�Ȃǂ����܂���`����Ă���悤�ȍ��K�̌^�N���X�ł���i�J�C���h��* -> *�j�B
Maybe�͌^�N���XMonad�̃C���X�^���X�ł�����AMaybe�ɂ�����֐�(>>=)��

```
instance Monad Maybe where
    Nothing >>= f = Nothing
    Just x >>= f  = f x
```

�̂悤�ɒ�`����Ă���B

���̂悤�Ɋ֐�(>>=)���g�����Ƃɂ���āA
div2�̂悤�ȁu���s���邩������Ȃ��֐��v�𕡐��񍇐����邱�Ƃ��ł���B

## �֐�(>>)

�^�N���XMonad�̃C���X�^���X�ł���^�ɂ͎����I�Ɋ֐�(>>)��

```
m >> k = m >>= \_ -> k
```

�ɂ���Ē�`�����i�P���I��k��Ԃ�a -> m b�^�̊֐���(>>=)�̑�2�����ɗ^����j�B
�֐�(>>)��then�ƌĂ΂�邱�Ƃ�����A�^�͈ȉ��̂Ƃ���ł���B

```
Prelude> :t (>>)
(>>) :: Monad m => m a -> m b -> m b
```

Maybe Int�^�ɂ����Ă͎��̂悤�ɓ����B

```
Prelude> Just 10 >> Just 20
Just 20
Prelude> Nothing >> Just 20
Nothing
Prelude> Just 10 >> Nothing
Nothing
Prelude> Nothing >> Nothing
Nothing
```

���ߌ^����ɂ����Ē������s�����Ƃ��̌��ʂ�Ԃ����ƂɎ��Ă���B
��̗�ɂ����ẮAm >> k�͌v�Z���������Ă���Ƃ���k�̒l��Ԃ��̂ł��邪�Am�̌v�Z�����s�����Ƃ���Nothing��Ԃ��B
���̊֐�(>>)�͎����ł�do�L�@�Ɛ[���ւ������B

## �֐�join

���_�I�Ɏ�舵���Ƃ��A�֐�(>>=)�����֐�join���l�����������������₷�����Ƃ�����B

```
join :: Maybe (Maybe a) -> Maybe a
join Nothing = Nothing
join Just x  = x
```

���̊֐�join��p����ƁA�֐�(>>=)��

```
x >>= f = join (fmap f x)
```

�Ə�����B
�܂�A�֐�(>>=)���s���Ă��邱�Ƃ́A
fmap���邱�Ƃ�Maybe (Maybe a)�̂悤�ɂȂ��Ă��܂����߂�l��
join�ɂ����Maybe a�ɒׂ��Ă���ƍl������B

�t��(>>=)�ɂ����join��\�����Ƃ��\�ł���B

```
join x = x >>= id
```

���̂��߁A(>>=)���`���邱�ƂƁAjoin���`���邱�Ƃ͓������Ƃł���B
�R�[�h��������ł�(>>=)�̕����֗��ł��邪�A
���_�I�����̏�ł�join�̕����P���ŕ�����₷�����Ƃ����X����B

