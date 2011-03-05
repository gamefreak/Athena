//
//  SMIVImage.m
//  Athena
//
//  Created by Scott McClaugherty on 2/13/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SMIVImage.h"
#import "ResUnarchiver.h"

SMIVRect SMIVRectMake(CGFloat centerX, CGFloat centerY, CGFloat width, CGFloat height) {
    SMIVRect rect = {centerX, width - centerX, centerY, height - centerY};
    return rect;
}


SMIVRect SMIVUnionRects(SMIVRect a, SMIVRect b) {
    SMIVRect rect = {
    MAX(a.top, b.top), MAX(a.bottom, b.bottom),
    MAX(a.left, b.left), MAX(a.right, b.right)
    };
    return rect;
}

NSSize SMIVRectSize(SMIVRect rect) {
    return NSMakeSize(rect.top + rect.bottom, rect.left + rect.right);
}

@implementation SMIVFrame
@dynamic width, height, offsetX, offsetY;
@synthesize image , rect;
@dynamic size, offset, length;

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
        short width = [coder decodeUInt16];
        short height = [coder decodeUInt16];
        short offsetX = [coder decodeSInt16];
        short offsetY = [coder decodeSInt16];
        rect = SMIVRectMake(offsetX, height - offsetY, width, height);
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

- (int) offsetX {
    return (rect.left / 2 - rect.right / 2);
}

- (int) offsetY {
    return -(rect.top / 2 - rect.bottom / 2);
}

- (int) width {
    return rect.left + rect.right;
}

- (int) height {
    return rect.top + rect.bottom;
}

- (NSSize) size {
    return SMIVRectSize(rect);
}

- (NSPoint) offset {
    return NSMakePoint(self.offsetX, self.offsetY);
}

- (size_t) length {
    NSSize size = self.size;
    return size.width*size.height + 8;
}

- (void) drawAtPoint:(NSPoint)point {
    NSPoint offset = self.offset;
    NSSize size = self.size;
    CGRect rect = CGRectMake(point.x+self.offsetX, point.y+self.offsetY, size.width, size.height);
    CGContextDrawImage([[NSGraphicsContext currentContext] graphicsPort], rect, image);
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
@synthesize masterRect;

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
            if (framex == 0) {
                masterRect = frame.rect;
            }
            masterRect = SMIVUnionRects(masterRect, frame.rect);
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
    [(SMIVFrame *)[frames objectAtIndex:frame] drawAtPoint:point];
}

- (void)drawFrame:(NSUInteger)frame inRect:(NSRect)rect {
    [(SMIVFrame *)[frames objectAtIndex:frame] drawInRect:rect];
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
