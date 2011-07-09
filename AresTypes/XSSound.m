//
//  XSSound.m
//  Athena
//
//  Created by Scott McClaugherty on 7/6/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSSound.h"
#import "Archivers.h"
#import <AudioToolbox/AudioToolbox.h>
//#import <CarbonS
//typedef struct {//don't forget to swap from big-endian
//    short format;//should be 2 
//    short referenceCount; //should usually be 0, but it doesn't matter
//    short commandCount;//PRAY that it is 1
//    struct {
//        bool offsetFlag:1;//should be set
//        short cmd:15;//hope for 0x51 = bufferCMD
//        short param1;//ignore
//        short param2;//offset for buffer header (from start)
//    } command;//would be an array but we aren't handling multiple commands yet
//    struct {
//    } header;
//    uint8 buffer[];
//} sndData;


#define RATE32KHZ 0x7D000000
#define RATE22050HZ 0x56220000
#define RATE22KHZ 0x56EE8BA3
#define RATE16KHZ 0x3E800000
#define RATE11KHZ 0x2B7745D1
#define RATE11025HZ 0x2B110000
#define RATE8KHZ 0x1F400000  

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
    short formatCount = [coder decodeSInt16];
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
