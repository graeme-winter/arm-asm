# Mandelbrot set in ARMv6 Assembly

Exercise for no other reason than to show it is possible, transcribe code from `C` to `asm`.

Turns out to be moderately hard though once I figured out the correct way to multiply two 32 bit fixed point numbers we got there OK.

Notes:

```assembly
    smull R10, R11, R5, R4
    lsr R10, #24
    orr R5, R10, R11, lsl #8
```

This motif was useful, to multiply / shift R5 * R4 -> R5.
