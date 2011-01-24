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

- (id) initWithCoder:(LuaUnarchiver *)coder {
    self = [super init];
    NSUInteger first = [coder decodeIntegerForKey:@"first"];
    NSUInteger count = [coder decodeIntegerForKey:@"count"];
    range = NSMakeRange(first, count);
    return self;
}

- (void) encodeWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:range.location forKey:@"first"];
    [coder encodeInteger:range.length forKey:@"count"];
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
@end
