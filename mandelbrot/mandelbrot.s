.text
.global _start

	@ register allocations
	@ r0 iteration counter
	@ r1 real part of c
	@ r2 imag part of c
	@ r3 real part of z
	@ r4 imag part of z
	@ r5 tmp / scratch to alias zr
	@ r6, r7 for the real and imaginary counters (increment by 0x8000)
	@ r8, r9 for working cr, ci

	@ data are stored in 7.24 format fixed point
	@ domain in real is -2 to 0.5, imag -1.25 to +1.25
	
_start:
	@ initial values for cr, ci - origin as above + 0.5 x box
	mov R1, #-2
	lsl R1, #24
	add R1, R1, #0x4000
	mov R2, #5
	lsl R2, #22
	add R1, R1, #0x4000
	
	@ start loop imag
	mov R7, #0
imag:
	mov R6, #0
real:	
	add R8, R1, R6, LSL 15
	add R9, R2. R7, LSL 15

	@ set up for iter
	mov R0, #0
	mov R3, #0
	mov R4, #0
iter:
	@ zr^2
	smull R10, R11, R3, R3
	asr R10, #24
	lsl R11, #8
	orr R8, R10, R11

	@ zi^2
	smull R10, R11, R4, R4
	asr R10, #24
	lsl R11, #8
	orr R9, R10, R11

	@ sum and cmp
	add R5, R8, R9
	cmp R5, #4, LSL 24
	bgt end

	@ next zr
	mov R5, R3
	add R10, R8, R9
	add R3, R10, R1

	@ next zi
	smull R10, R11, R5, R4
	asr R10, #23
	lsl R11, #9
	orr R5, R10, R11
	add R4, R5, R2
	
	add R0, #1
	cmp R0, #4096
	bne iter

end:
	
	mov R0, #0
        ldr R1, =hello
        mov R2, #13
        mov R7, #4
        svc 0

        mov R0, #0
        mov R7, #1
        svc 0

.data
hello: .ascii "Hello world!\n"
