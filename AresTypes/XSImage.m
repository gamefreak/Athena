//
//  XSImage.m
//  Athena
//
//  Created by Scott McClaugherty on 10/4/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSImage.h"
#import "Color.h"

uint8_t *pack_scanline(uint8_t *scanline, size_t bytes_per_line, size_t *length_out);

@interface ResArchiver (RectEncode)
- (void)encodeRect:(Rect)rect;
@end

@implementation ResArchiver (RectEncode)
- (void)encodeRect:(Rect)rect {
    [self encodeSInt16:rect.top];
    [self encodeSInt16:rect.left];
    [self encodeSInt16:rect.bottom];
    [self encodeSInt16:rect.right];
}
@end


@implementation XSImage
@synthesize name, image;

- (id)init {
    self = [super init];
    if (self) {
        name = @"Untitled";
        image = nil;
    }
    return self;
}

- (void)dealloc {
    [image release];
    [name release];
    [super dealloc];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        image = [[NSImage alloc] initWithData:[coder rawData]];
        NSString *name_ = [coder currentName];
        if ([name_ length] == 0) {
            name_ = [NSString stringWithFormat:@"Image %i", [coder currentIndex]];
        }
        [self setName:name_];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder setName:name];
    //Check if we already have a PICT representation
    NSPICTImageRep *pictRep = [[image representations] firstObjectPassingTest:^(id obj, NSUInteger idx){
        return (BOOL)([obj isKindOfClass:[NSPICTImageRep class]]);
    }];
    if (pictRep != nil) {
        //We have a pict representation so skip the custom encoder!
        NSData *data = [pictRep PICTRepresentation];
        [coder extend:[data length]];
        [coder writeBytes:(void *)[data bytes] length:[data length]];
    } else {
        //Custom encoder time!
        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation]];
        CGImageRef image_ = [rep CGImage];//Get out image
        short width = CGImageGetWidth(image_);
        short height = CGImageGetHeight(image_);
        Rect rect = {0, 0, height, width};
        [coder extend:2686];//this is how much data will be written before the image is encoded
        [coder skip:512];//512 byte blank header
        assert([coder tell] == 512);
        [coder encodeUInt16:0x0000];//length field (ignore for now)
        [coder encodeRect:rect];//the overall size of the picture
        [coder writeBytes:"\x00\x11\x02\xff" length:4];//version command (V2)
        {//image info command
            [coder writeBytes:"\x0c\x00" length:2];
            [coder writeBytes:"\xff\xfe\x00\x00" length:4];//no clue what this is
            [coder encodeSInt16:72];[coder encodeSInt16:0x0000];//x resolution (DPI)
            [coder encodeSInt16:72];[coder encodeSInt16:0x0000];//y resolution
            [coder encodeRect:rect];
            [coder encodeUInt32:0x00000000];//some field I don't use
        }
        {//image clip area I think
            [coder writeBytes:"\x00\x01\x00\x0a" length:4];//command id + lenght of data in command
            [coder encodeRect:rect];//clipping rect
        }
        short rowbytes = width;
        {//image header
            [coder writeBytes:"\x00\x98" length:2];//command
            rowbytes = width;
            if (rowbytes % 2 == 1) rowbytes++;//make rowbytes even
            [coder encodeUInt16:rowbytes | 0x8000];
            [coder encodeRect:rect];
            [coder encodeSInt16:0];//pixmap version
            [coder encodeSInt16:0];//pixmap pack type
            [coder encodeSInt32:0];//pixmap pack size
            [coder encodeSInt16:72];[coder encodeSInt16:0x0000];//x resolution (DPI)
            [coder encodeSInt16:72];[coder encodeSInt16:0x0000];//y resolution
            [coder encodeSInt16:0];//pixmap pixel type
            [coder encodeSInt16:8];//bits per pixel
            [coder encodeSInt16:1];//component count (indexed)
            [coder encodeSInt16:8];//bits per component
            [coder encodeSInt32:0];//plane bytes?
            [coder encodeSInt32:0];//table?
            [coder encodeSInt32:0];//reserved?
        }
        {//image colormap
            [coder encodeUInt32:CLUT_ID];//uniquely identifies the CLUT or something
            [coder encodeSInt16:0x0000];//flags
            //write Ares color table
            [coder encodeSInt16:255];//always use 256 colors but write count-1
            for (short i = 0; i < 256; i++) {
                [coder encodeSInt16:i];//color index
                [coder encodeSInt8:CLUT[i][0]];//RED
                [coder encodeSInt8:CLUT[i][0]];//RED
                [coder encodeSInt8:CLUT[i][1]];//GREEN
                [coder encodeSInt8:CLUT[i][1]];//GREEN
                [coder encodeSInt8:CLUT[i][2]];//BLUE
                [coder encodeSInt8:CLUT[i][2]];//BLUE
            }
        }
        [coder encodeRect:rect];//source rect
        [coder encodeRect:rect];//destination rect
        [coder encodeSInt16:0x0000];//cant remember what it's for
        CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(image_));
        const uint32_t *pixelBuffer = (uint32 *)CFDataGetBytePtr(imageData);
        int count = 0;
        for (int y = 0; y < height; y++) {
            uint8_t scanline[rowbytes & 0x7fff];
            for (int x = 0; x < width; x++) {
                uint32_t pixel = htonl(pixelBuffer[x + y * width]);
                scanline[x] = quantitize_pixel(pixel);
            }
            size_t len = 0;
            uint8_t *data = pack_scanline(scanline, rowbytes & 0x7fff, &len);
            count += len;
            [coder extend:len];
            [coder writeBytes:(void *)data length:len];
            free(data);
        }

        if (count % 2 == 1) {
            [coder extend:1];
            [coder encodeUInt8:0x00];//padding
        }
        CFRelease(imageData);
        [rep release];
        [coder extend:2];
        [coder encodeUInt16:0x00ff];//end command
        
        short imageLength = [coder tell] - 512;
        [coder seek:512];
        [coder encodeSInt16:imageLength];//write the length
    }
}

