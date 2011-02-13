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
@property (readonly) short offsetX;
@property (readonly) short offsetY;
@property (readonly) CGImageRef image;
@end

@interface SMIVImage : NSObject <ResCoding> {
    NSMutableArray *frames;
}
@property (readonly) NSArray *frames;
@property (readonly) NSUInteger count;
@end
