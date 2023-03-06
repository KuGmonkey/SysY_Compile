declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @fsqrt(i32 %t31){
B30:
  %t35 = alloca i32, align 4
  %t34 = alloca i32, align 4
  %t33 = alloca i32, align 4
  store i32 %t31, i32* %t33, align 4
  store i32 0, i32* %t34, align 4
  %t4 = load i32, i32* %t33, align 4
  %t5 = sdiv i32 %t4, 2
  store i32 %t5, i32* %t35, align 4
  br label %B38
B38:                               	; preds = %B30
  %t6 = load i32, i32* %t34, align 4
  %t7 = load i32, i32* %t35, align 4
  %t8 = sub i32 %t6, %t7
  %t9 = icmp ne i32 %t8, 0
  br i1 %t9, label %B36, label %B37
B36:                               	; preds = %B38, %B38
  %t11 = load i32, i32* %t35, align 4
  store i32 %t11, i32* %t34, align 4
  %t13 = load i32, i32* %t34, align 4
  %t14 = load i32, i32* %t33, align 4
  %t15 = load i32, i32* %t34, align 4
  %t16 = sdiv i32 %t14, %t15
  %t17 = add i32 %t13, %t16
  store i32 %t17, i32* %t35, align 4
  %t19 = load i32, i32* %t35, align 4
  %t20 = sdiv i32 %t19, 2
  store i32 %t20, i32* %t35, align 4
  br i1 %t9, label %B38, label %B37
B37:                               	; preds = %B36, %B38, %B38
  %t21 = load i32, i32* %t35, align 4
  ret i32 %t21
}
define i32 @main(){
B39:
  %t41 = alloca i32, align 4
  %t40 = alloca i32, align 4
  store i32 400, i32* %t40, align 4
  %t26 = load i32, i32* %t40, align 4
  %t43 = call i32 @fsqrt(i32 %t26)
  store i32 %t43, i32* %t41, align 4
  %t27 = load i32, i32* %t41, align 4
  call void @putint(i32 %t27)
  store i32 10, i32* %t41, align 4
  %t29 = load i32, i32* %t41, align 4
  call void @putch(i32 %t29)
  ret i32 0
}
