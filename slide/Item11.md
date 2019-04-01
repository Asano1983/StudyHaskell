
# Item 11 IO�i�쐬���j

## IO�̒�`

IO�͌^a�������Ɏ���āA�^IO a��߂��^�R���X�g���N�^�ł���B
�֐��̖߂�l�̌^��IO a�ł��邱�Ƃ́A���̊֐������o�͂��s���Ă���\�������邱�Ƃ��Ӗ����Ă���B

```
Prelude> :i IO
newtype IO a
  = GHC.Types.IO (GHC.Prim.State# GHC.Prim.RealWorld
                  -> (# GHC.Prim.State# GHC.Prim.RealWorld, a #))
```

�N���C�A���g����B�����邽�߂ɕ��G�Ȍ^���ɂȂ��Ă��邪�A
�ȒP�ɏ����΁ARealWorld -> (RealWorld, a)�^�̂��Ƃł���B
�v�Z�O�̐��E�������Ɏ���āu�v�Z��̐��E�iRealWorld�^�j�ƌv�Z���ʁia�^�j�v��Ԃ��֐��̌^�ł���B

## �t�@�C�����o��

�t�@�C�����o�͂̊֐�writeFile��readFile��IO�̒�`�𓖂Ă͂߂�Ǝ��̂悤�ɂȂ�B

��������t�@�C���ɏo�͂���֐�writeFile�̌^��FilePath -> String -> IO ()�ł���B
�t�@�C���p�X�ƕ�����������Ɏ���āA�u���E�ɑ΂��āA�������݌�̐��E��Ԃ��֐��v��Ԃ��B
���̏ꍇ�A���E���t�@�C���̏�ԂƎv���Ă��悢�B
�֐�writeFile�̓t�@�C���ɑ΂��ĕ�������㏑���ۑ�����i�ǋL��appendFile�ŏo����j�B

```
Prelude> :t writeFile
writeFile :: FilePath -> String -> IO ()
```

��������t�@�C������擾����֐�readFile�̌^��FilePath -> IO String�ł���B
�t�@�C���p�X�Ƃ������Ɏ���āA�u�v�Z�O�̐��E�ɑ΂��āu�v�Z��̐��E��String�^�̌v�Z���ʁv��Ԃ��֐��v��Ԃ��B
���̏ꍇ�A���E���t�@�C���̏�ԂƎv���Ă��悭�AreadFile�̓t�@�C���̏�Ԃ�ς��Ȃ��̂ŁA���E�ɂ��Ă͍P���I�ł���B

```
Prelude> :t readFile
readFile :: FilePath -> IO String
```

## �֐�fmap

�^IO a�͌^�N���XFunctor�ɑ����Ă���Afmap���g�����Ƃ��ł���B

```
*Main> let x = readFile "Item10-input.txt"
*Main> :t x
x :: IO String
*Main> fmap ("Hello " ++ ) x
"Hello Taro"
```

������("Hello " ++)��String -> String�^�̊֐��ł���A
�����ł�fmap�͂��̊֐���IO String�^��x�������Ɏ���āAIO String�^�̒l��߂����K�֐��ł���B

�^IO a�ɂ�����`fmap :: (a -> b) -> IO a -> IO b`�͎��̂悤�ɒ�`����Ă���B

```
instance Functor IO where
    fmap f m = \s -> let (t, x) = m s in (t, f x)
```

