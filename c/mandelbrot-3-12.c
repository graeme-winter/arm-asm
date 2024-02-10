/* 3.12 format Mandelbrot set calculation
 *
 * ** incorrect ** DO NOT USE left here as a demonstrator
 *
 * In many cases the calculations overflow such that the check of
 *
 * if ((zr2 + zi2) >= 0x4000)
 *
 * returns false when calculation of intermediate values or this value
 * overflowed. Could promote to 32 bit but then that is missing the
 * spirit of the calculation, instead leave as a marker for future.
 *
 * Example of one small domain where incorrect values are found included
 * in Python script.
 */

#include <stdint.h>
#include <unistd.h>

#define mul(a, b) (int16_t)((((int32_t)a) * ((int32_t)b)) >> 12)

int main(int argc, char **argv) {
  int16_t cr, ci;
  int16_t iter[1280 * 1280];
  int32_t offset = 0;
  for (ci = -((5 << 10) - 0x4); ci < 0x1400; ci += 0x8) {
    for (cr = -((2 << 12) - 0x4); cr < 0x800; cr += 0x8) {
      int16_t count = 0;
      int16_t zr = 0, zi = 0;
      int16_t tmp, zr2, zi2;

      while (count != 0x1000) {
        zr2 = mul(zr, zr);
        zi2 = mul(zi, zi);
        if ((zr2 + zi2) >= 0x4000)
          break;
        count++;
        tmp = zr;
        zr = zr2 - zi2 + cr;
        zi = 2 * mul(tmp, zi) + ci;
      }

      iter[offset] = count;
      offset++;
    }
  }
  write(1, (void *)iter, 0x320000);
}
