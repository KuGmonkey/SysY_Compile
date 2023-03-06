declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
  @d = global i32 0, align 4
  @b = global i32 0, align 4
  @a = global i32 0, align 4
define i32 @set_a(i32 %t102){
B101:
  %t104 = alloca i32, align 4
  store i32 %t102, i32* %t104, align 4
  %t5 = load i32, i32* %t104, align 4
  store i32 %t5, i32* @a, align 4
  %t6 = load i32, i32* @a, align 4
  ret i32 %t6
}
define i32 @set_b(i32 %t106){
B105:
  %t108 = alloca i32, align 4
  store i32 %t106, i32* %t108, align 4
  %t9 = load i32, i32* %t108, align 4
  store i32 %t9, i32* @b, align 4
  %t10 = load i32, i32* @b, align 4
  ret i32 %t10
}
define i32 @set_d(i32 %t110){
B109:
  %t112 = alloca i32, align 4
  store i32 %t110, i32* %t112, align 4
  %t13 = load i32, i32* %t112, align 4
  store i32 %t13, i32* @d, align 4
  %t14 = load i32, i32* @d, align 4
  ret i32 %t14
}
define i32 @main(){
B113:
  %t194 = alloca i32, align 4
  %t193 = alloca i32, align 4
  %t192 = alloca i32, align 4
  %t191 = alloca i32, align 4
  %t190 = alloca i32, align 4
  %t144 = alloca i32, align 4
  store i32 2, i32* @a, align 4
  store i32 3, i32* @b, align 4
  %t118 = call i32 @set_a(i32 0)
B114:                               	; preds = %B113
  br label %B115
B115:                               	; preds = %B114, %B113
  %t18 = load i32, i32* @a, align 4
  call void @putint(i32 %t18)
  call void @putch(i32 32)
  %t19 = load i32, i32* @b, align 4
  call void @putint(i32 %t19)
  call void @putch(i32 32)
  store i32 2, i32* @a, align 4
  store i32 3, i32* @b, align 4
  %t133 = call i32 @set_a(i32 0)
B116:                               	; preds = %B113
  %t120 = call i32 @set_b(i32 1)
B129:                               	; preds = %B115
  br label %B130
B130:                               	; preds = %B129, %B115
  %t23 = load i32, i32* @a, align 4
  call void @putint(i32 %t23)
  call void @putch(i32 32)
  %t24 = load i32, i32* @b, align 4
  call void @putint(i32 %t24)
  call void @putch(i32 10)
  store i32 1, i32* %t144, align 4
  store i32 2, i32* @d, align 4
  %t26 = load i32, i32* %t144, align 4
  %t27 = icmp sge i32 %t26, 1
  br i1 %t27, label %B147, label %B146
B131:                               	; preds = %B115
  %t135 = call i32 @set_b(i32 1)
B145:                               	; preds = %B130
  br label %B146
B146:                               	; preds = %B145, %B130, %B130
  %t29 = load i32, i32* @d, align 4
  call void @putint(i32 %t29)
  call void @putch(i32 32)
  %t30 = load i32, i32* %t144, align 4
  %t31 = icmp sle i32 %t30, 1
  br i1 %t31, label %B154, label %B156
B147:                               	; preds = %B130, %B130
  %t149 = call i32 @set_d(i32 3)
B154:                               	; preds = %B146, %B146
  br label %B155
B155:                               	; preds = %B154, %B146
  %t33 = load i32, i32* @d, align 4
  call void @putint(i32 %t33)
  call void @putch(i32 10)
  %t34 = add i32 2, 1
  %t35 = sub i32 3, %t34
  %t36 = icmp sge i32 16, %t35
  br i1 %t36, label %B163, label %B164
B156:                               	; preds = %B146
  %t158 = call i32 @set_d(i32 4)
B163:                               	; preds = %B155, %B155
  call void @putch(i32 65)
  br label %B164
B164:                               	; preds = %B163, %B155, %B155
  %t37 = sub i32 25, 7
  %t38 = mul i32 6, 3
  %t39 = sub i32 36, %t38
  %t40 = icmp ne i32 %t37, %t39
  br i1 %t40, label %B167, label %B168
B167:                               	; preds = %B164, %B164
  call void @putch(i32 66)
  br label %B168
B168:                               	; preds = %B167, %B164, %B164
  %t41 = icmp slt i32 1, 8
  br i1 %t41, label %B171, label %B172
  %t42 = srem i32 7, 2
  %t43 = icmp ne i32 %t41, %t42
  br i1 %t43, label %B171, label %B172
B171:                               	; preds = %B168, %B168, %B168
  call void @putch(i32 67)
  br label %B172
B172:                               	; preds = %B171, %B168, %B168, %B168
  %t44 = icmp sgt i32 3, 4
  br i1 %t44, label %B175, label %B176
  %t45 = icmp eq i32 %t44, 0
  br i1 %t45, label %B175, label %B176
B175:                               	; preds = %B172, %B172, %B172
  call void @putch(i32 68)
  br label %B176
B176:                               	; preds = %B175, %B172, %B172, %B172
  %t46 = icmp eq i32 1, 102
  br i1 %t46, label %B179, label %B180
  %t47 = icmp sle i32 %t46, 63
  br i1 %t47, label %B179, label %B180
B179:                               	; preds = %B176, %B176, %B176
  call void @putch(i32 69)
  br label %B180
B180:                               	; preds = %B179, %B176, %B176, %B176
  %t48 = sub i32 5, 6
  %t49 = xor i1 0, true
  %t185 = zext i1 %t49 to i32
  %t50 = sub i32 0, %t185
  %t51 = icmp eq i32 %t48, %t50
  br i1 %t51, label %B183, label %B184
B183:                               	; preds = %B180, %B180
  call void @putch(i32 70)
  br label %B184
B184:                               	; preds = %B183, %B180, %B180
  call void @putch(i32 10)
  store i32 0, i32* %t194, align 4
  store i32 1, i32* %t193, align 4
  store i32 2, i32* %t192, align 4
  store i32 3, i32* %t191, align 4
  store i32 4, i32* %t190, align 4
  br label %B197
B197:                               	; preds = %B184
  %t57 = load i32, i32* %t194, align 4
B195:                               	; preds = %B197
  call void @putch(i32 32)
  br i1 %t59, label %B197, label %B196
B196:                               	; preds = %B195, %B197
  %t60 = load i32, i32* %t194, align 4
B198:                               	; preds = %B197
  %t58 = load i32, i32* %t193, align 4
B201:                               	; preds = %B196
  call void @putch(i32 67)
  br label %B202
B202:                               	; preds = %B201, %B196
  %t63 = load i32, i32* %t194, align 4
  %t64 = load i32, i32* %t193, align 4
  %t65 = icmp sge i32 %t63, %t64
  br i1 %t65, label %B206, label %B208
B206:                               	; preds = %B202, %B202, %B208
  call void @putch(i32 72)
  br label %B207
B207:                               	; preds = %B206, %B202, %B208
  %t70 = load i32, i32* %t192, align 4
  %t71 = load i32, i32* %t193, align 4
  %t72 = icmp sge i32 %t70, %t71
  br i1 %t72, label %B213, label %B212
B208:                               	; preds = %B202
  %t66 = load i32, i32* %t193, align 4
  %t67 = load i32, i32* %t194, align 4
  %t68 = icmp sle i32 %t66, %t67
  br i1 %t68, label %B206, label %B207
B211:                               	; preds = %B207, %B213
  call void @putch(i32 73)
  br label %B212
B212:                               	; preds = %B211, %B207, %B207, %B213
  %t77 = load i32, i32* %t194, align 4
  %t78 = load i32, i32* %t193, align 4
  %t79 = xor i1 %t78, true
  %t80 = icmp eq i32 %t77, %t79
  br i1 %t80, label %B219, label %B218
B213:                               	; preds = %B207, %B207
  %t73 = load i32, i32* %t190, align 4
  %t74 = load i32, i32* %t191, align 4
  %t75 = icmp ne i32 %t73, %t74
  br i1 %t75, label %B211, label %B212
B216:                               	; preds = %B212, %B219, %B218
  call void @putch(i32 74)
  br label %B217
B217:                               	; preds = %B216, %B212, %B218
  %t89 = load i32, i32* %t194, align 4
  %t90 = load i32, i32* %t193, align 4
  %t91 = xor i1 %t90, true
  %t92 = icmp eq i32 %t89, %t91
  br i1 %t92, label %B222, label %B224
B219:                               	; preds = %B212, %B212
  %t81 = load i32, i32* %t191, align 4
  %t82 = load i32, i32* %t191, align 4
  %t83 = icmp slt i32 %t81, %t82
  br i1 %t83, label %B216, label %B218
B218:                               	; preds = %B212, %B219
  %t85 = load i32, i32* %t190, align 4
  %t86 = load i32, i32* %t190, align 4
  %t87 = icmp sge i32 %t85, %t86
  br i1 %t87, label %B216, label %B217
B222:                               	; preds = %B217, %B217, %B225
  call void @putch(i32 75)
  br label %B223
B223:                               	; preds = %B222, %B217, %B224, %B225
  call void @putch(i32 10)
  ret i32 0
B224:                               	; preds = %B217
  %t93 = load i32, i32* %t191, align 4
  %t94 = load i32, i32* %t191, align 4
  %t95 = icmp slt i32 %t93, %t94
  br i1 %t95, label %B225, label %B223
B225:                               	; preds = %B224, %B224
  %t96 = load i32, i32* %t190, align 4
  %t97 = load i32, i32* %t190, align 4
  %t98 = icmp sge i32 %t96, %t97
  br i1 %t98, label %B222, label %B223
}
