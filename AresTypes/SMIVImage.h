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

//SMIVRect is not a general purpose tool!
//It is used for frame alignment calculation.
typedef struct {
    CGFloat top, bottom;
    CGFloat left, right;
} SMIVRect;

SMIVRect SMIVRectMake(CGFloat centerX, CGFloat centerY, CGFloat width, CGFloat height);
SMIVRect SMIVUnionRects(SMIVRect a, SMIVRect b);
NSSize SMIVRectSize(SMIVRect rect);

@interface SMIVFrame : NSObject <ResCoding> {
    SMIVRect rect;
    CGImageRef image;
}
@property (readonly) CGFloat width;
@property (readonly) CGFloat height;
@property (readonly) NSSize size;

@property (readonly) CGFloat offsetX;
@property (readonly) CGFloat offsetY;
@property (readonly) NSPoint offset;

@property (readonly) SMIVRect rect;

@property (readonly) size_t length;//size of smiv frame in bytes 
@property (readonly) CGImageRef image;

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
    SMIVRect masterRect;
}
@property (readwrite, retain)  NSString *title;
@property (readonly) NSArray *frames;
@property (readonly) NSUInteger count;
@property (readwrite) NSUInteger frame;
@property (readonly) NSSize size;
@property (readonly) SMIVRect masterRect;

- (NSUInteger) nextFrame;
- (NSUInteger) previousFrame;

- (void) drawAtPoint:(NSPoint)point;
- (void) drawInRect:(NSRect)rect;

- (void) drawFrame:(NSUInteger)frame atPoint:(NSPoint)point;
- (void) drawFrame:(NSUInteger)frame inRect:(NSRect)rect;

- (NSSize) gridDistribution;
@end
