//
//  SMIVImage.m
//  Athena
//
//  Created by Scott McClaugherty on 2/13/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SMIVImage.h"
#import "Archivers.h"

#define FRAME_HEADER_SIZE 8

static CGColorSpaceRef CLUTCSpace;
static CGColorSpaceRef devRGB;

static uint32 dequantitize_pixel(uint8 pixel);
static int pixel_magnitude(uint32 pixel);
static uint8 quantitize_pixel(uint32 pixel);

static uint32 dequantitize_pixel(uint8 pixel) {
    return *(uint32*)CLUT4[pixel];
}

static int pixel_magnitude(uint32 pixel) {
    int sum = 0;
    int r = (pixel & 0xff000000) >> 24;
    sum += r * r;
    int g = (pixel & 0x00ff0000) >> 16;
    sum += g * g;
    int b = (pixel & 0x0000ff00) >> 8;
    sum += b * b;
    return sum;
}

static uint8 quantitize_pixel(uint32 pixel) {
    short alpha = (pixel & 0x000000ff) >> 0;
    if (alpha < 0xf0) return 0;//transparent
    int sum = pixel_magnitude(pixel);
    int bestIdx = 0;
    int bestDiff = UINT32_MAX;
    for (int i = 1; i <= 256; i++) {
        int cmag = pixel_magnitude(*CLUT4[i]);
        int diff = ABS(cmag - sum);
        if (diff == 0) return i;
        if (diff < bestDiff) {
            bestDiff = diff;
            bestIdx = i;
        }
    }
    return bestIdx;
}

@implementation SMIVImage
@synthesize title;
@synthesize cellSize;
@dynamic count;
@synthesize frames;
@synthesize image;

- (int)count {
    return [frames count];
}

+ (void) initialize {
    //prepare these ahead of time
    devRGB = CGColorSpaceCreateDeviceRGB();
    CLUTCSpace = CGColorSpaceCreateIndexed(devRGB, 255, (uint8 *)CLUT);
}

- (id)init {
    self = [super init];
    if (self) {
        title = @"";
        frames = [[NSMutableArray alloc] init];
        image = NULL;
    }
    return self;
}

- (void)dealloc {
    [title release];
    [frames release];
    CGImageRelease(image);
    [super dealloc];
}

//WARNING: HACK FOR NSDictionaryController you probably want -mutableCopy
- (id)copyWithZone:(NSZone *)zone {
    return [self retain];
}

#pragma mark Image inits;
- (id)initWithAnimation:(NSBitmapImageRep *)rep named:(NSString *)name {
    self = [self init];
    if (self) {
        [self setTitle:name];
        int count = [[rep valueForProperty:NSImageFrameCount] intValue];
        cellSize = NSSizeToCGSize([rep size]);
        assert(!CGSizeEqualToSize(cellSize, CGSizeZero));
        //Create the master image
        CGSize arrangement = [SMIVImage gridDistributionForCount:count];//knowing how to arrange the cells
        CGSize imageDimensions = CGSizeMake(arrangement.width * cellSize.width, arrangement.height * cellSize.height);
        CGContextRef context = CGBitmapContextCreate(NULL, imageDimensions.width, imageDimensions.height, 8, imageDimensions.width * 4, devRGB, kCGImageAlphaPremultipliedLast);

        for (int k = 0; k < count; k++) {
            //I hate this design
            [rep setProperty:NSImageCurrentFrame withValue:[NSNumber numberWithInt:k]];
            CGImageRef frame = [rep CGImage];
            int xLoc = k%((int)arrangement.width);
            int yLoc = (int)k/(int)arrangement.width;
            CGRect rect = CGRectMake(cellSize.width * xLoc, cellSize.height * (arrangement.height - yLoc - 1), cellSize.width, cellSize.height);
            CGContextDrawImage(context, rect, frame);
        }
        image = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        for (int k = 0; k < count; k++) {
            int xLoc = k%((int)arrangement.width);
            int yLoc = k/(int)arrangement.width;
            CGRect rect = CGRectMake(cellSize.width * xLoc, cellSize.height * yLoc, cellSize.width, cellSize.height);
            [frames addObject:[[[SMIVFrame alloc] initWithImage:image inRect:rect] autorelease]];
        }
    }
    return self;
}

