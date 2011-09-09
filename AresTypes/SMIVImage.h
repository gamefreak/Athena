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
#import "LuaCoding.h"

@interface SMIVImage : NSObject <ResCoding, LuaCoding, NSCopying> {
    NSString *title;
    NSMutableArray *frames;
    CGSize cellSize;
    CGImageRef image;
    int currentFrame;
}
@property (retain) NSString *title;
@property (readonly) CGSize cellSize;
@property (assign) int currentFrame;
@property (readonly) int count;
@property (readonly) NSArray *frames;
@property (readonly) CGImageRef image;
- (NSUInteger) nextFrame;
- (NSUInteger) previousFrame;
- (void)drawAtPoint:(CGPoint)point;
- (void)drawSpriteSheetAtPoint:(CGPoint)point;
- (CGSize)gridDistribution;
+ (CGSize)gridDistributionForCount:(int)count;
- (CGRect)rectForFrame:(int)frame;
- (NSData *)PNGData;
- (NSData *)GIFData;
@end

@interface SMIVFrame : NSObject {
    int xOffset, yOffset;
    int width, height;
    CGSize cellSize;//just to handle information sharing
    CGImageRef slice;
}
@property (assign) int xOffset, yOffset;
@property (assign) int width, height;
@property (readonly) CGFloat paddedWidth, paddedHeight;
@property (assign) CGSize cellSize;
@property (assign) CGImageRef slice;
@property (readonly) size_t lengthOfData;
- (id)initWithImage:(CGImageRef)image inRect:(CGRect)rect;
- (id)initWithResArchiver:(ResUnarchiver *)coder;
- (void)encodeResWithCoder:(ResArchiver *)coder;
- (uint8 *)quantitizedPixels;
@end