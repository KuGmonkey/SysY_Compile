declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @ifElse(){
B9:
  %t10 = alloca i32, align 4
  store i32 5, i32* %t10, align 4
  %t2 = load i32, i32* %t10, align 4
  %t3 = icmp eq i32 %t2, 5
  br i1 %t3, label %B11, label %B12
B11:                               	; preds = %B9, %B9
  store i32 25, i32* %t10, align 4
  br label %B13
B12:                               	; preds = %B9, %B9
  %t6 = load i32, i32* %t10, align 4
  %t7 = mul i32 %t6, 2
  store i32 %t7, i32* %t10, align 4
  br label %B13
B13:                               	; preds = %B11, %B12
  %t8 = load i32, i32* %t10, align 4
  ret i32 %t8
}
define i32 @main(){
B14:
  %t16 = call i32 @ifElse()
  ret i32 %t16
}
