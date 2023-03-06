declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @enc(i32 %t31){
B30:
  %t33 = alloca i32, align 4
  store i32 %t31, i32* %t33, align 4
  %t1 = load i32, i32* %t33, align 4
  %t2 = icmp sgt i32 %t1, 25
  br i1 %t2, label %B34, label %B35
B34:                               	; preds = %B30, %B30
  %t4 = load i32, i32* %t33, align 4
  %t5 = add i32 %t4, 60
  store i32 %t5, i32* %t33, align 4
  br label %B36
B35:                               	; preds = %B30, %B30
  %t7 = load i32, i32* %t33, align 4
  %t8 = sub i32 %t7, 15
  store i32 %t8, i32* %t33, align 4
  br label %B36
B36:                               	; preds = %B34, %B35
  %t9 = load i32, i32* %t33, align 4
  ret i32 %t9
}
define i32 @dec(i32 %t38){
B37:
  %t40 = alloca i32, align 4
  store i32 %t38, i32* %t40, align 4
  %t11 = load i32, i32* %t40, align 4
  %t12 = icmp sgt i32 %t11, 85
  br i1 %t12, label %B41, label %B42
B41:                               	; preds = %B37, %B37
  %t14 = load i32, i32* %t40, align 4
  %t15 = sub i32 %t14, 59
  store i32 %t15, i32* %t40, align 4
  br label %B43
B42:                               	; preds = %B37, %B37
  %t17 = load i32, i32* %t40, align 4
  %t18 = add i32 %t17, 14
  store i32 %t18, i32* %t40, align 4
  br label %B43
B43:                               	; preds = %B41, %B42
  %t19 = load i32, i32* %t40, align 4
  ret i32 %t19
}
define i32 @main(){
B44:
  %t46 = alloca i32, align 4
  %t45 = alloca i32, align 4
  store i32 400, i32* %t45, align 4
  %t24 = load i32, i32* %t45, align 4
  %t48 = call i32 @enc(i32 %t24)
  store i32 %t48, i32* %t46, align 4
  %t26 = load i32, i32* %t46, align 4
  %t50 = call i32 @dec(i32 %t26)
  store i32 %t50, i32* %t46, align 4
  %t27 = load i32, i32* %t46, align 4
  call void @putint(i32 %t27)
  store i32 10, i32* %t46, align 4
  %t29 = load i32, i32* %t46, align 4
  call void @putch(i32 %t29)
  ret i32 0
}
