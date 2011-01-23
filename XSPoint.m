//
//  XSPoint.m
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSPoint.h"
#import "Archivers.h"

@implementation XSPoint
@synthesize point;
@dynamic x;
- (void) setX:(CGFloat)x {point.x = x;}
- (CGFloat) x {return point.x;}
@dynamic y;
- (void) setY:(CGFloat)y {point.y = y;}
- (CGFloat) y {return point.y;}

- (id) init {
    self = [super init];
    return self;
}

- (id) initWithPoint:(NSPoint)_point {
    [self init];
    point = _point;
    return self;
}

- (id) initWithX:(CGFloat)x Y:(CGFloat)y {
    [self init];
    point = NSMakePoint(x, y);
    return self;
    
}

- (id) initWithCoder:(LuaUnarchiver *)coder {
    [self init];
    point.x = [coder decodeFloatForKey:@"x"];
    point.y = [coder decodeFloatForKey:@"y"];
    return self;
}

- (void) encodeWithCoder:(LuaArchiver *)coder {
    [coder encodeFloat:point.x forKey:@"x"];
    [coder encodeFloat:point.y forKey:@"y"];
}

@end
