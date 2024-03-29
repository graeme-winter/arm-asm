.text
.global _start

	// register allocations
	// r0 iter counter
	// r1/r2 real / imag c
	// r3/r4 real / imag z
	// r5 scratch
	// r8, r9 for zr2, zi2
	// r6, r7 for working space for SMULL instruction
	// r10 pointer to next word to write

	// data are stored in 7.24 format fixed point
	// domain in real is -2 to 0.5, imag -1.25 to +1.25

_start:
	ldr R10, =image

	// initial values for ci - origin as above + 0.5 x box
	mov R2, #-5
	lsl R2, #22
	add R2, R2, #0x4000

imag:
	// initial values for cr - origin as above + 0.5 x box
	mov R1, #-2
	lsl R1, #24
	add R1, R1, #0x4000

real:
	// set up for iter - count, zr, zi
	mov R0, #0
	mov R3, #0
	mov R4, #0

iter:
	// zr^2
	smull R6, R7, R3, R3
	lsr R6, #24
	orr R8, R6, R7, lsl #8

	// zi^2
	smull R6, R7, R4, R4
	lsr R6, #24
	orr R9, R6, R7, lsl #8

	// sum and cmp for zr^2 + zi^2
	add R5, R8, R9
	cmp R5, #0x4000000
	bge end

	// next zi
	smull R6, R7, R3, R4
	lsr R6, #24
	orr R5, R6, R7, lsl #8
	add R4, R2, R5, lsl #1

	// next zr
	sub R6, R8, R9
	add R3, R6, R1

	add R0, #1
	cmp R0, #0x1000
	bne iter

end:
	// save value
	str R0, [R10, #0]
	add R10, #4

	// increment real, continue
	add R1, R1, #0x8000
	cmp R1, #0x800000
	blt real

	// increment imag, continue
	add R2, R2, #0x8000
	cmp R2, #0x1400000
	blt imag

	// write out array
	mov R0, #1
	ldr R1, =image
	mov R2, #0x640000
	mov R7, #4
	svc 0

	// end
	mov R0, #0
	mov R7, #1
	svc 0

.bss
image:	 .skip 0x640000
