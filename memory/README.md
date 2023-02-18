# Memory access

Memory access is defined in here in terms of a static array so no malloc etc. - just a section in `.bss` marking out a 4k block of data called `image`. This is then used as a pointer by loading into a register and offsetting from. 4k chosen as it will fit into the `imm16` for a `mov`.

Code in `memory.s`:

```assembly
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
```

Output:

```
0000000 0000 0000 0004 0000 0008 0000 000c 0000
0000020 0010 0000 0014 0000 0018 0000 001c 0000
0000040 0020 0000 0024 0000 0028 0000 002c 0000
0000060 0030 0000 0034 0000 0038 0000 003c 0000
0000100 0040 0000 0044 0000 0048 0000 004c 0000
0000120 0050 0000 0054 0000 0058 0000 005c 0000
0000140 0060 0000 0064 0000 0068 0000 006c 0000
0000160 0070 0000 0074 0000 0078 0000 007c 0000
0000200 0080 0000 0084 0000 0088 0000 008c 0000
0000220 0090 0000 0094 0000 0098 0000 009c 0000
0000240 00a0 0000 00a4 0000 00a8 0000 00ac 0000
0000260 00b0 0000 00b4 0000 00b8 0000 00bc 0000
0000300 00c0 0000 00c4 0000 00c8 0000 00cc 0000
0000320 00d0 0000 00d4 0000 00d8 0000 00dc 0000
```
