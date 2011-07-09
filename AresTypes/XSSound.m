//
//  XSSound.m
//  Athena
//
//  Created by Scott McClaugherty on 7/6/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSSound.h"
#import "Archivers.h"

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
    free(buffer);
    [super dealloc];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        sound = [[NSSound alloc] initWithData:[coder rawData]];
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
    short typeCount = [coder decodeSwappedSInt16];
    if (typeCount != 1) {
        @throw @"Sound containing more than 1 data type are not supported";
    }
    short dataFormat = [coder decodeSwappedSInt16];
    if (dataFormat != SAMPLEDSYNTH) {
        @throw @"Unsupported synth format";
    }
    unsigned int initOpts = [coder decodeSwappedSInt32] & 0xffffffdf;
    //Assume either nothing or mono and discard the 0x20 flag
    if (!(initOpts == 0 || initOpts == INITMONO) ) {
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
    bufferLength = [coder decodeSwappedUInt32];
    sampleRate = [coder decodeSwappedUInt32];
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
    buffer = malloc(bufferLength);
    [coder readBytes:buffer length:bufferLength];
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

    bufferLength = [coder decodeSwappedUInt32];
    sampleRate = [coder decodeSwappedUInt32];
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
    buffer = malloc(bufferLength);
    [coder readBytes:buffer length:bufferLength];
}


- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt16:1];//format 1
    [coder encodeSInt16:1];//1 data type encoded
    [coder encodeSInt16:SAMPLEDSYNTH];//data format
    [coder encodeUInt32:INITMONO];//initialization options
    [coder encodeSInt16:1];//1 command
    [coder encodeUInt16:0x8051];//bufferCommand
    [coder skip:2];//skip param 1
    [coder encodeUInt32:SOUNDHEADERLOC];//param 2 (the location of the sound header)
    [coder encodeUInt32:0];//no offset
    
    [coder encodeUInt32:bufferLength];
    [coder encodeUInt32:sampleRate];
    
    //I don't know what to do here
    [coder encodeSInt32:1];//loop start
    [coder encodeSInt32:2];//loop end
    
    [coder encodeSInt8:0];//sample encoding I dunno what it does
    [coder encodeUInt8:kMiddleC];//base frequency
    [coder writeBytes:buffer length:bufferLength];
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
@end
