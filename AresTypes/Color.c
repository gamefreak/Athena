//
//  Color.c
//  Athena
//
//  Created by Scott McClaugherty on 10/4/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "Color.h"

inline uint32_t dequantitize_pixel(uint8_t pixel) {
    return CLUT4P[pixel];
}

#define SLICE(value, shift) (int16_t)((value & (0xff << shift)) >> shift)
inline uint32_t pixel_magnitude(uint32_t pixel, uint32_t color) {
    int16_t r = SLICE(pixel, 24) - SLICE(color, 24);
    int16_t g = SLICE(pixel, 16) - SLICE(color, 16);
    int16_t b = SLICE(pixel, 8) - SLICE(color, 8);
    return (r*r+g*g+b*b);
}
#undef SLICE

uint8_t quantitize_pixel(uint32_t pixel) {
    short alpha = (pixel & 0x000000ff) >> 0;
    if (alpha < 0xf0) return 0;//transparent
    int bestIdx = 0;
    int bestDiff = 1000000;
    for (int i = 1; i <= 256; i++) {
        int diff = pixel_magnitude(pixel, CLUT4P[i] & 0xffffff00);
        if (diff < bestDiff) {
            bestDiff = diff;
            bestIdx = i;
        }
    }
    return bestIdx;
}


const uint8_t CLUT[256][3] = {
    {0x00, 0x00, 0x00}, {0x00, 0x00, 0x00}, {0xe0, 0xe0, 0xe0}, {0xd0, 0xd0, 0xd0},
    {0xc0, 0xc0, 0xc0}, {0xb0, 0xb0, 0xb0}, {0xa0, 0xa0, 0xa0}, {0x90, 0x90, 0x90},
    {0x80, 0x80, 0x80}, {0x70, 0x70, 0x70}, {0x60, 0x60, 0x60}, {0x50, 0x50, 0x50},
    {0x40, 0x40, 0x40}, {0x30, 0x30, 0x30}, {0x20, 0x20, 0x20}, {0x10, 0x10, 0x10},
    {0x08, 0x08, 0x08}, {0xff, 0x7f, 0x00}, {0xf0, 0x78, 0x00}, {0xe0, 0x70, 0x00},
    {0xd0, 0x68, 0x00}, {0xc0, 0x60, 0x00}, {0xb0, 0x58, 0x00}, {0xa0, 0x50, 0x00},
    {0x90, 0x48, 0x00}, {0x80, 0x40, 0x00}, {0x70, 0x38, 0x00}, {0x60, 0x30, 0x00},
    {0x50, 0x28, 0x00}, {0x40, 0x20, 0x00}, {0x30, 0x18, 0x00}, {0x20, 0x10, 0x00},
    {0x10, 0x08, 0x00}, {0xff, 0xff, 0x00}, {0xf0, 0xf0, 0x00}, {0xe0, 0xe0, 0x00},
    {0xd0, 0xd0, 0x00}, {0xc0, 0xc0, 0x00}, {0xb0, 0xb0, 0x00}, {0xa0, 0xa0, 0x00},
    {0x90, 0x90, 0x00}, {0x80, 0x80, 0x00}, {0x70, 0x70, 0x00}, {0x60, 0x60, 0x00},
    {0x50, 0x50, 0x00}, {0x40, 0x40, 0x00}, {0x30, 0x30, 0x00}, {0x20, 0x20, 0x00},
    {0x10, 0x10, 0x00}, {0x00, 0x00, 0xff}, {0x00, 0x00, 0xf0}, {0x00, 0x00, 0xe0},
    {0x00, 0x00, 0xd0}, {0x00, 0x00, 0xc0}, {0x00, 0x00, 0xb0}, {0x00, 0x00, 0xa0},
    {0x00, 0x00, 0x90}, {0x00, 0x00, 0x80}, {0x00, 0x00, 0x70}, {0x00, 0x00, 0x60},
    {0x00, 0x00, 0x50}, {0x00, 0x00, 0x40}, {0x00, 0x00, 0x30}, {0x00, 0x00, 0x20},
    {0x00, 0x00, 0x10}, {0x00, 0xff, 0x00}, {0x00, 0xf0, 0x00}, {0x00, 0xe0, 0x00},
    {0x00, 0xd0, 0x00}, {0x00, 0xc0, 0x00}, {0x00, 0xb0, 0x00}, {0x00, 0xa0, 0x00},
    {0x00, 0x90, 0x00}, {0x00, 0x80, 0x00}, {0x00, 0x70, 0x00}, {0x00, 0x60, 0x00},
    {0x00, 0x50, 0x00}, {0x00, 0x40, 0x00}, {0x00, 0x30, 0x00}, {0x00, 0x20, 0x00},
    {0x00, 0x10, 0x00}, {0x7f, 0x00, 0xff}, {0x78, 0x00, 0xf0}, {0x70, 0x00, 0xe0},
    {0x68, 0x00, 0xd0}, {0x60, 0x00, 0xc0}, {0x58, 0x00, 0xb0}, {0x50, 0x00, 0xa0},
    {0x48, 0x00, 0x90}, {0x40, 0x00, 0x80}, {0x38, 0x00, 0x70}, {0x30, 0x00, 0x60},
    {0x28, 0x00, 0x50}, {0x20, 0x00, 0x40}, {0x18, 0x00, 0x30}, {0x10, 0x00, 0x20},
    {0x08, 0x00, 0x10}, {0x7f, 0x7f, 0xff}, {0x78, 0x78, 0xf0}, {0x70, 0x70, 0xe0},
    {0x68, 0x68, 0xd0}, {0x60, 0x60, 0xc0}, {0x58, 0x58, 0xb0}, {0x50, 0x50, 0xa0},
    {0x48, 0x48, 0x90}, {0x40, 0x40, 0x80}, {0x38, 0x38, 0x70}, {0x30, 0x30, 0x60},
    {0x28, 0x28, 0x50}, {0x20, 0x20, 0x40}, {0x18, 0x18, 0x30}, {0x10, 0x10, 0x20},
    {0x08, 0x08, 0x10}, {0xff, 0x7f, 0x7f}, {0xf0, 0x78, 0x78}, {0xe0, 0x70, 0x70},
    {0xd0, 0x68, 0x68}, {0xc0, 0x60, 0x60}, {0xb0, 0x58, 0x58}, {0xa0, 0x50, 0x50},
    {0x90, 0x48, 0x48}, {0x80, 0x40, 0x40}, {0x70, 0x38, 0x38}, {0x60, 0x30, 0x30},
    {0x50, 0x28, 0x28}, {0x40, 0x20, 0x20}, {0x30, 0x18, 0x18}, {0x20, 0x10, 0x10},
    {0x10, 0x08, 0x08}, {0xff, 0xff, 0x7f}, {0xf0, 0xf0, 0x78}, {0xe0, 0xe0, 0x70},
    {0xd0, 0xd0, 0x68}, {0xc0, 0xc0, 0x60}, {0xb0, 0xb0, 0x58}, {0xa0, 0xa0, 0x50},
    {0x90, 0x90, 0x48}, {0x80, 0x80, 0x40}, {0x70, 0x70, 0x38}, {0x60, 0x60, 0x30},
    {0x50, 0x50, 0x28}, {0x40, 0x40, 0x20}, {0x30, 0x30, 0x18}, {0x20, 0x20, 0x10},
    {0x10, 0x10, 0x08}, {0x00, 0xff, 0xff}, {0x00, 0xf0, 0xf0}, {0x00, 0xe0, 0xe0},
    {0x00, 0xd0, 0xd0}, {0x00, 0xc0, 0xc0}, {0x00, 0xb0, 0xb0}, {0x00, 0xa0, 0xa0},
    {0x00, 0x90, 0x90}, {0x00, 0x80, 0x80}, {0x00, 0x70, 0x70}, {0x00, 0x60, 0x60},
    {0x00, 0x50, 0x50}, {0x00, 0x40, 0x40}, {0x00, 0x30, 0x30}, {0x00, 0x20, 0x20},
    {0x00, 0x10, 0x10}, {0xff, 0x00, 0x7f}, {0xf0, 0x00, 0x78}, {0xe0, 0x00, 0x70},
    {0xd0, 0x00, 0x68}, {0xc0, 0x00, 0x60}, {0xb0, 0x00, 0x58}, {0xa0, 0x00, 0x50},
    {0x90, 0x00, 0x48}, {0x80, 0x00, 0x40}, {0x70, 0x00, 0x38}, {0x60, 0x00, 0x30},
    {0x50, 0x00, 0x28}, {0x40, 0x00, 0x20}, {0x30, 0x00, 0x18}, {0x20, 0x00, 0x10},
    {0x10, 0x00, 0x08}, {0x7f, 0xff, 0x7f}, {0x78, 0xf0, 0x78}, {0x70, 0xe0, 0x70},
    {0x68, 0xd0, 0x68}, {0x60, 0xc0, 0x60}, {0x58, 0xb0, 0x58}, {0x50, 0xa0, 0x50},
    {0x48, 0x90, 0x48}, {0x40, 0x80, 0x40}, {0x38, 0x70, 0x38}, {0x30, 0x60, 0x30},
    {0x28, 0x50, 0x28}, {0x20, 0x40, 0x20}, {0x18, 0x30, 0x18}, {0x10, 0x20, 0x10},
    {0x08, 0x10, 0x08}, {0xff, 0x7f, 0xff}, {0xf0, 0x78, 0xf0}, {0xe0, 0x70, 0xe0},
    {0xd0, 0x68, 0xd0}, {0xc0, 0x60, 0xc0}, {0xb0, 0x58, 0xb0}, {0xa0, 0x50, 0xa0},
    {0x90, 0x48, 0x8f}, {0x80, 0x40, 0x80}, {0x70, 0x38, 0x70}, {0x60, 0x30, 0x60},
    {0x50, 0x28, 0x50}, {0x40, 0x20, 0x40}, {0x30, 0x18, 0x30}, {0x20, 0x10, 0x20},
    {0x10, 0x08, 0x10}, {0x00, 0x7f, 0xff}, {0x00, 0x78, 0xf0}, {0x00, 0x70, 0xe0},
    {0x00, 0x68, 0xd0}, {0x00, 0x60, 0xc0}, {0x00, 0x58, 0xb0}, {0x00, 0x50, 0xa0},
    {0x00, 0x48, 0x8f}, {0x00, 0x40, 0x80}, {0x00, 0x38, 0x70}, {0x00, 0x30, 0x60},
    {0x00, 0x28, 0x50}, {0x00, 0x20, 0x40}, {0x00, 0x18, 0x30}, {0x00, 0x10, 0x20},
    {0x00, 0x08, 0x10}, {0xff, 0xf9, 0xcf}, {0xf0, 0xea, 0xc3}, {0xe1, 0xdc, 0xb7},
    {0xd2, 0xcd, 0xab}, {0xc3, 0xbe, 0x9f}, {0xb4, 0xb0, 0x92}, {0xa5, 0xa1, 0x86},
    {0x96, 0x92, 0x7a}, {0x87, 0x84, 0x6e}, {0x78, 0x75, 0x61}, {0x69, 0x66, 0x55},
    {0x5a, 0x58, 0x49}, {0x4b, 0x49, 0x3d}, {0x3c, 0x3a, 0x30}, {0x2d, 0x2c, 0x24},
    {0x1e, 0x1d, 0x18}, {0xff, 0x00, 0x00}, {0xf0, 0x00, 0x00}, {0xe1, 0x00, 0x00},
    {0xd0, 0x00, 0x00}, {0xc0, 0x00, 0x00}, {0xb0, 0x00, 0x00}, {0xa0, 0x00, 0x00},
    {0x90, 0x00, 0x00}, {0x80, 0x00, 0x00}, {0x70, 0x00, 0x00}, {0x60, 0x00, 0x00},
    {0x50, 0x00, 0x00}, {0x40, 0x00, 0x00}, {0x30, 0x00, 0x00}, {0x00, 0x00, 0x00},
};

