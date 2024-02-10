import numpy


def mul(a, b):
    return numpy.int16((numpy.int32(a) * numpy.int32(b)) >> 12)


def mand(x, y):
    ci = numpy.int16(-((5 << 10) - 0x4) + y * 0x8)
    cr = numpy.int16(-((2 << 12) - 0x4) + x * 0x8)

    count = 0
    zr = numpy.int16(0)
    zi = numpy.int16(0)
    zr2 = numpy.int16(0)
    zi2 = numpy.int16(0)

    true = 0

    while count != 0x1000:
        zr2 = mul(zr, zr)
        zi2 = mul(zi, zi)
        # compare the potentially overflowed value we have with the correct value
        if (
            true == 0
            and (
                (numpy.int32(zr) * numpy.int32(zr) + numpy.int32(zi) * numpy.int32(zi))
                >> 12
            )
            >= 0x4000
        ):
            true = count
        if (zr2 + zi2) >= 0x4000:
            break
        count += 1
        tmp = zr
        zr = zr2 - zi2 + cr
        zi = 2 * mul(tmp, zi) + ci

    return true, count


x0 = 277
y0 = 245

correct = numpy.empty((3, 3))
wrong = numpy.empty((3, 3))

for i in range(3):
    for j in range(3):
        t, c = mand(x0 + j, y0 + i)
        correct[(i, j)] = t
        wrong[(i, j)] = c

print(correct)
print(wrong)
