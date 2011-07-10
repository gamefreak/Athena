//
//  XSSound.h
//  Athena
//
//  Created by Scott McClaugherty on 7/6/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResCoding.h"

#define RATE32KHZ 0x7D000000
#define RATE22050HZ 0x56220000
#define RATE22KHZ 0x56EE8BA3
#define RATE16KHZ 0x3E800000
#define RATE11KHZ 0x2B7745D1
#define RATE11025HZ 0x2B110000
#define RATE8KHZ 0x1F400000

#define SAMPLEDSYNTH 5
#define SQUAREWAVESYNTH 1
#define WAVETABLESYNTH 3

#define INITMONO 0x80

#define kMiddleC 60

//Because the encoder will always write to the same spot this is being hardcoded
#define SOUNDHEADERLOC 20


@interface XSSound : NSObject <ResCoding> {
@private
    uint32 bufferLength;
    uint32 sampleRate;
    void *buffer;
}
- (void) play;
@end