#pragma mark Resource Methods

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        [self setTitle:[coder currentName]];

        //Check data size
        unsigned int sizeOfAnimation = [coder decodeUInt32];
        NSAssert(sizeOfAnimation == [coder currentSize] - 8, @"SMIV resource has incorrect size: %ui != %ui", sizeOfAnimation, [coder currentSize] - 8);

        //Get frame header locations
        unsigned int frameCount = [coder decodeUInt32];
        unsigned int headerLocations[frameCount];
        for (int k = 0; k < frameCount; k++) {
            headerLocations[k] = [coder decodeUInt32];
        }
        
        //Get headers
        for (int k = 0; k < frameCount; k++) {
            [coder seek:headerLocations[k]];
            [frames addObject:[[[SMIVFrame alloc] initWithResArchiver:coder] autorelease]];
        }

        //calculate the overall size of each cell in the spritesheet
        CGFloat overallWidth = [[frames valueForKeyPath:@"@max.paddedWidth"] floatValue];
        CGFloat overallHeight = [[frames valueForKeyPath:@"@max.paddedHeight"] floatValue];
        cellSize = CGSizeMake(overallWidth, overallHeight);
        //make all of the frames know this!
        [frames setValue:[NSValue valueWithSize:cellSize] forKeyPath:@"cellSize"];
        
        //Now create the master image
        CGSize arrangement = [SMIVImage gridDistributionForCount:frameCount];//knowing how to arrange the cells
        CGSize imageDimensions = CGSizeMake(arrangement.width * cellSize.width, arrangement.height * cellSize.height);
        //First make a graphics context to draw into
        CGContextRef context = CGBitmapContextCreate(NULL, imageDimensions.width, imageDimensions.height, 8, imageDimensions.width * 4, devRGB, kCGImageAlphaPremultipliedLast);
        //We will need to save the destination rectangles because the main image won't be created during the loop
        CGRect rectArray[frameCount];
        //load load each image and draw it into the sheet
        for (int k = 0; k < frameCount; k++) {
            //I would have used the iterator but we need the frame header location
            SMIVFrame *frame = [frames objectAtIndex:k];
            [coder seek:headerLocations[k] + FRAME_HEADER_SIZE];
            size_t byteSize = frame.width * frame.height;
            //read the pixels in
            uint8 *preBuffer = malloc(byteSize);
            [coder readBytes:preBuffer length:byteSize];
            uint32 *buffer = malloc(byteSize * 4);
            //convert pixels from INDEXED8 to RGBA32
            for (int i = 0; i < byteSize; i++) {
                buffer[i] = dequantitize_pixel(preBuffer[i]);
            }
            free(preBuffer);
            CFDataRef data = CFDataCreate(kCFAllocatorDefault, (void *)buffer, byteSize * 4);//Capture the data
            CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);//make a straw...
            CGImageRef frameImage = CGImageCreate(frame.width, frame.height, 8, 32, frame.width * 4, devRGB, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast, provider, NULL, YES, kCGRenderingIntentDefault);
            CGDataProviderRelease(provider);
            CFRelease(data);
            free(buffer);
            //We have the subimage, so draw it onto the sheet
            //Find grid position
            int xLoc = k%((int)arrangement.width);
            int yLoc = k/(int)arrangement.width;
            //Calculating these offsets is a pain
            CGRect destRect;
            destRect.origin.x = xLoc * cellSize.width + cellSize.width * 0.5 - frame.xOffset;
            destRect.origin.y = (arrangement.height - yLoc - 0.5f) * cellSize.height - (frame.height - frame.yOffset);
            destRect.size.width = frame.width;
            destRect.size.height = frame.height;
            //Finally draw it
            CGContextDrawImage(context, destRect, frameImage);
            CGImageRelease(frameImage);
            //Temporarily save the rect
            rectArray[k] = destRect;
        }
        image = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        //to reduce memory usage use a subimage instead of separate image
        //this is retained for to simplify saving the animations purposes
        for (int k = 0; k < frameCount; k++) {
            CGImageRef slice = CGImageCreateWithImageInRect(image, rectArray[k]);
            [[frames objectAtIndex:k] setSlice:slice];
            CGImageRelease(slice);
        }
        
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder setName:title];
    unsigned int frameCount = [frames count];
    NSArray *lengths = [frames valueForKeyPath:@"length"];
    unsigned int size = [[lengths valueForKeyPath:@"@sum.intValue"] unsignedIntValue];
    [coder extend:size + frameCount * 4 + 8];
    [coder encodeUInt32:size + frameCount * 4];
    [coder encodeUInt32:frameCount];
    unsigned int accumulator = 8 + frameCount * 4;
    for (NSNumber *current in lengths) {
        [coder encodeUInt32:accumulator];
        accumulator += [current unsignedIntValue];
    }
    for (SMIVFrame *frame in frames) {
        [frame encodeResWithCoder:coder];
    }
}