���{��ŏ����Ǝ��̂悤�ɂȂ�B
fmap��(a -> b)�^�̊֐�f��IO a�^�̒lm�������Ɏ�鍂�K�֐��ł���B
IO a�^��RealWorld -> (RealWorld, a)�^�̂��Ƃł������B
fmap��IO b�^�̒l�A�܂�RealWorld -> (RealWorld, b)�^�̊֐���߂��B
���̖߂����֐���
�us�ɑ΂���m s :: (RealWorld, a)��1�ڂ̗v�f��t�A2�ڂ̗v�f��x�Ƃ��āA�^�v��(t, f x)��߂��֐��v�ł���

```
fmap :: (a -> b) -> IO a -> IO b
fmap f m = \s -> (fst (m s), f snd (m s))
```

�̂悤�ɏ����������p�^�[���}�b�`�Ɋ���Ă��Ȃ��l�ɂ͂킩��₷����������Ȃ��B
���X�Am��\s -> (fst (m s), snd (m s))�Ȃ̂�����A
fmap f m��1�ڂ̗v�f�ɂ��Ă�m�Ɠ��l�ɖ߂��A2�ڂ̗v�f�ɂ��Ă̂�f����p�������l��߂��֐��ł���B

IO a�^�ɂ����āAfmap��trivial�ł���B
�������ɂ͉��������A���g�ɑ΂��č�p�����邾���̂��Ƃł���B

## �֐�(>>=)

�^IO a�͌^�N���XMonad�ɑ����Ă���A(>>=)���g�����Ƃ��ł���B
�^IO a�ɂ����ẮA(>>=)�̕����񎩖��ł���Afmap�����{���I�Ȗ������ʂ����iMaybe�ɂ����Ă�(>>=)����fmap���{���I�ł������j�B

�^IO a�ɂ�����`(>>=) :: IO a -> (a -> IO b) -> IO b`�͎��̂悤�ɒ�`����Ă���Ǝv���Ă悢�B

```
instance Monad IO where
m >>= f = \s -> let (t x) = m s 
                    (u y) = (f x) t
                    in (u y)
```

���{��ŏ����Ǝ��̂悤�ɂȂ�B
(>>=)��IO a�^�̒lm��(a -> IO b)�^�̊֐�f�������Ɏ�鍂�K�֐��ł���B
(>>=)��IO b�^�̒l�A�܂�RealWorld -> (RealWorld, b)�^�̊֐���߂��B
���̖߂����֐���
�us�ɑ΂���m s��1�ڂ̗v�f��t::RealWorld�A2�ڂ̗v�f��x::a�Ƃ���B
f x::IO b��RealWorld -> (RealWorld, b)�^�̊֐��ł��邩��A(f x) s��(RealWorld, b)�^�ƂȂ�B
���̃^�v��(u y)��߂��֐��v�ł���

```
(>>=) :: IO a -> (a -> IO b) -> IO b
m >>= f = \s -> (f snd (m s)) fst (m s)
```

�̂悤�ɏ����������p�^�[���}�b�`�Ɋ���Ă��Ȃ��l�ɂ͂킩��₷����������Ȃ��B
���E�̑�����������ƁA�����ɐ��Es������āA���Es�ɑ΂���m����p�������E��t�Ƃ��A���Et�ɑ΂���f x����p�������E��u�Ƃ��Ă���̂ŁA�����I�ł���B

```haskell:Item10-02.hs
main = 
  (readFile "Item10-input.txt") >>= \name -> writeFile "Item10-output.txt" ("Hello " ++ name)
```

����̈Ӗ��͎��̂悤�ɂȂ�B
(readFile "Item10-input.txt")�͐��Es������āA���Et��"Taro"�Ƃ����������Ԃ��֐��ł���B
���̕������`\name -> writeFile "Item10-output.txt" ("Hello " ++ name)`����p������ƁA
`writeFile "Item10-output.txt" ("Hello Taro") :: IO()`�ƂȂ�A�����t�ɍ�p�����A�t�@�C�����������񂾌�̐��Eu��߂��B
�܂�A������Ƃ��Ă�readFile�̒��g�����o���ĕϐ�name�ɑ������ė��p���A���E�i�����j�Ƃ��Ă͒����I�Ɏ��s���Ă���
�i���̗�̏ꍇ�AreadFile�̓t�@�C���̏�Ԃ�ς��Ȃ��̂ŁA���Es�Ɛ��Et�͓�����Ԃł��邪�j�B

���̊֐�(>>=)��p�ӂ��邱�Ƃɂ���āA���o�͂��s���֐������R�ɍ������邱�Ƃ��ł���B

## �֐�(>>)

�^�N���XMonad�̃C���X�^���X�ł���^�ɂ͎����I�Ɋ֐�(>>)��

```
(>>) :: Monad m => m a -> m b -> m b
m >> k = m >>= \_ -> k
```

�ɂ���Ē�`�����̂ł������B
IO�Ɍ��肷��Ǝ��̂悤�ɂȂ�B

```
(>>) :: IO a -> IO b -> IO b
m >>= f = \s -> let (t _) = m s 
                    (u y) = k t
                    in (u y)
```

���ߌ^����ɂ����钀���I���s�ɑ������邱�Ƃ��킩�邾�낤�B

```
*Main> let x = appendFile "Item10-output2.txt" "Hello, "
*Main> let y = appendFile "Item10-output2.txt" "World!"
*Main> x >> y
*Main> readFile "Item10-output2.txt"
"Hello, World!"
```

## �֐�join

�^�N���XMonad�ɑ�����^�ɂ��Ă͊֐�join���l���邱�Ƃ��ł���B

```
*Main> let join m = m >>= id
*Main> :t join
join :: Monad m => m (m b) -> m b
```

IO�ɂ�����֐�join�͎��̂悤�ɂȂ�B

```
join m = \s -> let (t x) = m s 
                    (u y) = x t
                    in (u y)
```

���Es�ɑ΂���m :: IO (IO a)����p�����Đ��Et�Ɩ߂�lx :: IO a��������B
����t�ɑ΂���x����p�����A���Eu�Ɩ߂�ly�𓾂�B
join m�͐��Es�ɑ΂��Ă��̂悤�ȃ^�v����߂��֐��ł���B

