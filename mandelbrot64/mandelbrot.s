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
	mov X2, #-5
	lsl X2, X2, #22
	add X2, X2, #0x4000

imag:
	// initial values for cr - origin as above + 0.5 x box
	mov X1, #-2
	lsl X1, X1, #24
	add X1, X1, #0x4000

real:
	// set up for iter - count, zr, zi
	mov X0, #0
	mov X3, #0
	mov X4, #0

iter:
	// zr^2
	mul X8, X3, X3
	lsr X8, X8, #24

	// zi^2
	mul X9, X4, X4
	lsr X8, X8, #24

	// sum and cmp for zr^2 + zi^2 - N.B. the cmp needs the shift
	add X5, X8, X9
	lsr X5, X5, #24
	cmp X5, #4
	bgt end

	// next zr
	mov X5, X3
	sub X6, X8, X9
	add X3, X6, X1

	// next zi
	mul X6, X5, X4
	lsr X6, X6, #24
	add X4, X2, X6, lsl #1

	add X0, X0, #1
	cmp X0, #0x1000
	bne iter

end:
	// save value
	str X0, [X10, #0]
	add X10, X10, #4

	// increment real, continue - imm allowed
	add X1, X1, #0x8000
	cmp X1, #0x800000
	blt real

	// increment imag, continue - N.B. some annoying shifts for imm
	add X2, X2, #0x8000
	lsr X5, X2, #22
	cmp X2, #5
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
