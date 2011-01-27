//
//  XSInteger.m
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSInteger.h"
#import "Archivers.h"

@implementation XSInteger
@synthesize value;

- (id) init {
    self = [super init];
    value = 0;
    return self;
}

- (id) initWithValue:(NSInteger)_value {
    self = [self init];
    value = _value;
    return self;
}

+ (id) xsIntegerWithValue:(NSInteger)value {
    return [[[XSInteger alloc] initWithValue:value] autorelease];
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    value = [coder decodeInteger];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:value];
}

+ (BOOL) isComposite {
    return NO;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end
