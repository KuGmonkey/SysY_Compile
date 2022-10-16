        .data
	@format
	.align	4
	iof:
	.string "%d"

	.text
	.align	1
	.global main
	.type	main, %function
main:
	push	{r7, lr}
	sub	sp, sp, #16
	add	r7, sp, #0
	mov	r1, r7         @n
	ldr	r0, =iof
	bl	__isoc99_scanf(PLT)
	movs	r3, #2
	str	r3, [r7, #4]   @i
	movs	r3, #1
	str	r3, [r7, #8]   @f
	b	.L2
.L3:                          @i<=n
	ldr	r3, [r7, #8]   @f
	ldr	r2, [r7, #4]   @i
	mul	r3, r2, r3     @f=f*i
	str	r3, [r7, #8]
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L2:
	ldr	r3, [r7]
	ldr	r2, [r7, #4]
	cmp	r2, r3         @i<=n?
	ble	.L3
	ldr	r1, [r7, #8]   @argue f
	ldr	r0, =iof
	bl	printf(PLT)
	mov	r0, #0
	adds	r7, r7, #16
	mov	sp, r7
	pop     {r7,lr}
	bx	lr