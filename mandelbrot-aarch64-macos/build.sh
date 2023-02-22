as -o mandelbrot.o mandelbrot.s
ld -o mandelbrot mandelbrot.o -lSystem -syslibroot \
             `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64 

