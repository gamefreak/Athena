//
//  Race.m
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "Race.h"
#import "Archivers.h"

@implementation Race
- (id) init {
    [super init];
    raceId = 0;
    advantage = 1.0f;
    singular = @"Untitled";
    plural = @"Untitled";
    military = @"Untitled";
    homeworld = @"Untitled";
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    [self init];
    raceId = [coder decodeIntegerForKey:@"id"];
    advantage = [coder decodeFloatForKey:@"advantage"];
    singular = [[coder decodeStringForKey:@"singular"] retain];
    plural = [[coder decodeStringForKey:@"plural"] retain];
    military = [[coder decodeStringForKey:@"military"] retain];
    homeworld = [[coder decodeStringForKey:@"homeWorld"] retain];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:raceId forKey:@"id"];
    [coder encodeFloat:advantage forKey:@"advantage"];
    [coder encodeString:singular forKey:@"singular"];
    [coder encodeString:plural forKey:@"plural"];
    [coder encodeString:military forKey:@"military"];
    [coder encodeString:homeworld forKey:@"homeWorld"];
}

- (void) dealloc {
    [singular release];
    [plural release];
    [military release];
    [homeworld release];
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}
@end