const uint8_t CLUT4[256][4] = {
    {0x00, 0x00, 0x00, 0x00}, {0x00, 0x00, 0x00, 0xff}, {0xe0, 0xe0, 0xe0, 0xff}, {0xd0, 0xd0, 0xd0, 0xff},
    {0xc0, 0xc0, 0xc0, 0xff}, {0xb0, 0xb0, 0xb0, 0xff}, {0xa0, 0xa0, 0xa0, 0xff}, {0x90, 0x90, 0x90, 0xff},
    {0x80, 0x80, 0x80, 0xff}, {0x70, 0x70, 0x70, 0xff}, {0x60, 0x60, 0x60, 0xff}, {0x50, 0x50, 0x50, 0xff},
    {0x40, 0x40, 0x40, 0xff}, {0x30, 0x30, 0x30, 0xff}, {0x20, 0x20, 0x20, 0xff}, {0x10, 0x10, 0x10, 0xff},
    {0x08, 0x08, 0x08, 0xff}, {0xff, 0x7f, 0x00, 0xff}, {0xf0, 0x78, 0x00, 0xff}, {0xe0, 0x70, 0x00, 0xff},
    {0xd0, 0x68, 0x00, 0xff}, {0xc0, 0x60, 0x00, 0xff}, {0xb0, 0x58, 0x00, 0xff}, {0xa0, 0x50, 0x00, 0xff},
    {0x90, 0x48, 0x00, 0xff}, {0x80, 0x40, 0x00, 0xff}, {0x70, 0x38, 0x00, 0xff}, {0x60, 0x30, 0x00, 0xff},
    {0x50, 0x28, 0x00, 0xff}, {0x40, 0x20, 0x00, 0xff}, {0x30, 0x18, 0x00, 0xff}, {0x20, 0x10, 0x00, 0xff},
    {0x10, 0x08, 0x00, 0xff}, {0xff, 0xff, 0x00, 0xff}, {0xf0, 0xf0, 0x00, 0xff}, {0xe0, 0xe0, 0x00, 0xff},
    {0xd0, 0xd0, 0x00, 0xff}, {0xc0, 0xc0, 0x00, 0xff}, {0xb0, 0xb0, 0x00, 0xff}, {0xa0, 0xa0, 0x00, 0xff},
    {0x90, 0x90, 0x00, 0xff}, {0x80, 0x80, 0x00, 0xff}, {0x70, 0x70, 0x00, 0xff}, {0x60, 0x60, 0x00, 0xff},
    {0x50, 0x50, 0x00, 0xff}, {0x40, 0x40, 0x00, 0xff}, {0x30, 0x30, 0x00, 0xff}, {0x20, 0x20, 0x00, 0xff},
    {0x10, 0x10, 0x00, 0xff}, {0x00, 0x00, 0xff, 0xff}, {0x00, 0x00, 0xf0, 0xff}, {0x00, 0x00, 0xe0, 0xff},
    {0x00, 0x00, 0xd0, 0xff}, {0x00, 0x00, 0xc0, 0xff}, {0x00, 0x00, 0xb0, 0xff}, {0x00, 0x00, 0xa0, 0xff},
    {0x00, 0x00, 0x90, 0xff}, {0x00, 0x00, 0x80, 0xff}, {0x00, 0x00, 0x70, 0xff}, {0x00, 0x00, 0x60, 0xff},
    {0x00, 0x00, 0x50, 0xff}, {0x00, 0x00, 0x40, 0xff}, {0x00, 0x00, 0x30, 0xff}, {0x00, 0x00, 0x20, 0xff},
    {0x00, 0x00, 0x10, 0xff}, {0x00, 0xff, 0x00, 0xff}, {0x00, 0xf0, 0x00, 0xff}, {0x00, 0xe0, 0x00, 0xff},
    {0x00, 0xd0, 0x00, 0xff}, {0x00, 0xc0, 0x00, 0xff}, {0x00, 0xb0, 0x00, 0xff}, {0x00, 0xa0, 0x00, 0xff},
    {0x00, 0x90, 0x00, 0xff}, {0x00, 0x80, 0x00, 0xff}, {0x00, 0x70, 0x00, 0xff}, {0x00, 0x60, 0x00, 0xff},
    {0x00, 0x50, 0x00, 0xff}, {0x00, 0x40, 0x00, 0xff}, {0x00, 0x30, 0x00, 0xff}, {0x00, 0x20, 0x00, 0xff},
    {0x00, 0x10, 0x00, 0xff}, {0x7f, 0x00, 0xff, 0xff}, {0x78, 0x00, 0xf0, 0xff}, {0x70, 0x00, 0xe0, 0xff},
    {0x68, 0x00, 0xd0, 0xff}, {0x60, 0x00, 0xc0, 0xff}, {0x58, 0x00, 0xb0, 0xff}, {0x50, 0x00, 0xa0, 0xff},
    {0x48, 0x00, 0x90, 0xff}, {0x40, 0x00, 0x80, 0xff}, {0x38, 0x00, 0x70, 0xff}, {0x30, 0x00, 0x60, 0xff},
    {0x28, 0x00, 0x50, 0xff}, {0x20, 0x00, 0x40, 0xff}, {0x18, 0x00, 0x30, 0xff}, {0x10, 0x00, 0x20, 0xff},
    {0x08, 0x00, 0x10, 0xff}, {0x7f, 0x7f, 0xff, 0xff}, {0x78, 0x78, 0xf0, 0xff}, {0x70, 0x70, 0xe0, 0xff},
    {0x68, 0x68, 0xd0, 0xff}, {0x60, 0x60, 0xc0, 0xff}, {0x58, 0x58, 0xb0, 0xff}, {0x50, 0x50, 0xa0, 0xff},
    {0x48, 0x48, 0x90, 0xff}, {0x40, 0x40, 0x80, 0xff}, {0x38, 0x38, 0x70, 0xff}, {0x30, 0x30, 0x60, 0xff},
    {0x28, 0x28, 0x50, 0xff}, {0x20, 0x20, 0x40, 0xff}, {0x18, 0x18, 0x30, 0xff}, {0x10, 0x10, 0x20, 0xff},
    {0x08, 0x08, 0x10, 0xff}, {0xff, 0x7f, 0x7f, 0xff}, {0xf0, 0x78, 0x78, 0xff}, {0xe0, 0x70, 0x70, 0xff},
    {0xd0, 0x68, 0x68, 0xff}, {0xc0, 0x60, 0x60, 0xff}, {0xb0, 0x58, 0x58, 0xff}, {0xa0, 0x50, 0x50, 0xff},
    {0x90, 0x48, 0x48, 0xff}, {0x80, 0x40, 0x40, 0xff}, {0x70, 0x38, 0x38, 0xff}, {0x60, 0x30, 0x30, 0xff},
    {0x50, 0x28, 0x28, 0xff}, {0x40, 0x20, 0x20, 0xff}, {0x30, 0x18, 0x18, 0xff}, {0x20, 0x10, 0x10, 0xff},
    {0x10, 0x08, 0x08, 0xff}, {0xff, 0xff, 0x7f, 0xff}, {0xf0, 0xf0, 0x78, 0xff}, {0xe0, 0xe0, 0x70, 0xff},
    {0xd0, 0xd0, 0x68, 0xff}, {0xc0, 0xc0, 0x60, 0xff}, {0xb0, 0xb0, 0x58, 0xff}, {0xa0, 0xa0, 0x50, 0xff},
    {0x90, 0x90, 0x48, 0xff}, {0x80, 0x80, 0x40, 0xff}, {0x70, 0x70, 0x38, 0xff}, {0x60, 0x60, 0x30, 0xff},
    {0x50, 0x50, 0x28, 0xff}, {0x40, 0x40, 0x20, 0xff}, {0x30, 0x30, 0x18, 0xff}, {0x20, 0x20, 0x10, 0xff},
    {0x10, 0x10, 0x08, 0xff}, {0x00, 0xff, 0xff, 0xff}, {0x00, 0xf0, 0xf0, 0xff}, {0x00, 0xe0, 0xe0, 0xff},
    {0x00, 0xd0, 0xd0, 0xff}, {0x00, 0xc0, 0xc0, 0xff}, {0x00, 0xb0, 0xb0, 0xff}, {0x00, 0xa0, 0xa0, 0xff},
    {0x00, 0x90, 0x90, 0xff}, {0x00, 0x80, 0x80, 0xff}, {0x00, 0x70, 0x70, 0xff}, {0x00, 0x60, 0x60, 0xff},
    {0x00, 0x50, 0x50, 0xff}, {0x00, 0x40, 0x40, 0xff}, {0x00, 0x30, 0x30, 0xff}, {0x00, 0x20, 0x20, 0xff},
    {0x00, 0x10, 0x10, 0xff}, {0xff, 0x00, 0x7f, 0xff}, {0xf0, 0x00, 0x78, 0xff}, {0xe0, 0x00, 0x70, 0xff},
    {0xd0, 0x00, 0x68, 0xff}, {0xc0, 0x00, 0x60, 0xff}, {0xb0, 0x00, 0x58, 0xff}, {0xa0, 0x00, 0x50, 0xff},
    {0x90, 0x00, 0x48, 0xff}, {0x80, 0x00, 0x40, 0xff}, {0x70, 0x00, 0x38, 0xff}, {0x60, 0x00, 0x30, 0xff},
    {0x50, 0x00, 0x28, 0xff}, {0x40, 0x00, 0x20, 0xff}, {0x30, 0x00, 0x18, 0xff}, {0x20, 0x00, 0x10, 0xff},
    {0x10, 0x00, 0x08, 0xff}, {0x7f, 0xff, 0x7f, 0xff}, {0x78, 0xf0, 0x78, 0xff}, {0x70, 0xe0, 0x70, 0xff},
    {0x68, 0xd0, 0x68, 0xff}, {0x60, 0xc0, 0x60, 0xff}, {0x58, 0xb0, 0x58, 0xff}, {0x50, 0xa0, 0x50, 0xff},
    {0x48, 0x90, 0x48, 0xff}, {0x40, 0x80, 0x40, 0xff}, {0x38, 0x70, 0x38, 0xff}, {0x30, 0x60, 0x30, 0xff},
    {0x28, 0x50, 0x28, 0xff}, {0x20, 0x40, 0x20, 0xff}, {0x18, 0x30, 0x18, 0xff}, {0x10, 0x20, 0x10, 0xff},
    {0x08, 0x10, 0x08, 0xff}, {0xff, 0x7f, 0xff, 0xff}, {0xf0, 0x78, 0xf0, 0xff}, {0xe0, 0x70, 0xe0, 0xff},
    {0xd0, 0x68, 0xd0, 0xff}, {0xc0, 0x60, 0xc0, 0xff}, {0xb0, 0x58, 0xb0, 0xff}, {0xa0, 0x50, 0xa0, 0xff},
    {0x90, 0x48, 0x8f, 0xff}, {0x80, 0x40, 0x80, 0xff}, {0x70, 0x38, 0x70, 0xff}, {0x60, 0x30, 0x60, 0xff},
    {0x50, 0x28, 0x50, 0xff}, {0x40, 0x20, 0x40, 0xff}, {0x30, 0x18, 0x30, 0xff}, {0x20, 0x10, 0x20, 0xff},
    {0x10, 0x08, 0x10, 0xff}, {0x00, 0x7f, 0xff, 0xff}, {0x00, 0x78, 0xf0, 0xff}, {0x00, 0x70, 0xe0, 0xff},
    {0x00, 0x68, 0xd0, 0xff}, {0x00, 0x60, 0xc0, 0xff}, {0x00, 0x58, 0xb0, 0xff}, {0x00, 0x50, 0xa0, 0xff},
    {0x00, 0x48, 0x8f, 0xff}, {0x00, 0x40, 0x80, 0xff}, {0x00, 0x38, 0x70, 0xff}, {0x00, 0x30, 0x60, 0xff},
    {0x00, 0x28, 0x50, 0xff}, {0x00, 0x20, 0x40, 0xff}, {0x00, 0x18, 0x30, 0xff}, {0x00, 0x10, 0x20, 0xff},
    {0x00, 0x08, 0x10, 0xff}, {0xff, 0xf9, 0xcf, 0xff}, {0xf0, 0xea, 0xc3, 0xff}, {0xe1, 0xdc, 0xb7, 0xff},
    {0xd2, 0xcd, 0xab, 0xff}, {0xc3, 0xbe, 0x9f, 0xff}, {0xb4, 0xb0, 0x92, 0xff}, {0xa5, 0xa1, 0x86, 0xff},
    {0x96, 0x92, 0x7a, 0xff}, {0x87, 0x84, 0x6e, 0xff}, {0x78, 0x75, 0x61, 0xff}, {0x69, 0x66, 0x55, 0xff},
    {0x5a, 0x58, 0x49, 0xff}, {0x4b, 0x49, 0x3d, 0xff}, {0x3c, 0x3a, 0x30, 0xff}, {0x2d, 0x2c, 0x24, 0xff},
    {0x1e, 0x1d, 0x18, 0xff}, {0xff, 0x00, 0x00, 0xff}, {0xf0, 0x00, 0x00, 0xff}, {0xe1, 0x00, 0x00, 0xff},
    {0xd0, 0x00, 0x00, 0xff}, {0xc0, 0x00, 0x00, 0xff}, {0xb0, 0x00, 0x00, 0xff}, {0xa0, 0x00, 0x00, 0xff},
    {0x90, 0x00, 0x00, 0xff}, {0x80, 0x00, 0x00, 0xff}, {0x70, 0x00, 0x00, 0xff}, {0x60, 0x00, 0x00, 0xff},
    {0x50, 0x00, 0x00, 0xff}, {0x40, 0x00, 0x00, 0xff}, {0x30, 0x00, 0x00, 0xff}, {0x00, 0x00, 0x00, 0xff},
};

