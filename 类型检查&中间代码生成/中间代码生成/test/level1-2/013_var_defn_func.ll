declare i32 @getint()
declare void @putint(i32)
declare i32 @getch()
declare void @putch(i32)
define i32 @defn(){
B2:
  ret i32 4
}
define i32 @main(){
B3:
  %t4 = alloca i32, align 4
  %t6 = call i32 @defn()
  store i32 %t6, i32* %t4, align 4
  %t1 = load i32, i32* %t4, align 4
  ret i32 %t1
}
