import math

import numpy
from PIL import Image

ny = 1280
nx = 1280
x = numpy.fromfile("out", dtype=numpy.uint32, count=(nx * ny))
m = x.reshape((ny, nx))
m[m == 0x1000] = 0
m += 1

m = numpy.log2(m) * 18

image = m.astype(numpy.uint8)
Image.fromarray(image).save("mandel.png")
