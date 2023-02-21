.text
.global _start

	// register allocations
	// r0 iter counter
	// r1/r2 real / imag c
	// r3/r4 real / imag z
	// r5 tmp / scratch to alias zr
	// r8, r9 for zr2, zi2
	// r6, r7 for working space for SMULL instruction
	// r10 pointer to next word to write

	// data are stored in 7.24 format fixed point
	// domain in real is -2 to 0.5, imag -1.25 to +1.25

_start:
	ldr W10, =image

	// initial values for ci - origin as above + 0.5 x box
	mov W2, #-5
	lsl W2, W2, #22
	add W2, W2, #0x4000

imag:
	// initial values for cr - origin as above + 0.5 x box
	mov W1, #-2
	lsl W1, W1, #24
	add W1, W1, #0x4000

real:
	// set up for iter - count, zr, zi
	mov W0, #0
	mov W3, #0
	mov W4, #0

iter:
	// zr^2
	smull X6, W3, W3
	lsr W6, #24
	orr W8, W6, W7, lsl #8

	// zi^2
	smull W6, W7, W4, W4
	lsr W6, #24
	orr W9, W6, W7, lsl #8

	// sum and cmp for zr^2 + zi^2
	add W5, W8, W9
	cmp W5, #0x4000000
	bgt end

	// next zr
	mov W5, W3
	sub W6, W8, W9
	add W3, W6, W1

	// next zi
	smull W6, W7, W5, W4
	lsr W6, #24
	orr W5, W6, W7, lsl #8
	add W4, W2, W5, lsl #1

	add W0, #1
	cmp W0, #0x1000
	bne iter

end:
	// save value
	str W0, [W10, #0]
	add W10, #4

	// increment real, continue
	add W1, W1, #0x8000
	cmp W1, #0x800000
	blt real

	// increment imag, continue
	add W2, W2, #0x8000
	cmp W2, #0x1400000
	blt imag

	// write out array
	mov W0, #1
	ldr W1, =image
	mov W2, #0x640000
	mov W7, #4
	svc 0

	// end
	mov W0, #0
	mov W7, #1
	svc 0

.bss
image:	 .skip 0x640000
