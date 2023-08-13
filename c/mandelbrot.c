#include <unistd.h>
#include <stdint.h>

#define mul(a, b) (int32_t)((((int64_t)a) * ((int64_t)b)) >> 24)

int main(int argc, char **argv) {
  int32_t cr, ci;
  int32_t iter[1280 * 1280];
  int32_t offset = 0;
  for (ci = -((5 << 22) - 0x4000); ci < 0x1400000; ci += 0x8000) {
    for (cr = -((2 << 24) - 0x4000); cr < 0x800000; cr += 0x8000) {
      int32_t count = 0;
      int32_t zr = 0, zi = 0;
      int32_t tmp, zr2, zi2;

      while (count != 0x1000) {
        zr2 = mul(zr, zr);
        zi2 = mul(zi, zi);
        if ((zr2 + zi2) >= 0x4000000)
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
  write(1, (void *)iter, 0x640000);
}
