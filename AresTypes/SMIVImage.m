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
@dynamic width, height, offsetX, offsetY;
@synthesize image;
@dynamic size, paddedSize, offset, length;

- (id) init {
    @throw @"DO NOT USE";
}

- (void) dealloc {
    CGImageRelease(image);
    [super dealloc];
}

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        width = [coder decodeUInt16];
        height = [coder decodeUInt16];
        offsetX = [coder decodeSInt16];
        offsetY = [coder decodeSInt16];
        uint8 *buffer = malloc(width * height);
        [coder readBytes:buffer length:(width * height)];
        CFDataRef data = CFDataCreate(NULL, buffer, width*height);
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
        CGColorSpaceRef devRGB = CGColorSpaceCreateDeviceRGB();
        CGColorSpaceRef cspace = CGColorSpaceCreateIndexed(devRGB, 255, (uint8 *)CLUT);
        image = CGImageCreate(width, height, 8, 8, width, cspace, 0, provider, NULL, YES, kCGRenderingIntentDefault);
        free(buffer);
        CFRelease(data);
        CFRelease(devRGB);
        CFRelease(cspace);
        CFRelease(provider);
    }
    return self;
}

//- (void) encodeResWithCoder:(ResArchiver *)coder {}

- (NSSize) size {
    return NSMakeSize(width, height);
}

- (NSSize) paddedSize {
    return NSMakeSize(MAX(offsetX, width - offsetX) * 2.0f, MAX(offsetY, height - offsetY) * 2.0f);
}

- (NSPoint) offset {
    return NSMakePoint(offsetX, offsetY);
}

- (size_t) length {
    return width*height + 8;
}

- (void) drawAtPoint:(NSPoint)point {
    NSPoint offset = self.offset;
    NSSize size = self.size;
    CGRect nrect = CGRectMake(point.x, point.y, size.width, size.height);
    nrect.origin.x -= offsetX;
//    nrect.origin.x += size.width;// / 2.0f;
    nrect.origin.y -= offsetY;
//    nrect.origin.y += size.height;// / 2.0f;
    CGContextDrawImage([[NSGraphicsContext currentContext] graphicsPort], nrect, image);
}

- (void) drawInRect:(NSRect)rect {
    CGContextDrawImage([[NSGraphicsContext currentContext] graphicsPort], rect, image);
}

@end


@implementation SMIVImage
@synthesize title, frames;
@dynamic count;
@dynamic frame;
@dynamic size;
@synthesize masterSize;

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
        masterSize = NSMakeSize(0.0f, 0.0f);
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
            NSSize newSize = frame.paddedSize;
            masterSize.width = MAX(masterSize.width, newSize.width);
            masterSize.height = MAX(masterSize.height, newSize.height);
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

- (void)drawAtPoint:(NSPoint)point {
    [(SMIVFrame *)[frames objectAtIndex:currentFrameId] drawAtPoint:point];
}

- (void)drawInRect:(NSRect)rect {
    [(SMIVFrame *)[frames objectAtIndex:currentFrameId] drawInRect:rect];
}

- (void)drawFrame:(NSUInteger)frame atPoint:(NSPoint)point {
    [(SMIVFrame *)[frames objectAtIndex:frame] drawAtPoint:NSMakePoint(point.x + masterSize.width/2.0f, point.y + masterSize.height / 2.0f)];
}

- (void)drawFrame:(NSUInteger)frame inRect:(NSRect)rect {
    [(SMIVFrame *)[frames objectAtIndex:frame] drawInRect:rect];
}

- (void) drawSpriteSheetAtPoint:(NSPoint)point {
    NSSize gdim = [self gridDistribution];
    NSSize size = [self masterSize];
    int width = gdim.width;
    int height = gdim.height;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            [self drawFrame:x + y * width atPoint:NSMakePoint(point.x + x * size.width, point.y + (height - y) * size.height)];
        }
    }
}

/*
 * Calculate the grid that the frames will be layed out on.
 * The goal is to minimize the difference between the width and height, then
 * flip it so that the grid is taller than it is wide unless the longest dimension
 * is less than or equal to 8
 */
- (NSSize) gridDistribution {
    //The width with the lowest difference from the height so far
    int best = 1;
    //difference for the previous value
    int bestDiff = count - best;
    //We don't need to test past sqrt(count)
    int max = ceilf(sqrtf(count));
    for (int width = 1; width <=  max; width++) {
        if (fmodf(count, width) != 0.0f) {
            //The grid won't be rectangular for this width
            continue;//so skip
        }
        //width - height
        int diff = abs(width - count/width);
        if (diff < bestDiff) {
            best = width;
            bestDiff = diff;
        }
    }
    int a = best;
    int b = count / best;
    if (a < b) {//swap if a is less than b
        a ^= b, b ^= a, a ^= b;
    }
    if (a <= 8) {
        return NSMakeSize(a, b);
    } else {
        return NSMakeSize(b, a);
    }
}
@end
