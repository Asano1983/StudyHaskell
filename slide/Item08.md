
# Item 8 ��O

## ��O

Haskell�ł�Nothing��Left���g���đ��E�o�ł���B

Nothing��Maybe a�^�̒l�ł���A���炩�̌v�Z�̎��s���Ӗ�����B

```
Prelude> :t Nothing
Nothing :: Maybe a
```

Left��Either a b�^�̒l��߂��֐��ł���A�G���[���b�Z�[�W�Ȃǂ��������邱�Ƃ��ł���B

```
Prelude> :t Left
Left :: a -> Either a b
```

## do�L�@�ɂ��g�p��1

do�L�@�iItem 11�Ō�q�j��p���āA���ߌ^�v���O���~���O���G�~�����[�g���Ă݂�B

```
Prelude> :{
Prelude| do
Prelude|     let x = 3 + 5
Prelude|     return x
Prelude| :}
8
```

����do�L�@�͒P�ɏォ�璀���I���s���s���Ă���B

```
Prelude> :{
Prelude| do
Prelude|     let x = 3 + 5
Prelude|     Nothing
Prelude|     return x
Prelude| :}
Nothing
```

do�L�@��2�s�ڂł�Nothing�iMaybe Int�^�j�����s���A���E�o���Ă���B
3�s�ڂ�return x�͎��s����Ȃ��B

```
Prelude> :{
Prelude| do
Prelude|     let x = 3 + 5
Prelude|     Left("Error")
Prelude|     return x
Prelude| :}
Left "Error"
```

do�L�@��2�s�ڂł�Left("Error")�iEither String Int�^�j�����s���A���E�o���Ă���B
3�s�ڂ�return x�͎��s����Ȃ��B
Left���g�����Ƃɂ���āA�P�Ɏ��s�������Ƃ�`���邾���ł͂Ȃ��A
�G���[���b�Z�[�W�Ȃǂ̏���t�������邱�Ƃ��ł���B

