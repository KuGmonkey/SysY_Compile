declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
  @g = global i32 0, align 4
  @h = global i32 0, align 4
  @f = global i32 0, align 4
  @e = global i32 0, align 4
define i32 @EightWhile(){
B92:
  %t96 = alloca i32, align 4
  %t95 = alloca i32, align 4
  %t94 = alloca i32, align 4
  %t93 = alloca i32, align 4
  store i32 5, i32* %t93, align 4
  store i32 6, i32* %t94, align 4
  store i32 7, i32* %t95, align 4
  store i32 10, i32* %t96, align 4
  br label %B99
B99:                               	; preds = %B92
  %t12 = load i32, i32* %t93, align 4
  %t13 = icmp slt i32 %t12, 20
  br i1 %t13, label %B97, label %B98
B97:                               	; preds = %B99, %B99
  %t15 = load i32, i32* %t93, align 4
  %t16 = add i32 %t15, 3
  store i32 %t16, i32* %t93, align 4
  br label %B102
B98:                               	; preds = %B97, %B99, %B99
  %t73 = load i32, i32* %t93, align 4
  %t74 = load i32, i32* %t94, align 4
  %t75 = load i32, i32* %t96, align 4
  %t76 = add i32 %t74, %t75
  %t77 = add i32 %t73, %t76
  %t78 = load i32, i32* %t95, align 4
  %t79 = add i32 %t77, %t78
  %t80 = load i32, i32* @e, align 4
  %t81 = load i32, i32* %t96, align 4
  %t82 = add i32 %t80, %t81
  %t83 = load i32, i32* @g, align 4
  %t84 = sub i32 %t82, %t83
  %t85 = load i32, i32* @h, align 4
  %t86 = add i32 %t84, %t85
  %t87 = sub i32 %t79, %t86
  ret i32 %t87
B102:                               	; preds = %B97
  %t17 = load i32, i32* %t94, align 4
  %t18 = icmp slt i32 %t17, 10
  br i1 %t18, label %B100, label %B101
B100:                               	; preds = %B102, %B102
  %t20 = load i32, i32* %t94, align 4
  %t21 = add i32 %t20, 1
  store i32 %t21, i32* %t94, align 4
  br label %B105
B101:                               	; preds = %B100, %B102, %B102
  %t71 = load i32, i32* %t94, align 4
  %t72 = sub i32 %t71, 2
  store i32 %t72, i32* %t94, align 4
  br i1 %t13, label %B99, label %B98
B105:                               	; preds = %B100
  %t22 = load i32, i32* %t95, align 4
  %t23 = icmp eq i32 %t22, 7
  br i1 %t23, label %B103, label %B104
B103:                               	; preds = %B105, %B105
  %t25 = load i32, i32* %t95, align 4
  %t26 = sub i32 %t25, 1
  store i32 %t26, i32* %t95, align 4
  br label %B108
B104:                               	; preds = %B103, %B105, %B105
  %t68 = load i32, i32* %t95, align 4
  %t69 = add i32 %t68, 1
  store i32 %t69, i32* %t95, align 4
  br i1 %t18, label %B102, label %B101
B108:                               	; preds = %B103
  %t27 = load i32, i32* %t96, align 4
  %t28 = icmp slt i32 %t27, 20
  br i1 %t28, label %B106, label %B107
B106:                               	; preds = %B108, %B108
  %t30 = load i32, i32* %t96, align 4
  %t31 = add i32 %t30, 3
  store i32 %t31, i32* %t96, align 4
  br label %B111
B107:                               	; preds = %B106, %B108, %B108
  %t65 = load i32, i32* %t96, align 4
  %t66 = sub i32 %t65, 1
  store i32 %t66, i32* %t96, align 4
  br i1 %t23, label %B105, label %B104
B111:                               	; preds = %B106
  %t32 = load i32, i32* @e, align 4
  %t33 = icmp sgt i32 %t32, 1
  br i1 %t33, label %B109, label %B110
B109:                               	; preds = %B111, %B111
  %t35 = load i32, i32* @e, align 4
  %t36 = sub i32 %t35, 1
  store i32 %t36, i32* @e, align 4
  br label %B114
B110:                               	; preds = %B109, %B111, %B111
  %t62 = load i32, i32* @e, align 4
  %t63 = add i32 %t62, 1
  store i32 %t63, i32* @e, align 4
  br i1 %t28, label %B108, label %B107
B114:                               	; preds = %B109
  %t37 = load i32, i32* @f, align 4
  %t38 = icmp sgt i32 %t37, 2
  br i1 %t38, label %B112, label %B113
B112:                               	; preds = %B114, %B114
  %t40 = load i32, i32* @f, align 4
  %t41 = sub i32 %t40, 2
  store i32 %t41, i32* @f, align 4
  br label %B117
B113:                               	; preds = %B112, %B114, %B114
  %t59 = load i32, i32* @f, align 4
  %t60 = add i32 %t59, 1
  store i32 %t60, i32* @f, align 4
  br i1 %t33, label %B111, label %B110
B117:                               	; preds = %B112
  %t42 = load i32, i32* @g, align 4
  %t43 = icmp slt i32 %t42, 3
  br i1 %t43, label %B115, label %B116
B115:                               	; preds = %B117, %B117
  %t45 = load i32, i32* @g, align 4
  %t46 = add i32 %t45, 10
  store i32 %t46, i32* @g, align 4
  br label %B120
B116:                               	; preds = %B115, %B117, %B117
  %t56 = load i32, i32* @g, align 4
  %t57 = sub i32 %t56, 8
  store i32 %t57, i32* @g, align 4
  br i1 %t38, label %B114, label %B113
B120:                               	; preds = %B115
  %t47 = load i32, i32* @h, align 4
  %t48 = icmp slt i32 %t47, 10
  br i1 %t48, label %B118, label %B119
B118:                               	; preds = %B120, %B120
  %t50 = load i32, i32* @h, align 4
  %t51 = add i32 %t50, 8
  store i32 %t51, i32* @h, align 4
  br i1 %t48, label %B120, label %B119
B119:                               	; preds = %B118, %B120, %B120
  %t53 = load i32, i32* @h, align 4
  %t54 = sub i32 %t53, 1
  store i32 %t54, i32* @h, align 4
  br i1 %t43, label %B117, label %B116
}
define i32 @main(){
B121:
  store i32 1, i32* @g, align 4
  store i32 2, i32* @h, align 4
  store i32 4, i32* @e, align 4
  store i32 6, i32* @f, align 4
  %t123 = call i32 @EightWhile()
  ret i32 %t123
}
