declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @deepWhileBr(i32 %t33, i32 %t36){
B32:
  %t48 = alloca i32, align 4
  %t43 = alloca i32, align 4
  %t39 = alloca i32, align 4
  %t35 = alloca i32, align 4
  store i32 %t33, i32* %t35, align 4
  %t38 = alloca i32, align 4
  store i32 %t36, i32* %t38, align 4
  %t4 = load i32, i32* %t35, align 4
  %t5 = load i32, i32* %t38, align 4
  %t6 = add i32 %t4, %t5
  store i32 %t6, i32* %t39, align 4
  br label %B42
B42:                               	; preds = %B32
  %t7 = load i32, i32* %t39, align 4
  %t8 = icmp slt i32 %t7, 75
  br i1 %t8, label %B40, label %B41
B40:                               	; preds = %B42, %B42
  store i32 42, i32* %t43, align 4
  %t11 = load i32, i32* %t39, align 4
  %t12 = icmp slt i32 %t11, 100
  br i1 %t12, label %B44, label %B45
B41:                               	; preds = %B40, %B42, %B42
  %t27 = load i32, i32* %t39, align 4
  ret i32 %t27
B44:                               	; preds = %B40, %B40
  %t14 = load i32, i32* %t39, align 4
  %t15 = load i32, i32* %t43, align 4
  %t16 = add i32 %t14, %t15
  store i32 %t16, i32* %t39, align 4
  %t17 = load i32, i32* %t39, align 4
  %t18 = icmp sgt i32 %t17, 99
  br i1 %t18, label %B46, label %B47
B45:                               	; preds = %B44, %B40, %B40
  br i1 %t8, label %B42, label %B41
B46:                               	; preds = %B44, %B44
  %t21 = load i32, i32* %t43, align 4
  %t22 = mul i32 %t21, 2
  store i32 %t22, i32* %t48, align 4
  %t23 = icmp eq i32 1, 1
  br i1 %t23, label %B49, label %B50
B47:                               	; preds = %B46, %B44, %B44
  br label %B45
B49:                               	; preds = %B46, %B46
  %t25 = load i32, i32* %t48, align 4
  %t26 = mul i32 %t25, 2
  store i32 %t26, i32* %t39, align 4
  br label %B50
B50:                               	; preds = %B49, %B46, %B46
  br label %B47
}
define i32 @main(){
B51:
  %t52 = alloca i32, align 4
  store i32 2, i32* %t52, align 4
  %t30 = load i32, i32* %t52, align 4
  %t31 = load i32, i32* %t52, align 4
  %t54 = call i32 @deepWhileBr(i32 %t30, i32 %t31)
  ret i32 %t54
}
