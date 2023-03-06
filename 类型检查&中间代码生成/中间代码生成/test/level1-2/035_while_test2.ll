declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @FourWhile(){
B44:
  %t48 = alloca i32, align 4
  %t47 = alloca i32, align 4
  %t46 = alloca i32, align 4
  %t45 = alloca i32, align 4
  store i32 5, i32* %t45, align 4
  store i32 6, i32* %t46, align 4
  store i32 7, i32* %t47, align 4
  store i32 10, i32* %t48, align 4
  br label %B51
B51:                               	; preds = %B44
  %t8 = load i32, i32* %t45, align 4
  %t9 = icmp slt i32 %t8, 20
  br i1 %t9, label %B49, label %B50
B49:                               	; preds = %B51, %B51
  %t11 = load i32, i32* %t45, align 4
  %t12 = add i32 %t11, 3
  store i32 %t12, i32* %t45, align 4
  br label %B54
B50:                               	; preds = %B49, %B51, %B51
  %t37 = load i32, i32* %t45, align 4
  %t38 = load i32, i32* %t46, align 4
  %t39 = load i32, i32* %t48, align 4
  %t40 = add i32 %t38, %t39
  %t41 = add i32 %t37, %t40
  %t42 = load i32, i32* %t47, align 4
  %t43 = add i32 %t41, %t42
  ret i32 %t43
B54:                               	; preds = %B49
  %t13 = load i32, i32* %t46, align 4
  %t14 = icmp slt i32 %t13, 10
  br i1 %t14, label %B52, label %B53
B52:                               	; preds = %B54, %B54
  %t16 = load i32, i32* %t46, align 4
  %t17 = add i32 %t16, 1
  store i32 %t17, i32* %t46, align 4
  br label %B57
B53:                               	; preds = %B52, %B54, %B54
  %t35 = load i32, i32* %t46, align 4
  %t36 = sub i32 %t35, 2
  store i32 %t36, i32* %t46, align 4
  br i1 %t9, label %B51, label %B50
B57:                               	; preds = %B52
  %t18 = load i32, i32* %t47, align 4
  %t19 = icmp eq i32 %t18, 7
  br i1 %t19, label %B55, label %B56
B55:                               	; preds = %B57, %B57
  %t21 = load i32, i32* %t47, align 4
  %t22 = sub i32 %t21, 1
  store i32 %t22, i32* %t47, align 4
  br label %B60
B56:                               	; preds = %B55, %B57, %B57
  %t32 = load i32, i32* %t47, align 4
  %t33 = add i32 %t32, 1
  store i32 %t33, i32* %t47, align 4
  br i1 %t14, label %B54, label %B53
B60:                               	; preds = %B55
  %t23 = load i32, i32* %t48, align 4
  %t24 = icmp slt i32 %t23, 20
  br i1 %t24, label %B58, label %B59
B58:                               	; preds = %B60, %B60
  %t26 = load i32, i32* %t48, align 4
  %t27 = add i32 %t26, 3
  store i32 %t27, i32* %t48, align 4
  br i1 %t24, label %B60, label %B59
B59:                               	; preds = %B58, %B60, %B60
  %t29 = load i32, i32* %t48, align 4
  %t30 = sub i32 %t29, 1
  store i32 %t30, i32* %t48, align 4
  br i1 %t19, label %B57, label %B56
}
define i32 @main(){
B61:
  %t63 = call i32 @FourWhile()
  ret i32 %t63
}
