//
//  SMIVImage.m
//  Athena
//
//  Created by Scott McClaugherty on 2/13/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SMIVImage.h"
#import "Archivers.h"

static CGColorSpaceRef CLUTCSpace;

@implementation SMIVFrame
@dynamic width, height, offsetX, offsetY;
@synthesize image;
@dynamic size, paddedSize, offsetPoint, length;

+ (void) initialize {
    CGColorSpaceRef devRGB = CGColorSpaceCreateDeviceRGB();
    CLUTCSpace = CGColorSpaceCreateIndexed(devRGB, 255, (uint8 *)CLUT);
    CFRelease(devRGB);
}

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
        image = CGImageCreate(width, height, 8, 8, width, CLUTCSpace, 0, provider, NULL, YES, kCGRenderingIntentDefault);
        free(buffer);
        CFRelease(data);
        CFRelease(provider);
        isQuantitized = YES;
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    if (!isQuantitized) {
        @throw @"Color Quantization on yet implemented";
    }
    [coder encodeUInt16:width];
    [coder encodeUInt16:height];
    [coder encodeUInt16:offsetX];
    [coder encodeUInt16:offsetY];

    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(image));
    const uint8 *buffer = CFDataGetBytePtr(data);
    [coder writeBytes:(void *)buffer length:width * height];
    CFRelease(data);
}

- (NSSize) size {
    return NSMakeSize(width, height);
}

- (NSSize) paddedSize {
    return NSMakeSize(MAX(offsetX, width - offsetX) * 2.0f, MAX(offsetY, height - offsetY) * 2.0f);
}

- (NSPoint) offsetPoint {
    return NSMakePoint(offsetX, offsetY);
}

- (size_t) length {
    return width*height + 8;
}

- (id)initWithImage:(CGImageRef)inImage inRect:(CGRect)rect {
    self = [super init];
    if (self) {
        width = rect.size.width;
        height = rect.size.height;
        offsetX = height / 2;
        offsetY = width / 2;
        image = CGImageCreateWithImageInRect(inImage, rect);
        isQuantitized = NO;
    }
    return self;
}

- (void) drawAtPoint:(NSPoint)point {
    NSSize size = self.size;
    CGRect nrect = CGRectMake(point.x, point.y, size.width, size.height);
//    nrect.origin.x -= offsetX;
//    nrect.origin.x += size.width;// / 2.0f;
//    nrect.origin.y -= offsetY;
//    nrect.origin.y += size.height;// / 2.0f;
    CGContextDrawImage([[NSGraphicsContext currentContext] graphicsPort], nrect, image);
//    [[NSColor yellowColor] setStroke];
//    CGContextStrokeRect([[NSGraphicsContext currentContext] graphicsPort], nrect);
}

