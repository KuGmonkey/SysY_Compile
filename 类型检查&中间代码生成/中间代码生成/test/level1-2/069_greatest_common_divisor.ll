declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @fun(i32 %t24, i32 %t27){
B23:
  %t30 = alloca i32, align 4
  %t26 = alloca i32, align 4
  store i32 %t24, i32* %t26, align 4
  %t29 = alloca i32, align 4
  store i32 %t27, i32* %t29, align 4
  br label %B33
B33:                               	; preds = %B23
  %t3 = load i32, i32* %t29, align 4
  %t4 = icmp sgt i32 %t3, 0
  br i1 %t4, label %B31, label %B32
B31:                               	; preds = %B33, %B33
  %t6 = load i32, i32* %t26, align 4
  %t7 = load i32, i32* %t29, align 4
  %t8 = srem i32 %t6, %t7
  store i32 %t8, i32* %t30, align 4
  %t10 = load i32, i32* %t29, align 4
  store i32 %t10, i32* %t26, align 4
  %t12 = load i32, i32* %t30, align 4
  store i32 %t12, i32* %t29, align 4
  br i1 %t4, label %B33, label %B32
B32:                               	; preds = %B31, %B33, %B33
  %t13 = load i32, i32* %t26, align 4
  ret i32 %t13
}
define i32 @main(){
B34:
  %t37 = alloca i32, align 4
  %t36 = alloca i32, align 4
  %t35 = alloca i32, align 4
  %t39 = call i32 @getint()
  store i32 %t39, i32* %t35, align 4
  %t41 = call i32 @getint()
  store i32 %t41, i32* %t36, align 4
  %t20 = load i32, i32* %t35, align 4
  %t21 = load i32, i32* %t36, align 4
  %t43 = call i32 @fun(i32 %t20, i32 %t21)
  store i32 %t43, i32* %t37, align 4
  %t22 = load i32, i32* %t37, align 4
  call void @putint(i32 %t22)
  ret i32 0
}
