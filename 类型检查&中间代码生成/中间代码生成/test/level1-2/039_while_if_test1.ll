declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @whileIf(){
B19:
  %t21 = alloca i32, align 4
  %t20 = alloca i32, align 4
  store i32 0, i32* %t20, align 4
  store i32 0, i32* %t21, align 4
  br label %B24
B24:                               	; preds = %B19
  %t4 = load i32, i32* %t20, align 4
  %t5 = icmp slt i32 %t4, 100
  br i1 %t5, label %B22, label %B23
B22:                               	; preds = %B24, %B24
  %t6 = load i32, i32* %t20, align 4
  %t7 = icmp eq i32 %t6, 5
  br i1 %t7, label %B25, label %B26
B23:                               	; preds = %B22, %B24, %B24
  %t18 = load i32, i32* %t21, align 4
  ret i32 %t18
B25:                               	; preds = %B22, %B22
  store i32 25, i32* %t21, align 4
  br label %B27
B26:                               	; preds = %B22, %B22
  %t9 = load i32, i32* %t20, align 4
  %t10 = icmp eq i32 %t9, 10
  br i1 %t10, label %B28, label %B29
B27:                               	; preds = %B25, %B26
  %t16 = load i32, i32* %t20, align 4
  %t17 = add i32 %t16, 1
  store i32 %t17, i32* %t20, align 4
  br i1 %t5, label %B24, label %B23
B28:                               	; preds = %B26, %B26
  store i32 42, i32* %t21, align 4
  br label %B30
B29:                               	; preds = %B26, %B26
  %t13 = load i32, i32* %t20, align 4
  %t14 = mul i32 %t13, 2
  store i32 %t14, i32* %t21, align 4
  br label %B30
B30:                               	; preds = %B28, %B29
  br label %B27
}
define i32 @main(){
B31:
  %t33 = call i32 @whileIf()
  ret i32 %t33
}
