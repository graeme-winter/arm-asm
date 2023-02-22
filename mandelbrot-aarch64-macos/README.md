# Mandelbrot set in ARM aarch64 Assembly

Exercise for no other reason than to show it is possible, transcribe code from `C` to `asm`. This version ported from ARMv6 assembly. Only real think which was needed was `mul` which involves a 24 bit `asl` afterwards.

## Commentary

### CPU generations

This shows quite how fast the M2 CPU really is: the code is significantly faster than the GHz would suggest, which represents the enormous difference in the degree to which the cores are superscalar. I have no idea how wide the instruction issue is, but it is _wide_.
