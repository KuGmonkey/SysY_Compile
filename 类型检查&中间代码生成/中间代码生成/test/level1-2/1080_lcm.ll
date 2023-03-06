declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
  @n = global i32 0, align 4
define i32 @gcd(i32 %t46, i32 %t49){
B45:
  %t55 = alloca i32, align 4
  %t54 = alloca i32, align 4
  %t53 = alloca i32, align 4
  %t52 = alloca i32, align 4
  %t48 = alloca i32, align 4
  store i32 %t46, i32* %t48, align 4
  %t51 = alloca i32, align 4
  store i32 %t49, i32* %t51, align 4
  %t6 = load i32, i32* %t48, align 4
  store i32 %t6, i32* %t52, align 4
  %t8 = load i32, i32* %t51, align 4
  store i32 %t8, i32* %t53, align 4
  %t11 = load i32, i32* %t48, align 4
  %t12 = load i32, i32* %t51, align 4
  %t13 = icmp slt i32 %t11, %t12
  br i1 %t13, label %B56, label %B57
B56:                               	; preds = %B45, %B45
  %t15 = load i32, i32* %t48, align 4
  store i32 %t15, i32* %t54, align 4
  %t17 = load i32, i32* %t51, align 4
  store i32 %t17, i32* %t48, align 4
  %t19 = load i32, i32* %t54, align 4
  store i32 %t19, i32* %t51, align 4
  br label %B57
B57:                               	; preds = %B56, %B45, %B45
  %t21 = load i32, i32* %t48, align 4
  %t22 = load i32, i32* %t51, align 4
  %t23 = srem i32 %t21, %t22
  store i32 %t23, i32* %t55, align 4
  br label %B60
B60:                               	; preds = %B57
  %t24 = load i32, i32* %t55, align 4
  %t25 = icmp ne i32 %t24, 0
  br i1 %t25, label %B58, label %B59
B58:                               	; preds = %B60, %B60
  %t27 = load i32, i32* %t51, align 4
  store i32 %t27, i32* %t48, align 4
  %t29 = load i32, i32* %t55, align 4
  store i32 %t29, i32* %t51, align 4
  %t31 = load i32, i32* %t48, align 4
  %t32 = load i32, i32* %t51, align 4
  %t33 = srem i32 %t31, %t32
  store i32 %t33, i32* %t55, align 4
  br i1 %t25, label %B60, label %B59
B59:                               	; preds = %B58, %B60, %B60
  %t34 = load i32, i32* %t52, align 4
  %t35 = load i32, i32* %t53, align 4
  %t36 = mul i32 %t34, %t35
  %t37 = load i32, i32* %t51, align 4
  %t38 = sdiv i32 %t36, %t37
  ret i32 %t38
}
define i32 @main(){
B61:
  %t63 = alloca i32, align 4
  %t62 = alloca i32, align 4
  %t65 = call i32 @getint()
  store i32 %t65, i32* %t62, align 4
  %t67 = call i32 @getint()
  store i32 %t67, i32* %t63, align 4
  %t43 = load i32, i32* %t62, align 4
  %t44 = load i32, i32* %t63, align 4
  %t69 = call i32 @gcd(i32 %t43, i32 %t44)
  ret i32 %t69
}
