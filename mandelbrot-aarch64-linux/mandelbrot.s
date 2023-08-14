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

	// 4 << 24 for cmp
	mov W11, #4
	lsl W11, W11, #24

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
	smull X8, W3, W3
	asr X8, X8, #24

	// zi^2
	smull X9, W4, W4
	asr X9, X9, #24

	// sum and cmp for zr^2 + zi^2
	add W5, W8, W9
	cmp W5, W11
	bge end

	// next zr
	mov W5, W3
	sub W6, W8, W9
	add W3, W6, W1

	// next zi
	smull X6, W5, W4
	asr X6, X6, #24
	add W4, W2, W6, lsl #1

	add W0, W0, #1
	cmp W0, #0x1000
	bne iter

end:
	// save value
	str W0, [X10], #4

	// increment real, continue - imm allowed
	add W1, W1, #0x8000
	cmp W1, #0x800000
	blt real

	// increment imag, continue - N.B. some annoying shifts for imm
	add W2, W2, #0x8000
	asr W5, W2, #22
	cmp W5, #5
	blt imag

	// write out array
	mov X0, #1
	ldr W1, =image
	mov X2, #0x640000
	mov X8, #64
	svc 0

	// end
	mov X0, #0
	mov X8, #93
	svc 0

.bss
image:	 .skip 0x640000
