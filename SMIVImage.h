//
//  SMIVImage.h
//  Athena
//
//  Created by Scott McClaugherty on 2/13/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Color.h"
#import "ResCoding.h"

@interface SMIVFrame : NSObject <ResCoding> {
    short width, height;
    short offsetX, offsetY;
    NSImageRep *image;
    uint32 *bytes;
}
@property (readonly) short width;
@property (readonly) short height;
@property (readonly) NSSize size;
@property (readonly) short offsetX;
@property (readonly) short offsetY;
@property (readonly) NSPoint offset;
@property (readonly) uint32 *bytes;
@property (readonly) size_t length;//size of smiv frame in bytes 
@property (readonly) NSImageRep *image;


- (NSRect) frameRect;//The offset frame rectangle

- (BOOL)draw;
- (BOOL)drawAtPoint:(NSPoint)point;
- (BOOL)drawInRect:(NSRect)rect;
@end

//Custom container for SMIV animations.
@interface SMIVImage : NSObject <ResCoding> {
    NSMutableArray *frames;
    NSUInteger count;
    NSUInteger currentFrameId;
}
@property (readonly) NSArray *frames;
@property (readonly) NSUInteger count;
@property (readwrite) NSUInteger frame;

- (NSUInteger) nextFrame;
- (NSUInteger) previousFrame;

- (BOOL) draw;
- (BOOL) drawAtPoint:(NSPoint)point;
- (BOOL) drawInRect:(NSRect)rect;

- (BOOL) drawFrame:(NSUInteger)frame;
- (BOOL) drawFrame:(NSUInteger)frame atPoint:(NSPoint)point;
- (BOOL) drawFrame:(NSUInteger)frame inRect:(NSRect)rect;
@end
