.text
.global _start

_start: mov R0, #0
        mov R1, #4096
        ldr R2, =image
        next:
        str R0, [R2, R0]
        add R0, #4
        cmp R0, R1
        bne next

        mov R0, #1
        ldr R1, =image
        mov R2, #4096
        mov R7, #4
        svc 0

        mov R0, #0
        mov R7, #1
        svc 0

.bss
image: .skip 4096
