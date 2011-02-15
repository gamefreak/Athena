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
@synthesize width, height, offsetX, offsetY;
@synthesize bytes, image;
@dynamic size, offset, length;

- (id) init {
    @throw @"DO NOT USE";
}

- (void) dealloc {
    [image release];
    free(bytes);
    [super dealloc];
}

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        width = [coder decodeUInt16];
        height = [coder decodeUInt16];
        offsetX = [coder decodeSInt16];
        offsetY = [coder decodeSInt16];
        bytes = malloc(width * height * 4);
        uint8 *buffer = malloc(width * height);
        [coder readBytes:buffer length:(width * height)];
        int count = width*height;
        for (int ctr = 0; ctr < count; ctr++) {
            bytes[ctr] = (CLUT_COLOR(buffer[ctr]));
        }
        free(buffer);

        image = [[NSBitmapImageRep alloc]
                 initWithBitmapDataPlanes:(uint8**)&bytes
                 pixelsWide:width
                 pixelsHigh:height
                 bitsPerSample:8
                 samplesPerPixel:4
                 hasAlpha:YES
                 isPlanar:NO
                 colorSpaceName:NSDeviceRGBColorSpace
                 bitmapFormat:NSAlphaFirstBitmapFormat
                 bytesPerRow:(4*width)
                 bitsPerPixel:32];
    }
    return self;
}

//- (void) encodeResWithCoder:(ResArchiver *)coder {}

- (NSSize) size {
    return NSMakeSize(width, height);
}

- (NSPoint) offset {
    return NSMakePoint(offsetX, offsetY);
}

- (size_t) length {
    return width*height + 8;
}

- (NSRect) frameRect {
//    CGFloat x = offsetX;
//    CGFloat y = offsetY;
//    x -= width/2.0f;
////    y = height/2 - y;
////    y = (height - y) - height/2;
//    y = (height/2.0f - y);
//    x= y =0;
//    NSLog(@"OFFSET: %f, %f; SIZE: %hu, %hu", x, y, width, height);
    return NSMakeRect(0, 0, width, height);
}


- (BOOL) draw {
    return [image drawInRect:NSMakeRect(0, 0, width, height)
                    fromRect:[self frameRect]
                   operation:NSCompositeSourceOver
                    fraction:1.0f
              respectFlipped:NO
                       hints:nil];
}

- (BOOL) drawAtPoint:(NSPoint)point {
//    NSMakeRect(point.x-(offsetX-width/2.0f), point.y-(height/2.0f-offsetY), width, height)
    return [image drawInRect:NSMakeRect(point.x, point.y, width, height)
                    fromRect:[self frameRect]
                   operation:NSCompositeSourceOver
                    fraction:1.0f
              respectFlipped:NO
                       hints:nil];
}

- (BOOL) drawInRect:(NSRect)rect {
    return [image drawInRect:rect
                    fromRect:[self frameRect]
                   operation:NSCompositeSourceOver
                    fraction:1.0f
              respectFlipped:NO
                       hints:nil];
}

@end


@implementation SMIVImage
@synthesize title, frames;
@dynamic count;
@dynamic frame;
@dynamic size;

//WARNING: HACK FOR NSDictionaryController you probably want -mutableCopy
- (id)copyWithZone:(NSZone *)zone {
    return [self retain];
}

- (id) init {
    self = [super init];
    if (self) {
        title = @"";
        frames = [[NSMutableArray alloc] init];
        count = 0;
        currentFrameId = 0;
    }
    
    return self;
}

- (void) dealloc {
    [title release];
    [frames release];
    [super dealloc];
}

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        self.title = [coder currentName];

        unsigned int size = [coder decodeUInt32];
        NSAssert(size == [coder currentSize] - 8, @"SMIV resource is invalid");
        unsigned int frameCount = [coder decodeUInt32];
        unsigned int offsets[frameCount];
        for (int k = 0; k < frameCount; k++) {
            offsets[k] = [coder decodeUInt32];
        }

        for (unsigned int framex = 0; framex < frameCount; framex++) {
            [coder seek:offsets[framex]];
            SMIVFrame *frame = [[SMIVFrame alloc] initWithResArchiver:coder];
            [frames addObject:frame];
            count++;
            [frame release];
        }
    }
    return self;
}

//- (void) encodeResWithCoder:(ResArchiver *)coder {}

+ (ResType) resType {
    return 'SMIV';
}

+ (NSString *) typeKey {
    return @"SMIV";
}

+ (BOOL) isPacked {
    return NO;
}

- (void)setFrame:(NSUInteger)frame {
    currentFrameId = frame;
}

- (NSUInteger)frame {
    return currentFrameId;
}

- (NSUInteger) nextFrame {
    return currentFrameId = (currentFrameId+1)%count;
}

- (NSUInteger) previousFrame {
    currentFrameId--;
    if (currentFrameId >= count) {
        currentFrameId = count - 1;
    }
    return currentFrameId;
}

- (NSSize) size {
    return [[frames objectAtIndex:currentFrameId] size];
}

- (BOOL)draw {
    return [[frames objectAtIndex:currentFrameId] draw];
}

- (BOOL)drawAtPoint:(NSPoint)point {
    return [[frames objectAtIndex:currentFrameId] drawAtPoint:point];
}

- (BOOL)drawInRect:(NSRect)rect {
    return [[frames objectAtIndex:currentFrameId] drawInRect:rect];
}

- (BOOL)drawFrame:(NSUInteger)frame {
    return [[frames objectAtIndex:frame] draw];
}

- (BOOL)drawFrame:(NSUInteger)frame atPoint:(NSPoint)point {
    return [[frames objectAtIndex:frame] drawAtPoint:point];
}

- (BOOL)drawFrame:(NSUInteger)frame inRect:(NSRect)rect {
    return [[frames objectAtIndex:frame] drawInRect:rect];
}
@end
