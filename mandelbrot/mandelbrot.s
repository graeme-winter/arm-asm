.text
.global _start

_start: mov R0, #1
        ldr R1, =hello
        mov R2, #13
        mov R7, #4
        svc 0

        mov R0, #0
        mov R7, #1
        svc 0

.data
hello: .ascii "Hello world!\n"
