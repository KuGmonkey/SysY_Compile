declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @ifElseIf(){
B30:
  %t32 = alloca i32, align 4
  %t31 = alloca i32, align 4
  store i32 5, i32* %t31, align 4
  store i32 10, i32* %t32, align 4
  %t4 = load i32, i32* %t31, align 4
  %t5 = icmp eq i32 %t4, 6
  br i1 %t5, label %B33, label %B36
B33:                               	; preds = %B30, %B30, %B36
  %t9 = load i32, i32* %t31, align 4
  ret i32 %t9
  br label %B35
B34:                               	; preds = %B30, %B36
  %t10 = load i32, i32* %t32, align 4
  %t11 = icmp eq i32 %t10, 10
  br i1 %t11, label %B40, label %B38
B36:                               	; preds = %B30
  %t6 = load i32, i32* %t32, align 4
  %t7 = icmp eq i32 %t6, 11
  br i1 %t7, label %B33, label %B34
B35:                               	; preds = %B33, %B34
  %t29 = load i32, i32* %t31, align 4
  ret i32 %t29
B37:                               	; preds = %B34, %B40
  store i32 25, i32* %t31, align 4
  br label %B39
B38:                               	; preds = %B34, %B34, %B40
  %t16 = load i32, i32* %t32, align 4
  %t17 = icmp eq i32 %t16, 10
  br i1 %t17, label %B44, label %B42
B40:                               	; preds = %B34, %B34
  %t12 = load i32, i32* %t31, align 4
  %t13 = icmp eq i32 %t12, 1
  br i1 %t13, label %B37, label %B38
B39:                               	; preds = %B37, %B38
  br label %B35
B41:                               	; preds = %B38, %B44
  %t23 = load i32, i32* %t31, align 4
  %t24 = add i32 %t23, 15
  store i32 %t24, i32* %t31, align 4
  br label %B43
B42:                               	; preds = %B38, %B38, %B44
  %t26 = load i32, i32* %t31, align 4
  %t46 = zext i1 %t26 to i32
  %t27 = add i32 0, %t46
  %t47 = zext i1 %t27 to i32
  %t28 = sub i32 0, %t47
  store i32 %t28, i32* %t31, align 4
  br label %B43
B44:                               	; preds = %B38, %B38
  %t18 = load i32, i32* %t31, align 4
  %t45 = zext i1 5 to i32
  %t19 = sub i32 0, %t45
  %t20 = icmp eq i32 %t18, %t19
  br i1 %t20, label %B41, label %B42
B43:                               	; preds = %B41, %B42
  br label %B39
}
define i32 @main(){
B48:
  %t50 = call i32 @ifElseIf()
  call void @putint(i32 %t50)
  ret i32 0
}
