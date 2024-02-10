import numpy

a = (
    numpy.fromfile("x", dtype=numpy.uint32, count=1280 * 1280)
    .reshape(1280, 1280)
    .astype(numpy.float32)
    + 1
)
a = numpy.log2(a)
from matplotlib import pyplot

pyplot.imshow(a, cmap="gray")
pyplot.show()
