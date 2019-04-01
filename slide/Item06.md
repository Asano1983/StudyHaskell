
# Item 6 �f�[�^����

## �㐔�I�f�[�^�^��data�錾

data�錾���g�����Ƃɂ���ĐV�����f�[�^�^�����[�U�[��`�ł���B
�Ⴆ�΁A�񋓌^�����[�U�[��`����Ƃ��ɂ͎��̂悤�ɂ���B

```
Prelude> data Animal = Cat | Dog | Monkey deriving Show
Prelude> Cat
Cat
Prelude> :t Cat
Cat :: Animal
Prelude> :t [Cat, Cat, Dog]
[Cat, Cat, Dog] :: [Animal]
```

����Cat�ADog�AMonkey��l�R���X�g���N�^�Ƃ����B
|�͕����̒l�R���X�g���N�^����OR�Ō��т���������ʂ����Ă���B
deriving Show���s�����Ƃɂ���āA�^Animal�͌^�N���XShow�ɑ�����^�ƂȂ�A������Ƃ��ďo�͂��邱�Ƃ��ł���B

�l�R���X�g���N�^�Ɉ����̌^���w�肷�邱�Ƃ��ł���B
�����p���āAC����̋��p�́iunion�j�̂悤�Ɏg�����Ƃ��ł���B

```
Prelude> data Number = Integer Integer | Double Double
Prelude> :t Integer
Integer :: Integer -> Number
Prelude> :t Double
Double :: Double -> Number
Prelude> :t Integer 10
Integer 10 :: Number
Prelude> :t Double 3.14
Double 3.14 :: Number
```

��̃R�[�h�ł͒l�R���X�g���N�^�̖��O��Ԃƌ^�R���X�g���N�^�̖��O��Ԃ��Ɨ����Ă��邱�Ƃ𗘗p���Ă���
Integer��Double�Ƃ������O�̒l�R���X�g���N�^���`����̂̓v���N�e�B�X�Ƃ��ėǂ��Ȃ����A
���[�U�[��`�^�ɑ΂��čs�����Ƃ͂��邾�낤�B
�܂��A�l�R���X�g���N�^�͌^���Ɠ��l�ɑ啶���Ŏn�߂�Ȃ���΂Ȃ�Ȃ��B

�l�R���X�g���N�^�ɕ����̈����̌^���w�肵�A���ό^���`���邱�Ƃ��ł���B
�ȉ��ɒ�`����郆�[�U�[��`�^Point�͒��ό^�ł���B

```
Prelude> data Point = Point Integer Integer deriving Show
Prelude> :t Point
Point :: Integer -> Integer -> Point
Prelude> :t Point 10 20
Point 10 20 :: Point
```

data�̌���Point�͌^���A�����̌���Point�͒l�R���X�g���N�^���ł���B
�l�R���X�g���N�^��1�ł���΁A�^���Ɠ������O��p���邱�Ƃ���ʓI�ł���B

�ȏ�̂悤��data�錾�ɂ���Ē�`�����f�[�^�^��㐔�I�f�[�^�^�Ƃ����B
���ό^�A���a�^�������T�O�ł���AC����̗񋓌^�⋤�p�́A�\���̂ȂǂɎ����T�O�ł���B

�l�R���X�g���N�^�͊֐��ɔ��ɂ悭���Ă��邪�A
���������Ȃ��Ă��悢���ƁA����ȏ�A�Ȗ񂳂�邱�Ƃ��Ȃ����ƂȂǂ̓_�ɂ����Ċ֐��ƈقȂ�B

## ���R�[�h�\��

���R�[�h�Ƃ̓t�B�[���h���x���̕t�����f�[�^�^�̂��Ƃł���B
���R�[�h�\�����g�����Ƃɂ���ă��R�[�h�����[�U�[��`���邱�Ƃ��ł���B

```
Prelude> :{
Prelude| data Person = Person { name :: String
Prelude|                      , age :: Int } deriving Show
Prelude| :}
Prelude> :t Person
Person :: String -> Int -> Person
Prelude> :t Person "Taro" 25
Person "Taro" 25 :: Person
Prelude> :t name
name :: Person -> String
Prelude> :t age
age :: Person -> Int
Prelude> let x = Person "Taro" 25
Prelude> name x
"Taro"
Prelude> age x
25
```

���̂Ƃ��Aname :: Person -> String�̂悤��getter���\�b�h��������������A
�t�B�[���h�̒l��name x�̂悤�Ɏ��o�����Ƃ��ł���B

�܂��A�ꕔ�̃t�B�[���h��ύX�����V�������R�[�h�𐶐����邱�Ƃ��ł���B
���̂Ƃ��A���̃��R�[�h�̒l�͏����������Ȃ��B

```
Prelude> let y = x { age = 26 }
Prelude> y
Person {name = "Taro", age = 26}
Prelude> x
Person {name = "Taro", age = 25}
```

C����̍\���̂Ɏ��Ă��邪�A�j��I������s��setter���\�b�h�͂Ȃ��B

�܂��A�t�B�[���h�ɒl��^�����ɐ������邱�Ƃ��\�ł���i�x���͔�������j�B
���ۂɂ��̒l���Ăяo���܂ł͗�O���������Ȃ�
�iOCaml�̏ꍇ�͐������ɃG���[�ɂȂ�j�B

```
Prelude> let z = Person {name = "Jiro"}

<interactive>:23:9: Warning:
    Fields of �ePerson�f not initialised: age
    In the expression: Person {name = "Jiro"}
    In an equation for �ez�f: z = Person {name = "Jiro"}
Prelude> name z
"Jiro"
Prelude> age z
*** Exception: <interactive>:23:9-30: Missing field in record construction age
```

## �p�^�[���}�b�`

�t�B�[���h�̒l�����o���Ƃ��A�֐�name�̑���Ƀ��R�[�h�̃p�^�[���}�b�`���g�����Ƃ��ł���B

```
Prelude> let Person {name = a, age = b} = x
Prelude> a
"Taro"
Prelude> b
25
Prelude> let Person {age = c} = y
Prelude> c
26
```

�p�^�[���}�b�`�̕����\���͂͗y���ɍ����B
���R�[�h�łȂ��㐔�I�f�[�^�^�ɂ��āA�p�^�[���}�b�`���g�p���邱�Ƃ��ł���B

```
Prelude> data Point = Point Integer Integer deriving Show
Prelude> let p = Point 10 20
Prelude> p
Point 10 20
Prelude> let Point px py = p
Prelude> px
10
Prelude> py
20
```

## �����I�f�[�^�^

data�錾�ɂ����Č^��������邱�Ƃ��ł��A�����I�f�[�^�^���`���邱�Ƃ��ł���

```
Prelude> data Vector a = Vector a a a deriving Show
Prelude> :t Vector
Vector :: a -> a -> a -> Vector a
Prelude> :t Vector "Cat" "Dog" "Lion"
Vector "Cat" "Dog" "Lion" :: Vector [Char]
```

�����I�f�[�^�^��C++�̃N���X�e���v���[�g�Ɏ��Ă���B
���̂Ƃ��Adata�̌��ɂ���Vector�͌^���ł͂Ȃ��A�^�R���X�g���N�^���ł���i�J�C���h��* -> *�j�B

�g�ݍ��݂̌^�R���X�g���N�^�̗�Ƃ��āA[]����������B
[]�͌^a���烊�X�g�̌^[a]�𐶐�����^�R���X�g���N�^�ł���B

�f�[�^�錾�ɂ͌^�N���X�����t���邱�Ƃ��ł��Ȃ��iGHC 7.2.1�ȍ~�Ŕ񐄏��AHaskell 2012�ō폜�j�B
�֐��̌^�����Ɍ^�N���X�����t����Ώ\���ł���B

## �A�N�Z�X�E�R���g���[��

Haskell�̌^�V�X�e���ł̓A�N�Z���E�R���g���[�����s�����Ƃ͂ł��Ȃ��B
�A�N�Z�X�E�R���g���[�����s���̂̓��W���[���̖�ڂł���B
Haskell�ɂ����āA�^�̒�`�Ɗ֐��̒�`�͓Ɨ����Ă���B

Haskell�̃��W���[���ɂ����ẮA���W���[���̐擪�ŃG�N�X�|�[�g����֐���R���X�g���N�^�̃��X�g���L�q����B
�֐��������̃��X�g�ɋL�q�����public�Ȃ��̂ɂȂ�A�L�q���Ȃ����private�Ȃ��̂ɂȂ�B

�����p���āA���[�U�[��`�̃f�[�^�^�Ɋւ���֐���R���X�g���N�^�̃A�N�Z�X�E�R���g���[�����s�����Ƃ��ł���B
�Ⴆ�΁A�l�R���X�g���N�^���B�����āA�����p�̃w���p�֐��݂̂����J���邱�Ƃ��\�ł���B

