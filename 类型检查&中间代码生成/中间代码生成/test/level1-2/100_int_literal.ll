declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
  @s = global i32 0, align 4
define i32 @get_ans_se(i32 %t158, i32 %t161, i32 %t164){
B157:
  %t167 = alloca i32, align 4
  %t160 = alloca i32, align 4
  store i32 %t158, i32* %t160, align 4
  %t163 = alloca i32, align 4
  store i32 %t161, i32* %t163, align 4
  %t166 = alloca i32, align 4
  store i32 %t164, i32* %t166, align 4
  store i32 0, i32* %t167, align 4
  %t5 = load i32, i32* %t163, align 4
  %t6 = load i32, i32* %t166, align 4
  %t7 = icmp eq i32 %t5, %t6
  br i1 %t7, label %B168, label %B169
B168:                               	; preds = %B157, %B157
  store i32 1, i32* %t167, align 4
  br label %B169
B169:                               	; preds = %B168, %B157, %B157
  %t10 = load i32, i32* %t160, align 4
  %t11 = mul i32 %t10, 2
  store i32 %t11, i32* %t160, align 4
  %t13 = load i32, i32* %t160, align 4
  %t14 = load i32, i32* %t167, align 4
  %t15 = add i32 %t13, %t14
  store i32 %t15, i32* %t160, align 4
  %t17 = load i32, i32* @s, align 4
  %t18 = load i32, i32* %t160, align 4
  %t19 = add i32 %t17, %t18
  store i32 %t19, i32* @s, align 4
  %t20 = load i32, i32* %t160, align 4
  ret i32 %t20
}
define i32 @get_ans(i32 %t171, i32 %t174, i32 %t177){
B170:
  %t180 = alloca i32, align 4
  %t173 = alloca i32, align 4
  store i32 %t171, i32* %t173, align 4
  %t176 = alloca i32, align 4
  store i32 %t174, i32* %t176, align 4
  %t179 = alloca i32, align 4
  store i32 %t177, i32* %t179, align 4
  store i32 0, i32* %t180, align 4
  %t25 = load i32, i32* %t176, align 4
  %t26 = load i32, i32* %t179, align 4
  %t27 = icmp eq i32 %t25, %t26
  br i1 %t27, label %B181, label %B182
B181:                               	; preds = %B170, %B170
  store i32 1, i32* %t180, align 4
  br label %B182
B182:                               	; preds = %B181, %B170, %B170
  %t30 = load i32, i32* %t173, align 4
  %t31 = mul i32 %t30, 2
  store i32 %t31, i32* %t173, align 4
  %t33 = load i32, i32* %t173, align 4
  %t34 = load i32, i32* %t180, align 4
  %t35 = add i32 %t33, %t34
  store i32 %t35, i32* %t173, align 4
  %t36 = load i32, i32* %t173, align 4
  ret i32 %t36
}
define i32 @main(){
B183:
  %t193 = alloca i32, align 4
  %t192 = alloca i32, align 4
  %t191 = alloca i32, align 4
  %t190 = alloca i32, align 4
  %t189 = alloca i32, align 4
  %t188 = alloca i32, align 4
  %t187 = alloca i32, align 4
  %t186 = alloca i32, align 4
  %t184 = alloca i32, align 4
  %t185 = zext i1 -2147483648 to i32
  %t37 = sub i32 0, %t185
  store i32 %t37, i32* %t184, align 4
  store i32 -2147483648, i32* %t186, align 4
  %t38 = add i32 -2147483648, 1
  store i32 %t38, i32* %t187, align 4
  store i32 2147483647, i32* %t188, align 4
  %t39 = sub i32 2147483647, 1
  store i32 %t39, i32* %t189, align 4
  %t45 = load i32, i32* %t184, align 4
  %t46 = load i32, i32* %t186, align 4
  %t195 = call i32 @get_ans(i32 0, i32 %t45, i32 %t46)
  store i32 %t195, i32* %t193, align 4
  %t48 = load i32, i32* %t193, align 4
  %t49 = load i32, i32* %t184, align 4
  %t50 = add i32 %t49, 1
  %t51 = load i32, i32* %t187, align 4
  %t197 = call i32 @get_ans(i32 %t48, i32 %t50, i32 %t51)
  store i32 %t197, i32* %t193, align 4
  %t53 = load i32, i32* %t193, align 4
  %t54 = load i32, i32* %t184, align 4
  %t55 = load i32, i32* %t188, align 4
  %t198 = zext i1 %t55 to i32
  %t56 = sub i32 0, %t198
  %t57 = sub i32 %t56, 1
  %t200 = call i32 @get_ans(i32 %t53, i32 %t54, i32 %t57)
  store i32 %t200, i32* %t193, align 4
  %t59 = load i32, i32* %t193, align 4
  %t60 = load i32, i32* %t184, align 4
  %t61 = load i32, i32* %t189, align 4
  %t62 = add i32 %t61, 1
  %t202 = call i32 @get_ans(i32 %t59, i32 %t60, i32 %t62)
  store i32 %t202, i32* %t193, align 4
  %t64 = load i32, i32* %t193, align 4
  %t65 = load i32, i32* %t186, align 4
  %t66 = sdiv i32 %t65, 2
  %t67 = load i32, i32* %t187, align 4
  %t68 = sdiv i32 %t67, 2
  %t204 = call i32 @get_ans(i32 %t64, i32 %t66, i32 %t68)
  store i32 %t204, i32* %t193, align 4
  %t70 = load i32, i32* %t193, align 4
  %t71 = load i32, i32* %t186, align 4
  %t72 = load i32, i32* %t188, align 4
  %t205 = zext i1 %t72 to i32
  %t73 = sub i32 0, %t205
  %t74 = sub i32 %t73, 1
  %t207 = call i32 @get_ans(i32 %t70, i32 %t71, i32 %t74)
  store i32 %t207, i32* %t193, align 4
  %t76 = load i32, i32* %t193, align 4
  %t77 = load i32, i32* %t186, align 4
  %t78 = load i32, i32* %t189, align 4
  %t79 = add i32 %t78, 1
  %t209 = call i32 @get_ans(i32 %t76, i32 %t77, i32 %t79)
  store i32 %t209, i32* %t193, align 4
  %t81 = load i32, i32* %t187, align 4
  %t82 = load i32, i32* %t188, align 4
  %t211 = call i32 @get_ans(i32 0, i32 %t81, i32 %t82)
  store i32 %t211, i32* %t192, align 4
  %t84 = load i32, i32* %t192, align 4
  %t85 = load i32, i32* %t187, align 4
  %t86 = load i32, i32* %t189, align 4
  %t213 = call i32 @get_ans(i32 %t84, i32 %t85, i32 %t86)
  store i32 %t213, i32* %t192, align 4
  %t88 = load i32, i32* %t192, align 4
  %t89 = load i32, i32* %t188, align 4
  %t90 = load i32, i32* %t189, align 4
  %t215 = call i32 @get_ans(i32 %t88, i32 %t89, i32 %t90)
  store i32 %t215, i32* %t192, align 4
  %t92 = load i32, i32* %t192, align 4
  %t93 = load i32, i32* %t184, align 4
  %t94 = sdiv i32 %t93, 2
  %t95 = load i32, i32* %t186, align 4
  %t96 = sdiv i32 %t95, 2
  %t217 = call i32 @get_ans(i32 %t92, i32 %t94, i32 %t96)
  store i32 %t217, i32* %t192, align 4
  %t98 = load i32, i32* %t184, align 4
  %t99 = load i32, i32* %t186, align 4
  %t219 = call i32 @get_ans_se(i32 0, i32 %t98, i32 %t99)
  store i32 %t219, i32* %t191, align 4
  %t101 = load i32, i32* %t191, align 4
  %t102 = load i32, i32* %t184, align 4
  %t103 = add i32 %t102, 1
  %t104 = load i32, i32* %t187, align 4
  %t221 = call i32 @get_ans_se(i32 %t101, i32 %t103, i32 %t104)
  store i32 %t221, i32* %t191, align 4
  %t106 = load i32, i32* %t191, align 4
  %t107 = load i32, i32* %t184, align 4
  %t108 = load i32, i32* %t188, align 4
  %t222 = zext i1 %t108 to i32
  %t109 = sub i32 0, %t222
  %t110 = sub i32 %t109, 1
  %t224 = call i32 @get_ans_se(i32 %t106, i32 %t107, i32 %t110)
  store i32 %t224, i32* %t191, align 4
  %t112 = load i32, i32* %t191, align 4
  %t113 = load i32, i32* %t184, align 4
  %t114 = load i32, i32* %t189, align 4
  %t115 = add i32 %t114, 1
  %t226 = call i32 @get_ans_se(i32 %t112, i32 %t113, i32 %t115)
  store i32 %t226, i32* %t191, align 4
  %t117 = load i32, i32* %t191, align 4
  %t118 = load i32, i32* %t186, align 4
  %t119 = sdiv i32 %t118, 2
  %t120 = load i32, i32* %t187, align 4
  %t121 = sdiv i32 %t120, 2
  %t228 = call i32 @get_ans_se(i32 %t117, i32 %t119, i32 %t121)
  store i32 %t228, i32* %t191, align 4
  %t123 = load i32, i32* %t191, align 4
  %t124 = load i32, i32* %t186, align 4
  %t125 = load i32, i32* %t188, align 4
  %t229 = zext i1 %t125 to i32
  %t126 = sub i32 0, %t229
  %t127 = sub i32 %t126, 1
  %t231 = call i32 @get_ans_se(i32 %t123, i32 %t124, i32 %t127)
  store i32 %t231, i32* %t191, align 4
  %t129 = load i32, i32* %t191, align 4
  %t130 = load i32, i32* %t186, align 4
  %t131 = load i32, i32* %t189, align 4
  %t132 = add i32 %t131, 1
  %t233 = call i32 @get_ans_se(i32 %t129, i32 %t130, i32 %t132)
  store i32 %t233, i32* %t191, align 4
  %t134 = load i32, i32* %t187, align 4
  %t135 = load i32, i32* %t188, align 4
  %t235 = call i32 @get_ans_se(i32 0, i32 %t134, i32 %t135)
  store i32 %t235, i32* %t190, align 4
  %t137 = load i32, i32* %t190, align 4
  %t138 = load i32, i32* %t187, align 4
  %t139 = load i32, i32* %t189, align 4
  %t237 = call i32 @get_ans_se(i32 %t137, i32 %t138, i32 %t139)
  store i32 %t237, i32* %t190, align 4
  %t141 = load i32, i32* %t190, align 4
  %t142 = load i32, i32* %t188, align 4
  %t143 = load i32, i32* %t189, align 4
  %t239 = call i32 @get_ans_se(i32 %t141, i32 %t142, i32 %t143)
  store i32 %t239, i32* %t190, align 4
  %t145 = load i32, i32* %t190, align 4
  %t146 = load i32, i32* %t184, align 4
  %t147 = sdiv i32 %t146, 2
  %t148 = load i32, i32* %t186, align 4
  %t149 = sdiv i32 %t148, 2
  %t241 = call i32 @get_ans_se(i32 %t145, i32 %t147, i32 %t149)
  store i32 %t241, i32* %t190, align 4
  %t150 = load i32, i32* %t193, align 4
  %t151 = load i32, i32* %t192, align 4
  %t152 = add i32 %t150, %t151
  %t153 = load i32, i32* %t191, align 4
  %t154 = add i32 %t152, %t153
  %t155 = load i32, i32* %t190, align 4
  %t156 = add i32 %t154, %t155
  ret i32 %t156
}
