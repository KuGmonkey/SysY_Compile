declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @ifWhile(){
B23:
  %t25 = alloca i32, align 4
  %t24 = alloca i32, align 4
  store i32 0, i32* %t24, align 4
  store i32 3, i32* %t25, align 4
  %t4 = load i32, i32* %t24, align 4
  %t5 = icmp eq i32 %t4, 5
  br i1 %t5, label %B26, label %B27
B26:                               	; preds = %B23, %B23
  br label %B31
B27:                               	; preds = %B23, %B23
  br label %B34
B28:                               	; preds = %B26, %B27
  %t22 = load i32, i32* %t25, align 4
  ret i32 %t22
B31:                               	; preds = %B26
  %t6 = load i32, i32* %t25, align 4
  %t7 = icmp eq i32 %t6, 2
  br i1 %t7, label %B29, label %B30
B34:                               	; preds = %B27
  %t14 = load i32, i32* %t24, align 4
  %t15 = icmp slt i32 %t14, 5
  br i1 %t15, label %B32, label %B33
B29:                               	; preds = %B31, %B31
  %t9 = load i32, i32* %t25, align 4
  %t10 = add i32 %t9, 2
  store i32 %t10, i32* %t25, align 4
  br i1 %t7, label %B31, label %B30
B30:                               	; preds = %B29, %B31, %B31
  %t12 = load i32, i32* %t25, align 4
  %t13 = add i32 %t12, 25
  store i32 %t13, i32* %t25, align 4
  br label %B28
B32:                               	; preds = %B34, %B34
  %t17 = load i32, i32* %t25, align 4
  %t18 = mul i32 %t17, 2
  store i32 %t18, i32* %t25, align 4
  %t20 = load i32, i32* %t24, align 4
  %t21 = add i32 %t20, 1
  store i32 %t21, i32* %t24, align 4
  br i1 %t15, label %B34, label %B33
B33:                               	; preds = %B32, %B34, %B34
  br label %B28
}
define i32 @main(){
B35:
  %t37 = call i32 @ifWhile()
  ret i32 %t37
}
