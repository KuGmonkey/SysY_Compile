declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @if_if_Else(){
B13:
  %t15 = alloca i32, align 4
  %t14 = alloca i32, align 4
  store i32 5, i32* %t14, align 4
  store i32 10, i32* %t15, align 4
  %t4 = load i32, i32* %t14, align 4
  %t5 = icmp eq i32 %t4, 5
  br i1 %t5, label %B16, label %B17
B16:                               	; preds = %B13, %B13
  %t6 = load i32, i32* %t15, align 4
  %t7 = icmp eq i32 %t6, 10
  br i1 %t7, label %B19, label %B20
B17:                               	; preds = %B13, %B13
  %t10 = load i32, i32* %t14, align 4
  %t11 = add i32 %t10, 15
  store i32 %t11, i32* %t14, align 4
  br label %B18
B18:                               	; preds = %B16, %B17
  %t12 = load i32, i32* %t14, align 4
  ret i32 %t12
B19:                               	; preds = %B16, %B16
  store i32 25, i32* %t14, align 4
  br label %B20
B20:                               	; preds = %B19, %B16, %B16
  br label %B18
}
define i32 @main(){
B21:
  %t23 = call i32 @if_if_Else()
  ret i32 %t23
}
