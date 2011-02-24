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
    CGImageRef image;
}
@property (readonly) short width;
@property (readonly) short height;
@property (readonly) NSSize size;

@property (readonly) short offsetX;
@property (readonly) short offsetY;
@property (readonly) NSPoint offset;

@property (readonly) size_t length;//size of smiv frame in bytes 
@property (readonly) CGImageRef image;

- (void)draw;
- (void)drawAtPoint:(NSPoint)point;
- (void)drawInRect:(NSRect)rect;
@end

//Custom container for SMIV animations.
//WARNING: Use of NSCopying is a HACK for NSDictionaryController you probably want NSMutableCopying
@interface SMIVImage : NSObject <ResCoding, NSCopying> {
    NSString *title;
    NSMutableArray *frames;
    NSUInteger count;
    NSUInteger currentFrameId;
}
@property (readwrite, retain)  NSString *title;
@property (readonly) NSArray *frames;
@property (readonly) NSUInteger count;
@property (readwrite) NSUInteger frame;
@property (readonly) NSSize size;

- (NSUInteger) nextFrame;
- (NSUInteger) previousFrame;

- (void) draw;
- (void) drawAtPoint:(NSPoint)point;
- (void) drawInRect:(NSRect)rect;

- (void) drawFrame:(NSUInteger)frame;
- (void) drawFrame:(NSUInteger)frame atPoint:(NSPoint)point;
- (void) drawFrame:(NSUInteger)frame inRect:(NSRect)rect;
@end
