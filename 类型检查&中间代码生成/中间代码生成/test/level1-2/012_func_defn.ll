declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
  @a = global i32 0, align 4
define i32 @func(i32 %t12){
B11:
  %t14 = alloca i32, align 4
  store i32 %t12, i32* %t14, align 4
  %t3 = load i32, i32* %t14, align 4
  %t4 = sub i32 %t3, 1
  store i32 %t4, i32* %t14, align 4
  %t5 = load i32, i32* %t14, align 4
  ret i32 %t5
}
define i32 @main(){
B15:
  %t16 = alloca i32, align 4
  store i32 10, i32* @a, align 4
  %t9 = load i32, i32* @a, align 4
  %t18 = call i32 @func(i32 %t9)
  store i32 %t18, i32* %t16, align 4
  %t10 = load i32, i32* %t16, align 4
  ret i32 %t10
}
