
## Item 9 �^�N���X

### �^�N���XShow

�^�N���XShow�͕�����Ƃ��ďo�͂ł���^�̏W���ł���B
deriving Show��������instance Show���邱�Ƃɂ���āA
show�֐������[�U�[��`���邱�Ƃ��ł���B

```
Prelude> data Animal = Cat | Dog | Monkey
Prelude> :{
Prelude| instance Show Animal where
Prelude|     show Cat = "CAT"
Prelude|     show Dog = "DOG"
Prelude|     show Monkey = "MONKEY"
Prelude| :}
Prelude> Cat
CAT
Prelude> Dog
DOG
```

�������������show�֐��ŏ\���ł���Ƃ���deriving Show�Ŏ������o����΂悢�B
�܂��A�^�N���XShow�̃C���X�^���X�ɂȂ�΁A
showsPrec��showList�Ȃǂ���`�����Ɏg�����Ƃ��ł���B

### �^�N���XEq

�^�N���XEq�̒�`��

```
class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool
    x == y = not (x /= y)
    x /= y = not (x == y)
```

�̂悤�ɂȂ��Ă���A
deriving Eq���邩�A
instance Eq���Ċ֐�(==)���֐�(/=)�̂����ꂩ���`����Ό^�N���XEq�̃C���X�^���X�ƂȂ�B

### �^�N���XOrd

�^�N���XOrd�͏����t���\�Ȍ^�̏W���ł���B
�^�N���XOrd�̒�`��

```
class Eq a => Ord a where
  compare :: a -> a -> Ordering
  (<) :: a -> a -> Bool
  (<=) :: a -> a -> Bool
  (>) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  max :: a -> a -> a
  min :: a -> a -> a
  -- ���낢��f�t�H���g�����������Ă���
```

�̂悤�ɂȂ��Ă���B
�^�N���XOrd�ɑ����邽�߂ɂ͌^�N���XEq�̃C���X�^���X�ł���K�v������B
�^�N���XEq�̃C���X�^���X�ɑ΂��āA�֐�compare���֐�(<=)���`����Ό^�N���XOrd�̃C���X�^���X�ƂȂ�B
compare���`���邱�Ƃ̕��������I�ł��邱�Ƃ������B

### �A�h�z�b�N����

��q�̂悤�ɂ���N���X�^�ɑ�����f�[�^�^���`����ۂɁA
�K�v�Ȋ֐���Ǝ��ɒ�`���邱�Ƃ��ł���B
���̂��߁A�Ⴆ�΁Ashow :: Show a => a -> String��1�̊֐��ł��邪�A
�^���Ƃ̎����Ƀf�B�X�p�b�`���邱�Ƃ��ł��Ă���B
���̂悤�ɃN���X�^�𗘗p���邱�ƂŃA�h�z�b�N�������������邱�Ƃ��ł���B

C++��Java�̃I�[�o�[���C�h�Ɏ��Ă��Ȃ����Ȃ����A�N���X�^�̓N���X�ł͂Ȃ����Ƃɒ��ӂ��悤�B
�����Č����΁AC++�̊֐��e���v���[�g�̃I�[�o�[���[�h�ɋ߂��B

