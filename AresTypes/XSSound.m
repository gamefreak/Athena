//
//  XSSound.m
//  Athena
//
//  Created by Scott McClaugherty on 7/6/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSSound.h"
#import "Archivers.h"


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

@interface XSSound (Private)
- (void) decodeType1SndFromCoder:(ResUnarchiver *)coder;
- (void) decodeType2SndFromCoder:(ResUnarchiver *)coder;
@end

@implementation XSSound

- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc {
    [sound release];
    [super dealloc];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        short formatType = [coder decodeSwappedSInt16];
        switch (formatType) {
            case 1:
                [self decodeType1SndFromCoder:coder];
                break;
            case 2:
                [self decodeType2SndFromCoder:coder];
                break;
            default:
                @throw [NSString stringWithFormat:@"Unhandled audio format [%h]", formatType];
                break;
        }
    }
    return self;
}

- (void) decodeType1SndFromCoder:(ResUnarchiver *)coder {
//    short formatCount = [coder decodeSwappedSInt16];
//    if (formatCount != 1) {
//        @throw @"Sound containing more than 1 format are not supported";
//    }
    short typeCount = [coder decodeSwappedSInt16];
    if (typeCount != 1) {
        @throw @"Sound containing more than 1 data type are not supported";
    }
    short dataFormat = [coder decodeSwappedSInt16];
    if (dataFormat != SAMPLEDSYNTH) {
        @throw @"Unsupported synth format";
    }
    unsigned int initOpts = [coder decodeSwappedSInt32] & 0xffffffdf;
//    NSLog(@"NAME: %@ ID: %lu", [coder currentName], [coder currentIndex]);
    if (!(initOpts == 0 || initOpts == 0x80) ) {//Assume either nothing or mono and discard the 0x20 flag
        @throw @"Unhandled initialization options";
    }
    short commandCount = [coder decodeSwappedSInt16];
    //Only handle sounds with one command
    if (commandCount != 1) {
        @throw @"Multiple commands unsupported";
    }
    
    unsigned short command = [coder decodeSwappedUInt16];
    if (command != 0x8051) {
        @throw [NSString stringWithFormat:@"Unhandled sound command %4x", command];
    }
    
//    short param1 = [coder decodeSInt16];//param 1 is unused
    [coder skip:2u];
    unsigned int headerLocation = [coder decodeSwappedUInt32];
    [coder seek:headerLocation];
    
    
    unsigned int bufferOffset = [coder decodeUInt32];
    unsigned int bufferLength = [coder decodeSwappedUInt32];
    unsigned int sampleRate = [coder decodeSwappedUInt32];
    //    unsigned int sampleRate = [coder decodeUInt32];
    switch (sampleRate) {
        case RATE32KHZ: 
        case RATE22050HZ:
        case RATE22KHZ:
        case RATE16KHZ:
        case RATE11KHZ:
        case RATE11025HZ:
        case RATE8KHZ:
            break;
        default:
            @throw [NSString stringWithFormat:@"Unsupported rate 0x%08x", sampleRate];
            break;
    }
    int loopStart = [coder decodeSwappedSInt32];
    int loopEnd = [coder decodeSwappedSInt32];
    char sampleEncoding = [coder decodeSInt8];
    char baseFreq = [coder decodeSInt8];
    //#define kMiddleC 60
    char *buffer = malloc(bufferLength);
    [coder readBytes:buffer length:bufferLength];
    
    free(buffer);
}

- (void) decodeType2SndFromCoder:(ResUnarchiver *)coder {
    short refCount = [coder decodeSInt16];
    if (refCount != 0) {
        NSLog(@"NOTICE: nonzero refcount in snd data");
    }
    short commandCount = [coder decodeSwappedSInt16];
    if (commandCount != 1) {
        @throw [NSString stringWithFormat:@"snd  resources with more than one command are unspported [%hi]", commandCount];
    }
    unsigned short command = [coder decodeSwappedUInt16];
    if (command != 0x8051) {
        @throw [NSString stringWithFormat:@"Unhandled sound command %4x", command];
    }
    
//    short param1 = [coder decodeSInt16];//param 1 is unused
    [coder skip:2u];
    unsigned int headerLocation = [coder decodeSwappedUInt32];
    [coder seek:headerLocation];
    
    unsigned int bufferOffset = [coder decodeUInt32];
    unsigned int bufferLength = [coder decodeSwappedUInt32];
    unsigned int sampleRate = [coder decodeSwappedUInt32];
//    unsigned int sampleRate = [coder decodeUInt32];
    switch (sampleRate) {
        case RATE32KHZ: 
        case RATE22050HZ:
        case RATE22KHZ:
        case RATE16KHZ:
        case RATE11KHZ:
        case RATE11025HZ:
        case RATE8KHZ:
            break;
        default:
            @throw [NSString stringWithFormat:@"Unsupported rate 0x%08x", sampleRate];
            break;
    }
    int loopStart = [coder decodeSwappedSInt32];
    int loopEnd = [coder decodeSwappedSInt32];
    char sampleEncoding = [coder decodeSInt8];
    char baseFreq = [coder decodeSInt8];
//#define kMiddleC 60
    char *buffer = malloc(bufferLength);
    [coder readBytes:buffer length:bufferLength];
    
    free(buffer);
}


- (void)encodeResWithCoder:(ResArchiver *)coder {
}

+ (NSString *)typeKey {
    return @"snd";
}

+ (ResType)resType {
    return 'snd ';
}

+ (BOOL)isPacked {
    return NO;
}

//+ (size_t)sizeOfResourceItem {
//    return  1000;
//}
@end
