# Mandelbrot set in ARMv6 Assembly

Exercise for no other reason than to show it is possible, transcribe code from `C` to `asm`.

Turns out to be moderately hard though once I figured out the correct way to multiply two 32 bit fixed point numbers we got there OK.

Notes:

```assembly
    smull R10, R11, R5, R4
    lsr R10, #24
    orr R5, R10, R11, lsl #8
```

This motif was useful, to multiply / shift R5 * R4 -> R5. This is quite common in `mandelbrot.s`.

## Commentary

This shows some very nice features of the ARM processors in different generations of the π - π0 with the ancient arm11 core takes about a minute at 1GHz. The π4 I have at 1.5GHz takes about 15s, because the CPU is slightly faster but more importantly a triple issue core, and many of the instructions can be issued in parallel.
