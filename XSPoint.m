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

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    [self init];
    point.x = [coder decodeFloatForKey:@"x"];
    point.y = [coder decodeFloatForKey:@"y"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeFloat:point.x forKey:@"x"];
    [coder encodeFloat:point.y forKey:@"y"];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

+ (id) point {
    return [[[XSPoint alloc] init] autorelease];
}

static NSSet *xyKeyPaths;
+ (NSSet *) keyPathsForValuesAffectingX {
    if (xyKeyPaths == nil) {
        xyKeyPaths = [[NSSet alloc] initWithObjects:@"point", nil];
    }
    return xyKeyPaths;
}

+ (NSSet *) keyPathsForValuesAffectingY {
    if (xyKeyPaths == nil) {
        xyKeyPaths = [[NSSet alloc] initWithObjects:@"point", nil];
    }
    return xyKeyPaths;
}

static NSSet *pointKeyPaths;
+ (NSSet *) keyPathsForValuesAffectingPoint {
    if (pointKeyPaths == nil) {
        pointKeyPaths = [[NSSet alloc] initWithObjects:@"x", @"y", nil];
    }
    return pointKeyPaths;
}
@end
