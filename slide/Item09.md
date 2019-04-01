
# Item 9 do�L�@

## do�L�@

do�L�@��p����ƁAJust 16 >>= div2 >>= div2 >>= div2�̑���Ɏ��̂悤�ɏ������Ƃ��ł���B

```
Prelude> :{
Prelude| do
Prelude|   x <- Just 16
Prelude|   y <- div2 x
Prelude|   z <- div2 y
Prelude|   div2 z
Prelude| :}
Just 2
```

�����������ߌ^����ɂ����钀�����s���������Ă���悤�Ɍ����邪�A
�����>>=���g�����R�[�h�̃V���^�b�N�X�E�V���K�[�ł���B
do�L�@�ɂ����ẮA���s���������ߕ����ォ�珇�ɋL�q���邱�Ƃ��ł��A
Maybe a�^�̒l�i�����̕t�����l�j�ɑ΂��ẮA<-�Œ��g�����o�����Ƃ��ł���B
�P��a�^�̒l�i�����̕t���Ă��Ȃ��l�j�ɑ΂��ẮA�]���ʂ�let�Ŏ󂯂�΂悢�B

```
Prelude> :{
Prelude| do
Prelude|   let x = 16
Prelude|   y <- div2 x
Prelude|   z <- div2 y
Prelude|   div2 z
Prelude| :}
Just 2
```

�r���Ōv�Z�����s����ꍇ��Nothing��Ԃ��B
���ߌ^����ɂ����ė�O�𓊂��邱�Ƃɑ�������B

```
Prelude> :{
Prelude| do
Prelude|   let x = 13
Prelude|   y <- div2 x
Prelude|   z <- div2 y
Prelude|   div2 z
Prelude| :}
Nothing
```

## do�L�@�̑�G�c�ȉ���

do�L�@�͑�G�c�ɂ͎��̃��[���ŉ��߂����悤�ȃV���^�b�N�X�E�V���K�[�ł���B

1. do {e} �� e
1. do {e; es} �� e >> do {es}
1. do {let decls; es} �� let decls in do {es}
1. do {p <- e; es} �� e >>= \p -> es

�u\p -> es�v��p�ɑ΂���es��Ԃ������_���i�����֐��j�ł���B
�ȒP�ȗ�Ő�������B

```
Prelude> :{
Prelude| do
Prelude|   div2 10
Prelude|   div2 20
Prelude| :}
Just 10
```

���̃R�[�h��div2 10 >> div2 20�Ɖ��߂����B
�O�҂̌v�Z�͐�������̂ŁA��҂̌v�Z���ʂł���Just 10��߂��B

```
Prelude> :{
Prelude| do
Prelude|   div2 13
Prelude|   div2 20
Prelude| :}
Nothing
```

���̃R�[�h��div2 13 >> div2 20�Ɖ��߂����B
�O�҂̌v�Z�����s����̂ŁANothing��߂����ƂɂȂ�B

```
Prelude> :{
Prelude| do
Prelude|   let x = 16
Prelude|   div2 x
Prelude| :}
Just 8
```

���̃R�[�h��let x = 16 in div2 x�Ɖ��߂����̂ŁAJust 8��߂����ƂɂȂ�B

```
Prelude> :{
Prelude| do
Prelude|  x <- Just 16
Prelude|  div2 x
Prelude| :}
Just 8
```

���̃R�[�h��Just 16 >>= \x -> div2 x �Ɖ��߂����̂ŁAJust 8��߂����ƂɂȂ�B

## do�L�@�̐��m�ȉ���

do�L�@�͐��m�ɂ͎��̃��[���ŉ��߂����悤�ȃV���^�b�N�X�E�V���K�[�ł���B

1. do {e} �� e
1. do {e; es} �� e >> do {es}
1. do {let decls; es} �� let decls in do {es}
1. do {p <- e; es} �� let ok p = do {es} ; ok _ = fail "..." in e >>= ok

�Ⴂ��4�Ԗڂɂ���B
1�s�ɏ����Ɠǂ݂ɂ����̂ōČf���邪�Aok�̒�`�ɂ̓p�^�[���}�b�`���g�p���Ă���B

```
let ok p = do {es} 
    ok _ = fail "..."
  in e >>= ok
```

�p�^�[���}�b�`�����������Ƃ��ɂ�\p -> es���g���Ă�ok���g���Ă��������Ƃł��邪�A
�p�^�[���}�b�`�����s�����Ƃ��Ɋ֐�fail���Ăяo���_���قȂ��Ă���B

�֐�fail�͌^�N���XMonad�̃C���X�^���X�ł���^�ɑ΂��Ē�`����Ă���֐��ŁA
��{�I�ɂ́i�I�[�o�[���C�h���Ȃ���΁j��O�𓊂��邾���̊֐��ł���B

```
Prelude> :t fail
fail :: Monad m => String -> m a
Prelude> fail "..."
*** Exception: user error (...)
```

## Monad�̖���

���̂悤�Ɍ^�N���XMonad�̃C���X�^���X�ł���悤�Ȍ^�ɂ��ẮA
do�L�@��p���邱�Ƃ��ł��A���ߌ^����ɂ����閽�ߓI�L�q���G�~�����[�g���邱�Ƃ��ł���B

Maybe�͖��ߌ^����ɂ������O���G�~�����[�g���Ă��邪�A
��q����IO�͓��o�͂��AState�͏�Ԃɑ΂���j��I������G�~�����[�g����B
���̂悤��Haskell�͏����֐��^����ł���A����p����������ؔF�߂Ȃ����A
�^�N���XMonad�ɑ�����^���g�����Ƃɂ���āA���ߌ^����ɂ����镛��p�����悤�Ȗ��ߓI�L�q�Ɠ����̂��Ƃ��G�~�����[�g�ł���B