+ (ResType)resType {
    return 'SMIV';
}

+ (NSString *)typeKey {
    return @"SMIV";
}

+ (BOOL)isPacked {
    return NO;
}

#pragma mark Lua Methods

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

        //Retrieve XML config for sprite arrangement (will be moved into lua)
        NSData *xmlData = [NSData dataWithContentsOfFile:[spriteDir stringByAppendingFormat:@"/%@.xml", [spriteName stringByReplacingOccurrencesOfString:@"/" withString:@":"]]];
        NSError *err = nil;
        NSXMLDocument *configData = [[NSXMLDocument alloc] initWithData:xmlData options:0 error:&err];
        NSXMLElement *dimElement = [[[configData rootElement] elementsForName:@"dimensions"] lastObject];
        int xDim = [[[dimElement attributeForName:@"x"] stringValue] intValue];
        int yDim = [[[dimElement attributeForName:@"y"] stringValue] intValue];
        [configData release];

        //Get the PNG
        NSString *pngName = [spriteDir stringByAppendingFormat:@"/%@.png", spriteName];
        CGDataProviderRef provider = CGDataProviderCreateWithFilename([pngName UTF8String]);
        assert(image == NULL);
        image = CGImageCreateWithPNGDataProvider(provider, NULL, YES, kCGRenderingIntentDefault);
        CGDataProviderRelease(provider);

        CGSize imageSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
        cellSize = CGSizeMake(imageSize.width / xDim, imageSize.height / yDim);
        
        int count = xDim * yDim;
        for (int i = 0; i < count; i++) {
            int x = i % xDim;
            int y = i / xDim;
            CGRect rect = CGRectMake(x * cellSize.width, y * cellSize.height, cellSize.width, cellSize.height);

            SMIVFrame *frame = [[[SMIVFrame alloc] initWithImage:image inRect:rect] autorelease];
            [frame setCellSize:cellSize];
            [frames addObject:frame];
        }
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:title];
    if (![coder isPluginFormat]) return;
    NSString *baseDir = [coder baseDir];
    NSString *spriteDir = [baseDir stringByAppendingPathComponent:@"Sprites"];
    NSString *spriteName = [title stringByReplacingOccurrencesOfString:@"/" withString:@":"];

    NSString *destPath = [spriteDir stringByAppendingFormat:@"/%@.png", spriteName];
    BOOL err;
    err = [[self PNGData] writeToFile:destPath atomically:NO];
    assert(err);

    CGSize arrangement = [self gridDistribution];
    NSXMLElement *dimElement = [NSXMLElement elementWithName:@"dimensions"];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:2];
    [attributes setObject:[NSNumber numberWithInt:(int)arrangement.width] forKey:@"x"];
    [attributes setObject:[NSNumber numberWithInt:(int)arrangement.height] forKey:@"y"];
    [dimElement setAttributesAsDictionary:attributes];
    NSXMLElement *rootElement = [NSXMLElement elementWithName:@"sprite"];;
    [rootElement addChild:dimElement];
    NSXMLDocument *document = [NSXMLDocument documentWithRootElement:rootElement];
    [[document XMLData] writeToFile:[spriteDir stringByAppendingFormat:@"%@.xml", spriteName] atomically:NO];
}

+ (BOOL)isComposite {
    return NO;
}

+ (Class)classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

#pragma mark Frames

@synthesize currentFrame;

- (NSUInteger) nextFrame {
    return currentFrame = (currentFrame+1)%[frames count];
}

- (NSUInteger) previousFrame {
    currentFrame--;
    if (currentFrame >= [frames count]) {
        currentFrame = [frames count] - 1;
    }
    return currentFrame;
}

#pragma mark Drawing

