//
//  Race.m
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "Race.h"
#import "Archivers.h"
#import "StringTable.h"

const NSUInteger raceStringTableId = 4201u;

@implementation Race
@synthesize raceId, apparentColor, illegalColors, advantage;
@synthesize singular, plural, military, homeworld;

- (id) init {
    [super init];
    raceId = 0;
    apparentColor = ClutGray;
    illegalColors = 0x00000000;
    advantage = 1.0f;
    singular = @"Untitled";
    plural = @"Untitled";
    military = @"Untitled";
    homeworld = @"Untitled";
    return self;
}

- (void) dealloc {
    [singular release];
    [plural release];
    [military release];
    [homeworld release];
    [super dealloc];
}

//MARK: Lua Coding

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    [self init];
    raceId = [coder decodeIntegerForKey:@"id"];
    apparentColor = [coder decodeIntegerForKey:@"apparentColor"];
    illegalColors = [coder decodeIntegerForKey:@"illegalColors"];
    advantage = [coder decodeFloatForKey:@"advantage"];
    singular = [[coder decodeStringForKey:@"singular"] retain];
    plural = [[coder decodeStringForKey:@"plural"] retain];
    military = [[coder decodeStringForKey:@"military"] retain];
    homeworld = [[coder decodeStringForKey:@"homeWorld"] retain];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:raceId forKey:@"id"];
    [coder encodeInteger:apparentColor forKey:@"apparentColor"];
    [coder encodeInteger:illegalColors forKey:@"illegalColors"];
    [coder encodeFloat:advantage forKey:@"advantage"];
    [coder encodeString:singular forKey:@"singular"];
    [coder encodeString:plural forKey:@"plural"];
    [coder encodeString:military forKey:@"military"];
    [coder encodeString:homeworld forKey:@"homeWorld"];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

//MARK: Res Coding

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        raceId = [coder decodeSInt32];
        apparentColor = [coder decodeUInt8];
        [coder skip:1u];
        illegalColors = [coder decodeUInt32];
        advantage = [coder decodeFixed];
        
        StringTable *strings = [coder decodeObjectOfClass:[StringTable class] atIndex:raceStringTableId];
        NSUInteger idx = [coder currentIndex];
        singular = [[strings stringAtIndex:4 * idx] retain];
        plural = [[strings stringAtIndex:4 * idx + 1] retain];
        military = [[strings stringAtIndex:4 * idx  + 2] retain];
        homeworld = [[strings stringAtIndex:4 * idx + 3] retain];
        
    }
    return self;
}

+ (ResType)resType {
    return 'race';
}

+ (NSString *)typeKey {
    return @"race";
}

+ (BOOL)isPacked {
    return YES;
}

+ (size_t)sizeOfResourceItem {
    return 14;
}
@end
