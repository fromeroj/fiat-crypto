static void fesquare(uint32_t out[9], const uint32_t in1[9]) {
  { const uint32_t x15 = in1[8];
  { const uint32_t x16 = in1[7];
  { const uint32_t x14 = in1[6];
  { const uint32_t x12 = in1[5];
  { const uint32_t x10 = in1[4];
  { const uint32_t x8 = in1[3];
  { const uint32_t x6 = in1[2];
  { const uint32_t x4 = in1[1];
  { const uint32_t x2 = in1[0];
  { uint64_t x17 = (((uint64_t)x2 * x15) + (((uint64_t)x4 * x16) + (((uint64_t)x6 * x14) + (((uint64_t)x8 * x12) + (((uint64_t)x10 * x10) + (((uint64_t)x12 * x8) + (((uint64_t)x14 * x6) + (((uint64_t)x16 * x4) + ((uint64_t)x15 * x2)))))))));
  { uint64_t x18 = ((((uint64_t)x2 * x16) + (((uint64_t)x4 * x14) + (((uint64_t)x6 * x12) + (((uint64_t)x8 * x10) + (((uint64_t)x10 * x8) + (((uint64_t)x12 * x6) + (((uint64_t)x14 * x4) + ((uint64_t)x16 * x2)))))))) + (0x11 * ((uint64_t)x15 * x15)));
  { uint64_t x19 = ((((uint64_t)x2 * x14) + (((uint64_t)x4 * x12) + (((uint64_t)x6 * x10) + (((uint64_t)x8 * x8) + (((uint64_t)x10 * x6) + (((uint64_t)x12 * x4) + ((uint64_t)x14 * x2))))))) + (0x11 * (((uint64_t)x16 * x15) + ((uint64_t)x15 * x16))));
  { uint64_t x20 = ((((uint64_t)x2 * x12) + (((uint64_t)x4 * x10) + (((uint64_t)x6 * x8) + (((uint64_t)x8 * x6) + (((uint64_t)x10 * x4) + ((uint64_t)x12 * x2)))))) + (0x11 * (((uint64_t)x14 * x15) + (((uint64_t)x16 * x16) + ((uint64_t)x15 * x14)))));
  { uint64_t x21 = ((((uint64_t)x2 * x10) + (((uint64_t)x4 * x8) + (((uint64_t)x6 * x6) + (((uint64_t)x8 * x4) + ((uint64_t)x10 * x2))))) + (0x11 * (((uint64_t)x12 * x15) + (((uint64_t)x14 * x16) + (((uint64_t)x16 * x14) + ((uint64_t)x15 * x12))))));
  { uint64_t x22 = ((((uint64_t)x2 * x8) + (((uint64_t)x4 * x6) + (((uint64_t)x6 * x4) + ((uint64_t)x8 * x2)))) + (0x11 * (((uint64_t)x10 * x15) + (((uint64_t)x12 * x16) + (((uint64_t)x14 * x14) + (((uint64_t)x16 * x12) + ((uint64_t)x15 * x10)))))));
  { uint64_t x23 = ((((uint64_t)x2 * x6) + (((uint64_t)x4 * x4) + ((uint64_t)x6 * x2))) + (0x11 * (((uint64_t)x8 * x15) + (((uint64_t)x10 * x16) + (((uint64_t)x12 * x14) + (((uint64_t)x14 * x12) + (((uint64_t)x16 * x10) + ((uint64_t)x15 * x8))))))));
  { uint64_t x24 = ((((uint64_t)x2 * x4) + ((uint64_t)x4 * x2)) + (0x11 * (((uint64_t)x6 * x15) + (((uint64_t)x8 * x16) + (((uint64_t)x10 * x14) + (((uint64_t)x12 * x12) + (((uint64_t)x14 * x10) + (((uint64_t)x16 * x8) + ((uint64_t)x15 * x6)))))))));
  { uint64_t x25 = (((uint64_t)x2 * x2) + (0x11 * (((uint64_t)x4 * x15) + (((uint64_t)x6 * x16) + (((uint64_t)x8 * x14) + (((uint64_t)x10 * x12) + (((uint64_t)x12 * x10) + (((uint64_t)x14 * x8) + (((uint64_t)x16 * x6) + ((uint64_t)x15 * x4))))))))));
  { uint64_t x26 = (x25 >> 0x16);
  { uint32_t x27 = ((uint32_t)x25 & 0x3fffff);
  { uint64_t x28 = (x26 + x24);
  { uint64_t x29 = (x28 >> 0x16);
  { uint32_t x30 = ((uint32_t)x28 & 0x3fffff);
  { uint64_t x31 = (x29 + x23);
  { uint64_t x32 = (x31 >> 0x16);
  { uint32_t x33 = ((uint32_t)x31 & 0x3fffff);
  { uint64_t x34 = (x32 + x22);
  { uint32_t x35 = (uint32_t) (x34 >> 0x16);
  { uint32_t x36 = ((uint32_t)x34 & 0x3fffff);
  { uint64_t x37 = (x35 + x21);
  { uint32_t x38 = (uint32_t) (x37 >> 0x16);
  { uint32_t x39 = ((uint32_t)x37 & 0x3fffff);
  { uint64_t x40 = (x38 + x20);
  { uint32_t x41 = (uint32_t) (x40 >> 0x16);
  { uint32_t x42 = ((uint32_t)x40 & 0x3fffff);
  { uint64_t x43 = (x41 + x19);
  { uint32_t x44 = (uint32_t) (x43 >> 0x16);
  { uint32_t x45 = ((uint32_t)x43 & 0x3fffff);
  { uint64_t x46 = (x44 + x18);
  { uint32_t x47 = (uint32_t) (x46 >> 0x16);
  { uint32_t x48 = ((uint32_t)x46 & 0x3fffff);
  { uint64_t x49 = (x47 + x17);
  { uint32_t x50 = (uint32_t) (x49 >> 0x16);
  { uint32_t x51 = ((uint32_t)x49 & 0x3fffff);
  { uint64_t x52 = (x27 + ((uint64_t)0x11 * x50));
  { uint32_t x53 = (uint32_t) (x52 >> 0x16);
  { uint32_t x54 = ((uint32_t)x52 & 0x3fffff);
  { uint32_t x55 = (x53 + x30);
  { uint32_t x56 = (x55 >> 0x16);
  { uint32_t x57 = (x55 & 0x3fffff);
  out[0] = x54;
  out[1] = x57;
  out[2] = (x56 + x33);
  out[3] = x36;
  out[4] = x39;
  out[5] = x42;
  out[6] = x45;
  out[7] = x48;
  out[8] = x51;
  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
}
