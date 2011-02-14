//
//  SMIVImage.m
//  Athena
//
//  Created by Scott McClaugherty on 2/13/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SMIVImage.h"
#import "ResUnarchiver.h"

@implementation SMIVFrame
@synthesize width, height, offsetX, offsetY, image;

- (id)init {
    @throw @"DO NOT USE";
}

- (void)dealloc {
    CGImageRelease(image);
    [super dealloc];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        width = [coder decodeUInt16];
        height = [coder decodeUInt16];
        offsetX = [coder decodeSInt16];
        offsetY = [coder decodeSInt16];
        uint32 *bytes = malloc(width * height * 4);
        uint8 *buffer = malloc(width * height);
        [coder readBytes:buffer length:(width * height)];
        int count = width*height;
        for (int ctr = 0; ctr < count; ctr++) {
            bytes[ctr] = (CLUT_COLOR(buffer[ctr]));
        }
         free(buffer);

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bytes, 4*width*height, NULL);
        image = CGImageCreate(width, height, 8, 32, 4 * width, colorSpace, kCGImageAlphaFirst, provider, NULL, NO, kCGRenderingIntentDefault);
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpace);
//        free(bytes); //CGDataProviderCreateWithData does not copy
        //This could cause some memory issues
    }
    return self;
}

//- (void)encodeResWithCoder:(ResArchiver *)coder {}

@end


@implementation SMIVImage
@synthesize frames;
@dynamic count;

- (id)init {
    self = [super init];
    if (self) {
        frames = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [frames release];
    [super dealloc];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        unsigned int size = [coder decodeUInt32];
#pragma unused(size)
        unsigned int frameCount = [coder decodeUInt32];
        unsigned int offsets[frameCount];
        for (int k = 0; k < frameCount; k++) {
            offsets[k] = [coder decodeUInt32];
        }

        for (unsigned int framex = 0; framex < frameCount; framex++) {
            [coder seek:offsets[framex]];
            SMIVFrame *frame = [[SMIVFrame alloc] initWithResArchiver:coder];
            [frames addObject:frame];
            [frame release];
        }
    }
    return self;
}

//- (void)encodeResWithCoder:(ResArchiver *)coder {}

+ (ResType)resType {
    return 'SMIV';
}

+ (NSString *)typeKey {
    return @"SMIV";
}

+ (BOOL)isPacked {
    return NO;
}

- (NSUInteger) count {
    return [frames count];
}

@end
