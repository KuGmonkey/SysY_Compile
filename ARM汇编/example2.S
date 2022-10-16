	.text
	.align	1
	.global add
	.type	add, %function
add:
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7]
	ldr	r2, [r7, #4]
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r0, r3
	adds	r7, r7, #12
	mov	sp, r7
	pop     {r7}
	bx	lr

	.text
	.align	1
	.global addx
	.type	addx, %function
addx:
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	vstr.32	s0, [r7, #4]
	vstr.32	s1, [r7]
	vldr.32	s4, [r7, #4]
	vldr.32	s5, [r7]
	vadd.f32	s5, s4, s5
	vmov.f32	s0, s5
	adds	r7, r7, #12
	mov	sp, r7
	pop     {r7}           @ldr	r7, [sp], #4
	bx	lr

	.data
	@string scanf's input
	.align 4
	in1:
	.string "%d%d"
	@string scanf's input
	.align 4
	in2:
	.string "%f"
	.align	4
	@string printf's input
	out1:
	.string "%d\n%f\n"

	.text
	.align	1
	.global main
	.type	main, %function
main:
	push	{r7, lr}
	sub	sp, sp, #32
	add	r7, sp, #0      @a
	adds	r2, r7, #4      @b
	mov	r1, r7
	ldr	r0, =in1        @r0 string argue
	bl	__isoc99_scanf(PLT)
	ldr	r3, [r7]        @a
	cmp	r3, #2
	ble	.L6
	ldr	r3, [r7, #4]    @b
	cmp	r3, #2
	ble	.L6
	ldr	r3, [r7]
	ldr	r2, [r7, #4]
	mov	r1, r2
	mov	r0, r3
	bl	add(PLT)
	str	r0, [r7, #8]
	b	.L7
.L6:
	ldr	r3, [r7]
	str	r3, [r7, #8]    @c
.L7:
	movs	r3, #0
	str	r3, [r7, #12]   @i
	b	.L8
.L9:
	add	r2, r7, #20
	ldr	r3, [r7, #12]
	lsls	r3, r3, #2
	add	r3, r3, r2
	mov	r1, r3         @x[0]
	ldr	r0, =in2       @scanf's string argue
	bl	__isoc99_scanf(PLT)
	ldr	r3, [r7, #12]
	adds	r3, r3, #1
	str	r3, [r7, #12]  @i++
.L8:
	ldr	r3, [r7, #12]
	cmp	r3, #1
	ble	.L9
	vldr.32	s15, [r7, #20]
	vldr.32	s14, [r7, #24]
	vmov.f32	s1, s14
	vmov.f32	s0, s15
	bl	addx(PLT)
	vstr.32	s0, [r7, #16]    @d
	vldr.32	s15, [r7, #16]
	vcvt.f64.f32	d7, s15          @32-64b
	vmov	r2, r3, d7              @argue d
	ldr	r1, [r7, #8]            @argue c
	ldr	r0, =out1
	bl	printf(PLT)
	mov	r0, #0
	adds	r7, r7, #32
	mov	sp, r7
	pop     {r7,lr}
	bx	lr