const uint32_t CLUT4P[256] = {
    0x00000000, 0x000000ff, 0xe0e0e0ff, 0xd0d0d0ff,
    0xc0c0c0ff, 0xb0b0b0ff, 0xa0a0a0ff, 0x909090ff,
    0x808080ff, 0x707070ff, 0x606060ff, 0x505050ff,
    0x404040ff, 0x303030ff, 0x202020ff, 0x101010ff,
    0x080808ff, 0xff7f00ff, 0xf07800ff, 0xe07000ff,
    0xd06800ff, 0xc06000ff, 0xb05800ff, 0xa05000ff,
    0x904800ff, 0x804000ff, 0x703800ff, 0x603000ff,
    0x502800ff, 0x402000ff, 0x301800ff, 0x201000ff,
    0x100800ff, 0xffff00ff, 0xf0f000ff, 0xe0e000ff,
    0xd0d000ff, 0xc0c000ff, 0xb0b000ff, 0xa0a000ff,
    0x909000ff, 0x808000ff, 0x707000ff, 0x606000ff,
    0x505000ff, 0x404000ff, 0x303000ff, 0x202000ff,
    0x101000ff, 0x0000ffff, 0x0000f0ff, 0x0000e0ff,
    0x0000d0ff, 0x0000c0ff, 0x0000b0ff, 0x0000a0ff,
    0x000090ff, 0x000080ff, 0x000070ff, 0x000060ff,
    0x000050ff, 0x000040ff, 0x000030ff, 0x000020ff,
    0x000010ff, 0x00ff00ff, 0x00f000ff, 0x00e000ff,
    0x00d000ff, 0x00c000ff, 0x00b000ff, 0x00a000ff,
    0x009000ff, 0x008000ff, 0x007000ff, 0x006000ff,
    0x005000ff, 0x004000ff, 0x003000ff, 0x002000ff,
    0x001000ff, 0x7f00ffff, 0x7800f0ff, 0x7000e0ff,
    0x6800d0ff, 0x6000c0ff, 0x5800b0ff, 0x5000a0ff,
    0x480090ff, 0x400080ff, 0x380070ff, 0x300060ff,
    0x280050ff, 0x200040ff, 0x180030ff, 0x100020ff,
    0x080010ff, 0x7f7fffff, 0x7878f0ff, 0x7070e0ff,
    0x6868d0ff, 0x6060c0ff, 0x5858b0ff, 0x5050a0ff,
    0x484890ff, 0x404080ff, 0x383870ff, 0x303060ff,
    0x282850ff, 0x202040ff, 0x181830ff, 0x101020ff,
    0x080810ff, 0xff7f7fff, 0xf07878ff, 0xe07070ff,
    0xd06868ff, 0xc06060ff, 0xb05858ff, 0xa05050ff,
    0x904848ff, 0x804040ff, 0x703838ff, 0x603030ff,
    0x502828ff, 0x402020ff, 0x301818ff, 0x201010ff,
    0x100808ff, 0xffff7fff, 0xf0f078ff, 0xe0e070ff,
    0xd0d068ff, 0xc0c060ff, 0xb0b058ff, 0xa0a050ff,
    0x909048ff, 0x808040ff, 0x707038ff, 0x606030ff,
    0x505028ff, 0x404020ff, 0x303018ff, 0x202010ff,
    0x101008ff, 0x00ffffff, 0x00f0f0ff, 0x00e0e0ff,
    0x00d0d0ff, 0x00c0c0ff, 0x00b0b0ff, 0x00a0a0ff,
    0x009090ff, 0x008080ff, 0x007070ff, 0x006060ff,
    0x005050ff, 0x004040ff, 0x003030ff, 0x002020ff,
    0x001010ff, 0xff007fff, 0xf00078ff, 0xe00070ff,
    0xd00068ff, 0xc00060ff, 0xb00058ff, 0xa00050ff,
    0x900048ff, 0x800040ff, 0x700038ff, 0x600030ff,
    0x500028ff, 0x400020ff, 0x300018ff, 0x200010ff,
    0x100008ff, 0x7fff7fff, 0x78f078ff, 0x70e070ff,
    0x68d068ff, 0x60c060ff, 0x58b058ff, 0x50a050ff,
    0x489048ff, 0x408040ff, 0x387038ff, 0x306030ff,
    0x285028ff, 0x204020ff, 0x183018ff, 0x102010ff,
    0x081008ff, 0xff7fffff, 0xf078f0ff, 0xe070e0ff,
    0xd068d0ff, 0xc060c0ff, 0xb058b0ff, 0xa050a0ff,
    0x90488fff, 0x804080ff, 0x703870ff, 0x603060ff,
    0x502850ff, 0x402040ff, 0x301830ff, 0x201020ff,
    0x100810ff, 0x007fffff, 0x0078f0ff, 0x0070e0ff,
    0x0068d0ff, 0x0060c0ff, 0x0058b0ff, 0x0050a0ff,
    0x00488fff, 0x004080ff, 0x003870ff, 0x003060ff,
    0x002850ff, 0x002040ff, 0x001830ff, 0x001020ff,
    0x000810ff, 0xfff9cfff, 0xf0eac3ff, 0xe1dcb7ff,
    0xd2cdabff, 0xc3be9fff, 0xb4b092ff, 0xa5a186ff,
    0x96927aff, 0x87846eff, 0x787561ff, 0x696655ff,
    0x5a5849ff, 0x4b493dff, 0x3c3a30ff, 0x2d2c24ff,
    0x1e1d18ff, 0xff0000ff, 0xf00000ff, 0xe10000ff,
    0xd00000ff, 0xc00000ff, 0xb00000ff, 0xa00000ff,
    0x900000ff, 0x800000ff, 0x700000ff, 0x600000ff,
    0x500000ff, 0x400000ff, 0x300000ff, 0x000000ff
};