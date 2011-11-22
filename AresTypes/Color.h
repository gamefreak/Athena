//
//  Color.h
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//
#import <stdint.h>

typedef enum {
    ClutGray,//0
    ClutOrange,//1
    ClutYellow,//2
    ClutBlue,//3
    ClutGreen,//4
    ClutPurple,//5
    ClutIndigo,//6
    ClutSalmon,//7
    ClutGold,//8
    ClutAqua,//9
    ClutPink,//10
    ClutPaleGreen,//11
    ClutPalePurple,//12
    ClutSkyBlue,//13
    ClutTan,//14
    ClutRed,//15
    ClutNone = 0xff,//for shields
} ClutColor;

extern inline uint32_t dequantitize_pixel(uint8_t pixel);
extern inline uint32_t pixel_magnitude(uint32_t pixel, uint32_t color);
extern uint8_t quantitize_pixel(uint32_t pixel);
extern inline uint8_t quantitize_pixel_fast(uint32_t pixel);
extern void rclut_init();

extern const uint32_t CLUT_ID;

extern const uint8_t CLUT[256][3];
extern const uint8_t CLUT4[256][4];
extern const uint32_t CLUT4P[256];
extern const uint8_t *RCLUT;

#define CLUT_COLOR(index) CLUT[(index & 0xff)]
#define CLUT_COLOR2(index, value) CLUT[(index & 0x0f) + (value & 0xf0)]