- (void) drawInRect:(NSRect)rect {
    CGContextDrawImage([[NSGraphicsContext currentContext] graphicsPort], NSRectToCGRect(rect), image);
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

- (void) encodeResWithCoder:(ResArchiver *)coder {
    if (!isQuantitized) @throw @"Attempted to encode unquantitized frame.";
    [coder setName:title];
    unsigned int frameCount = self.count;
    NSArray *lengths = [frames valueForKeyPath:@"length"];
    unsigned int size = [[lengths valueForKeyPath:@"@sum.intValue"] unsignedIntValue];
    [coder extend:size + frameCount * 4 + 8];
    [coder encodeUInt32:size + frameCount * 4];
    [coder encodeUInt32:frameCount];
    unsigned int acc = 8 + frameCount * 4;
    for (NSNumber *curr in lengths) {
        [coder encodeUInt32:acc];
        acc += [curr unsignedIntValue];
    }
    for (SMIVFrame *frame in frames) {
        [frame encodeResWithCoder:coder];
    }
}

+ (ResType) resType {
    return 'SMIV';
}

+ (NSString *) typeKey {
    return @"SMIV";
}

+ (BOOL) isPacked {
    return NO;
}

- (NSUInteger) count {
    return [frames count];
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
    SMIVFrame *first = [frames objectAtIndex:0];
    SMIVFrame *curr = [frames objectAtIndex:currentFrameId];

    CGPoint foff = NSPointToCGPoint(first.offsetPoint);
    CGPoint coff = NSPointToCGPoint(curr.offsetPoint);
    point.x += (foff.x - coff.x) - masterSize.width / 2;
    point.y += (foff.y - coff.y) - masterSize.height / 2;
    [curr drawAtPoint:point];
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
            [self drawFrame:x + y * width atPoint:NSMakePoint(point.x + x * size.width - 0.5*size.width, point.y + (height - y - 1) * size.height - 0.5*size.height)];
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

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        [self setTitle:[coder decodeString]];
        NSString *baseDir = [coder baseDir];
        NSString *spriteDir = [baseDir stringByAppendingPathComponent:@"Sprites"];
        NSString *spriteName;
        if (![coder isPluginFormat]) {
            spriteDir = [spriteDir stringByAppendingPathComponent:@"Id"];
            spriteName = [coder topKey];
        } else {
            spriteName = title;
        }

        //Retrieve the xml config (only contains the dimensions) and that will be moved into lua anyway.
        NSData *xmlData = [NSData dataWithContentsOfFile:[spriteDir stringByAppendingFormat:@"/%@.xml", [spriteName stringByReplacingOccurrencesOfString:@"/" withString:@":"]]];
        NSError *err = nil;
        NSXMLDocument *configData = [[NSXMLDocument alloc] initWithData:xmlData options:0 error:&err];
        NSXMLElement *dimElem = [[[configData rootElement] elementsForName:@"dimensions"] lastObject];
        int xDim = [[[dimElem attributeForName:@"x"] stringValue] intValue];
        int yDim = [[[dimElem attributeForName:@"y"] stringValue] intValue];
        [configData release];

        //Get the PNG
        NSString *pngName= [spriteDir stringByAppendingFormat:@"/%@.png", spriteName];
        CGDataProviderRef provider = CGDataProviderCreateWithFilename([pngName UTF8String]);
        CGImageRef baseImage = CGImageCreateWithPNGDataProvider(provider, NULL, YES, kCGRenderingIntentDefault);
        CGDataProviderRelease(provider);

        CGSize imageSize = {
            .width = CGImageGetWidth(baseImage),
            .height = CGImageGetHeight(baseImage)
        };

        masterSize = NSMakeSize(imageSize.width / xDim, imageSize.height / yDim);
        //Split it into frames
        count = xDim * yDim;
        for (int i = 0; i < count; i++) {
            int x = i % xDim;
            int y = i / xDim;
            CGRect rect = {
                .origin = {
                    .x = x * masterSize.width,
                    .y = y * masterSize.height
                },
                .size = masterSize
            };

            SMIVFrame *frame = [[SMIVFrame alloc] initWithImage:baseImage inRect:rect];
            [frames addObject:frame];
            [frame release];
        }

        CGImageRelease(baseImage);
        isQuantitized = NO;
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:title];
    if (![coder isPluginFormat]) return;
    NSString *baseDir = [coder baseDir];
    NSString *spriteDir = [baseDir stringByAppendingPathComponent:@"Sprites"];
    NSString *spriteName = title;
    spriteName = [title stringByReplacingOccurrencesOfString:@"/" withString:@":"];

    NSSize grid = [self gridDistribution];
    NSSize fullSize = NSMakeSize(grid.width * masterSize.width, grid.height * masterSize.height);
    NSImage *outImage = [[NSImage alloc] initWithSize:fullSize];
    [outImage lockFocus];
    [self drawSpriteSheetAtPoint:NSZeroPoint];
    [outImage unlockFocus];
    //This seems SO silly!
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithData:[outImage TIFFRepresentation]];
    [outImage release];
    BOOL err;
    NSData *pngData = [rep representationUsingType:NSPNGFileType properties:nil];
    NSString *destPath  = [[spriteDir stringByAppendingPathComponent:spriteName] stringByAppendingPathExtension:@"png"];
    err = [pngData writeToFile:destPath atomically:NO];
    assert(err);
    [rep release];

    NSXMLElement *dimElem = [NSXMLElement elementWithName:@"dimensions"];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithCapacity:2];
    [attrs setObject:[NSNumber numberWithInt:(int)grid.width] forKey:@"x"];
    [attrs setObject:[NSNumber numberWithInt:(int)grid.height] forKey:@"y"];
    [dimElem setAttributesAsDictionary:attrs];
    NSXMLElement *rootElem = [NSXMLElement elementWithName:@"sprite"];
    [rootElem addChild:dimElem];
    NSXMLDocument *doc = [NSXMLDocument documentWithRootElement:rootElem];
    [[doc XMLData] writeToFile:[spriteDir stringByAppendingFormat:@"/%@.xml", spriteName] atomically:NO];
}

+ (BOOL)isComposite {
    return NO;
}

+ (Class)classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end
