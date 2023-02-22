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

### CPU generations

This shows some very nice features of the ARM processors in different generations of the π - π0 with the ancient arm11 core takes about a minute at 1GHz. The π4 I have at 1.5GHz takes about 15s, because the CPU is slightly faster but more importantly a triple issue core, and many of the instructions can be issued in parallel.

π0w (1st generation)

```
time ./mandelbrot > out

real	0m51.292s
user	0m50.492s
sys	0m0.180s
```

π3Bv1.2

```
time ./mandelbrot > out

real	0m24.577s
user	0m24.520s
sys	0m0.050s
```

π4B 4GB

```
time ./mandelbrot > out

real	0m14.287s
user	0m14.205s
sys	0m0.071s
```

### Assembly programming

Something I liked was building the code on various platforms (different generations of π, OS versions etc.) gave _identical_ results i.e. bitwise identity in output binary.

### Next iterations

Should give this a go on armv6t for rp2040 and using the 64 bit instruction set for A72 on π4 - the latter won't involve the messing around with the `smull` instructions that we have in the main code.
