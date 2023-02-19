.text
.global _start

	@ register allocations
	@ r0 iteration counter
	@ r1 real part of c
	@ r2 imag part of c
	@ r3 real part of z
	@ r4 imag part of z
	@ r5 tmp / scratch to alias zr
	@ r8, r9 for zr2, zi2
	@ r10, r11 for working space for SMULL instruction
	@ r12 pointer to next word to write

	@ data are stored in 7.24 format fixed point
	@ domain in real is -2 to 0.5, imag -1.25 to +1.25
	
_start:
	ldr R12, =image

	@ initial values for ci - origin as above + 0.5 x box
	mov R2, #-5
	lsl R2, #22
	add R2, R2, #0x4000
	
imag:
	@ initial values for cr - origin as above + 0.5 x box
	mov R1, #-2
	lsl R1, #24
	add R1, R1, #0x4000

real:	
	@ set up for iter - count, zr, zi
	mov R0, #0
	mov R3, #0
	mov R4, #0

iter:
	@ zr^2
	smull R10, R11, R3, R3
	lsr R10, #24
	orr R8, R10, R11, lsl #8

	@ zi^2
	smull R10, R11, R4, R4
	lsr R10, #24
	orr R9, R10, R11, lsl #8

	@ sum and cmp for zr^2 + zi^2
	add R5, R8, R9
	cmp R5, #0x4000000
	bgt end

	@ next zr
	mov R5, R3
	sub R10, R8, R9
	add R3, R10, R1

	@ next zi
	smull R10, R11, R5, R4
	lsr R10, #24
	orr R5, R10, R11, lsl #8
	lsl R5, #1
	add R4, R5, R2
	
	add R0, #1
	cmp R0, #0x1000
	bne iter

end:

	@ save value
	str R0, [R12, #0]
	add R12, #4

	@ increment real, continue
	add R1, R1, #0x8000
	cmp R1, #0x800000
	blt real

	@ increment imag, continue
	add R2, R2, #0x8000
	cmp R2, #0x1400000
	blt imag

	@ write out array
        mov R0, #1
        ldr R1, =image
        mov R2, #0x640000
        mov R7, #4
        svc 0	

	@ end
        mov R0, #0
        mov R7, #1
        svc 0

.bss
image:	 .skip 0x640000
