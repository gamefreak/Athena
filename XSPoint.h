//
//  XSPoint.h
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface XSPoint : NSObject <NSCoding> {
    NSPoint point;
}
@property (readwrite, assign) CGFloat x;
@property (readwrite, assign) CGFloat y;
@property (readwrite, assign) NSPoint point;

- (id) initWithPoint:(NSPoint)point;
- (id) initWithX:(CGFloat)x Y:(CGFloat)y;

+ (id) point;
@end