+ (ResType)resType {
    return 'PICT';
}

+ (NSString *)typeKey {
    return @"PICT";
}

+ (BOOL)isPacked {
    return NO;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super init];
    if (self) {
        [self setName:[coder decodeString]];
        image = [[NSImage alloc] initWithData:[coder fileNamed:[name stringByAppendingPathExtension:@"png"] inDirectory:@"Images"]];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:name];
    [coder async:^{
        NSData *data = [self PNGData];
        assert(data != nil);
        assert(name != nil);
        [coder saveFile:data
                  named:[name stringByAppendingPathExtension:@"png"]
            inDirectory:@"Images"];
    }];
}

+ (BOOL)isComposite {
    return NO;
}

+ (Class)classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

- (NSData *)PNGData {
    NSUInteger repIndex = [[image representations] indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
        return *stop = [obj isKindOfClass:[NSBitmapImageRep class]];
    }];
    NSBitmapImageRep *rep = nil;
    if (repIndex == NSNotFound) {
        CGImageRef image_ = [image CGImageForProposedRect:NULL context:nil hints:nil];
        rep = [[NSBitmapImageRep alloc] initWithCGImage:image_];
        [image addRepresentation:rep];
        [rep autorelease];
    } else {
        rep = [[image representations] objectAtIndex:repIndex];
    }
    return [rep representationUsingType:NSPNGFileType properties:nil];
}

+ (NSSet *)blacklistedImageIDs {
    NSMutableSet *imageBlacklist = [NSMutableSet setWithCapacity:14];
    [imageBlacklist addObject:[NSNumber numberWithInt:520]];//Key Back
    [imageBlacklist addObject:[NSNumber numberWithInt:521]];//Key Accel
    [imageBlacklist addObject:[NSNumber numberWithInt:522]];//Key Stop
    [imageBlacklist addObject:[NSNumber numberWithInt:523]];//Key Rotate Counter
    [imageBlacklist addObject:[NSNumber numberWithInt:524]];//Key Rotate Clockwise
    
    [imageBlacklist addObject:[NSNumber numberWithInt:525]];//Key Weapon 1
    [imageBlacklist addObject:[NSNumber numberWithInt:526]];//Key Weapon 2
    [imageBlacklist addObject:[NSNumber numberWithInt:527]];//Key Special
    [imageBlacklist addObject:[NSNumber numberWithInt:528]];//Key Superlight
    [imageBlacklist addObject:[NSNumber numberWithInt:529]];//Key Commands
    
    [imageBlacklist addObject:[NSNumber numberWithInt:530]];//Key Computer Controls
    [imageBlacklist addObject:[NSNumber numberWithInt:2000]];//Ambrosia Logo
    [imageBlacklist addObject:[NSNumber numberWithInt:2002]];//Ambrosia Credits
    [imageBlacklist addObject:[NSNumber numberWithInt:-20932]];//QT badge
    return imageBlacklist;
}
@end

uint8_t *pack_scanline(uint8_t *scanline, size_t bytes_per_line, size_t *length_out) {
    uint8_t *buffer =  malloc(bytes_per_line * sizeof(uint8_t));
    uint8_t *p, *q;
    short count = 0, runlength = 0, repeat_count = 0;
    p = scanline + bytes_per_line - 1;
    q = buffer;
    uint8_t index = *p;
    for (int i = bytes_per_line - 1; i >= 0; i--) {
        if (index == *p) {
            runlength++;
        } else {
            if (runlength < 3) {
                while (runlength > 0) {
                    *q++ = (uint8_t)index;
                    runlength--;
                    count++;
                    if (count == 128) {
                        *q++ = (uint8_t)(127);
                        count-=128;
                    }
                }
            } else {
                if (count > 0) {
                    *q++ = (uint8_t)(count - 1);
                }
                count = 0;
                while (runlength > 0) {
                    repeat_count = runlength;
                    if (repeat_count > 128) {
                        repeat_count = 128;
                    }
                    *q++ = (uint8_t)index;
                    *q++ = (uint8_t)(257-repeat_count);
                    runlength -= repeat_count;
                }
            }
            runlength = 1;
        }
        index = *p;
        p--;
    }
    if (runlength < 3) {
        while (runlength > 0) {
            *q++ = (uint8_t)index;
            runlength--;
            count++;
            if (count == 128) {
                *q++ = (uint8_t)127;
                count -= 128;
            }
        }
    } else {
        if (count > 0) {
            *q++ = (uint8_t)(count-1);
        }
        count = 0;
        while (runlength > 0) {
            repeat_count = runlength;
            if (repeat_count > 128) {
                repeat_count = 128;
            }
            *q++ = (uint8_t)index;
            *q++ = (uint8_t)(257-repeat_count);
            runlength -= repeat_count;
        }
    }
    if (count > 0) {
        *q++ = (uint8_t)(count - 1);
    }
    short length = q - buffer;
    *length_out = length+(bytes_per_line>200?2:1);
    uint8_t *data = malloc(sizeof(uint8_t)**length_out);
    uint8_t *datap = data;

    if (bytes_per_line > 200) {
        short tmp = htons(length);        
        *((short *)datap) = tmp;
        datap += 2;
    } else {
        char tmp = length;
        *datap++ = tmp;
    }
    while (q != buffer) {//q is backwards!
        q--;
        *datap++ = *q;
    }
    return data;
}
