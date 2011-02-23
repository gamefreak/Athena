//
//  XSRange.m
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSRange.h"
#import "Archivers.h"

@implementation XSRange
- (id) init {
    self = [super init];
    range = NSMakeRange(0, 0);
    return self;
}

- (id) initWithFirst:(NSUInteger)first count:(NSUInteger)count {
    self = [super init];
    range = NSMakeRange(first, count);
    return self;
}

- (id) initWithRange:(NSRange)_range {
    self = [super init];
    range = _range;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super init];
    NSUInteger first = [coder decodeIntegerForKey:@"first"];
    NSUInteger count = [coder decodeIntegerForKey:@"count"];
    range = NSMakeRange(first, count);
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:range.location forKey:@"first"];
    [coder encodeInteger:range.length forKey:@"count"];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

+ (id) range {
    return [[[XSRange alloc] init] autorelease];
}

@synthesize range;
@dynamic first;
- (void) setFirst:(NSUInteger)first {range.location = first;}
- (NSUInteger) first {return range.location;}
@dynamic count;
- (void) setCount:(NSUInteger)count {range.length = count;}
- (NSUInteger) count {return range.length;}

static NSSet *fcKeyPaths;
+ (NSSet *) keyPathsForValuesAffectingFirst {
    if (fcKeyPaths == nil) {
        fcKeyPaths = [[NSSet alloc] initWithObjects:@"range", nil];
    }
    return fcKeyPaths;
}

+ (NSSet *) keyPathsForValuesAffectingCount {
    if (fcKeyPaths == nil) {
        fcKeyPaths = [[NSSet alloc] initWithObjects:@"range", nil];
    }
    return fcKeyPaths;
}

static NSSet *rangeKeyPaths;
+ (NSSet *) keyPathsForValuesAffectingRange {
    if (rangeKeyPaths == nil) {
        rangeKeyPaths = [[NSSet alloc] initWithObjects:@"first", @"count", nil];
    }
    return rangeKeyPaths;
}
@end
