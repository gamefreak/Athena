//
//  Action.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "Action.h"

@implementation Action
- (id) init {
    self = [super init];
    reflexive = NO;//Best way?
    inclusiveFilter = 0x00000000;//best??
    exclusiveFilter = 0x00000000;//best??

    owner = 0;
    delay = 0;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    reflexive = [coder decodeBoolForKey:@"reflexive"];

    inclusiveFilter = [coder decodeIntegerForKey:@"inclusiveFilter"];
    exclusiveFilter = [coder decodeIntegerForKey:@"exclusiveFilter"];
    subjectOverride = [coder decodeIntegerForKey:@"subjectOverride"];
    directOverride = [coder decodeIntegerForKey:@"directOverride"];

    owner = [coder decodeIntegerForKey:@"owner"];
    delay = [coder decodeIntegerForKey:@"delay"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeBool:reflexive forKey:@"reflexive"];
    [coder encodeInteger:inclusiveFilter forKey:@"inclusiveFilter"];
    [coder encodeInteger:exclusiveFilter forKey:@"exclusiveFilter"];
    [coder encodeInteger:subjectOverride forKey:@"subjectOverride"];
    [coder encodeInteger:directOverride forKey:@"directOverride"];

    [coder encodeInteger:owner forKey:@"owner"];
    [coder encodeInteger:delay forKey:@"delay"];
}

- (void) dealloc {
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end
