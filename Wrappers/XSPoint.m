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

@implementation XSIPoint
@synthesize point;
@dynamic x;
- (void) setX:(int)_x {x = _x;}
- (int) x {return x;}
@dynamic y;
- (void) setY:(int)_y {y = _y;}
- (int) y {return y;}

- (id) init {
    self = [super init];
    if (self) {}
    return self;
}

- (id) initWithPoint:(NSPoint)point {
    self = [self initWithX:point.x Y:point.y];
    if (self) {}
    return self;
}

- (id) initWithX:(CGFloat)_x Y:(CGFloat)_y {
    self = [self init];
    if (self) {
        x = _x;
        y = _y;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        x = [coder decodeIntForKey:@"x"];
        y = [coder decodeIntForKey:@"y"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInt:x forKey:@"x"];
    [coder encodeInt:y forKey:@"y"];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

+ (id) point {
    return [[[XSIPoint alloc] init] autorelease];
}

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

+ (NSSet *) keyPathsForValuesAffectingPoint {
    if (pointKeyPaths == nil) {
        pointKeyPaths = [[NSSet alloc] initWithObjects:@"x", @"y", nil];
    }
    return pointKeyPaths;
}
@end