- (void)drawAtPoint:(CGPoint)point {
    CGRect rect = [self rectForFrame:currentFrame];
    CGImageRef subImage = CGImageCreateWithImageInRect(image, rect);
    rect.origin = point;
    CGContextDrawImage([[NSGraphicsContext currentContext] graphicsPort], rect, subImage);
    CGImageRelease(subImage);
}

- (void)drawSpriteSheetAtPoint:(CGPoint)point {
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    CGRect rect = CGRectMake(point.x, point.y, width, height);
    CGContextDrawImage([[NSGraphicsContext currentContext] graphicsPort], rect, image);
}

#pragma mark Other Methods

- (CGSize)gridDistribution {
    return [SMIVImage gridDistributionForCount:[frames count]];
}

/*
 * Calculate the grid that the frames will be layed out on.
 * The goal is to minimize the difference between the width and height, then
 * flip it so that the grid is taller than it is wide unless the longest dimension
 * is less than or equal to 8
 */
+ (CGSize)gridDistributionForCount:(int)count {
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

- (CGRect)rectForFrame:(int)frame {
    CGSize arrangement = [self gridDistribution];
    int xLoc = frame%((int)arrangement.width);
    int yLoc = frame/(int)arrangement.width;
    return CGRectMake(xLoc * cellSize.width, yLoc * cellSize.height, cellSize.width, cellSize.height);
}

- (NSData *)PNGData {
    NSBitmapImageRep *rep = [[[NSBitmapImageRep alloc] initWithCGImage:image] autorelease];
    return [rep representationUsingType:NSPNGFileType properties:nil];
}

- (NSData *)GIFData {
    int count = [frames count];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (int k = 0; k < count; k++) {
        CGImageRef frame = CGImageCreateWithImageInRect(image, [self rectForFrame:k]);
        NSBitmapImageRep *bitmap = [[[NSBitmapImageRep alloc] initWithCGImage:frame] autorelease];
        CGImageRelease(frame);
        [array addObject:bitmap];
    }

    return [NSBitmapImageRep representationOfImageRepsInArray:array usingType:NSGIFFileType properties:nil];
}
@end

@implementation SMIVFrame
@synthesize xOffset, yOffset;
@synthesize width, height;
@dynamic paddedWidth, paddedHeight;
@synthesize cellSize;
@dynamic slice;
@dynamic lengthOfData;

- (CGFloat)paddedWidth {
    return MAX(xOffset, width - xOffset) * 2.0f;
    
}

- (CGFloat)paddedHeight {
    return MAX(yOffset, height - yOffset) * 2.0f;
}

- (CGImageRef)slice {
    return slice;
}

- (void)setSlice:(CGImageRef)slice_ {
    assert(slice_ != NULL);
    CGImageRetain(slice_);
    CGImageRelease(slice);
    slice = slice_;
}

-  (size_t)lengthOfData {
    return width * height + 8;
}

- (id)init {
    self = [super init];
    if (self) {
        xOffset = yOffset = 0;
        width = height = 0;
        slice = NULL;
    }
    return self;
}

- (void)dealloc {
    CGImageRelease(slice);
    [super dealloc];
}


- (id)initWithImage:(CGImageRef)image inRect:(CGRect)rect {
    self = [super init];
    if (self) {
        width = rect.size.width;
        height = rect.size.height;
        xOffset = width / 2;
        yOffset = height / 2;
        slice = CGImageCreateWithImageInRect(image, rect);
    }
    return self;
}
                                
#pragma mark Resource Methods

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        width = [coder decodeUInt16];
        height = [coder decodeUInt16];
        xOffset = [coder decodeSInt16];
        yOffset = [coder decodeSInt16];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeUInt16:width];
    [coder encodeUInt16:height];
    [coder encodeSInt16:xOffset];
    [coder encodeSInt16:yOffset];
    uint8 *buffer = [self quantitizedPixels];
    [coder writeBytes:buffer length:width * height];
    free(buffer);
}

#pragma mark Other Methods

- (uint8 *)quantitizedPixels {
    assert(CGImageGetBitsPerPixel(slice) == 32);
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(slice));
    const uint32 *buffer = (uint32 *)CFDataGetBytePtr(data);
    uint8 *quantitizedBuffer = malloc(width * height);
    for (int i = 0; i < width * height; i++) {
        quantitizedBuffer[i] = quantitize_pixel(buffer[i]);
    }
    CFRelease(data);
    return quantitizedBuffer;
}
@end
                    