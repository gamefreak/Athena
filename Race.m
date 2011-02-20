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

@implementation IllegalColors
@synthesize gray, orange, yellow, blue;
@synthesize green, purple, indigo, salmon;
@synthesize gold, aqua, pink, paleGreen;
@synthesize palePurple, skyBlue, tan, red;
+ (NSArray *) keys {
    static NSArray *colorKeys;
    if (colorKeys == nil) {
        colorKeys = [[NSMutableArray alloc] initWithObjects:
                     @"gray", @"orange", @"yellow", @"blue",
                     @"green", @"purple", @"indigo", @"salmon",
                     @"gold", @"aqua", @"pink", @"paleGreen",
                     @"palePurple", @"skyBlue", @"tan", @"red", nil];
    }
    return colorKeys;
}
@end


const NSUInteger raceStringTableId = 4201u;

@implementation Race
@synthesize raceId, apparentColor, illegalColors, advantage;
@synthesize singular, plural, military, homeworld;

- (id) init {
    self = [super init];
    if (self) {
        raceId = 0;
        apparentColor = ClutGray;
        illegalColors = [[IllegalColors alloc] init];;
        advantage = 1.0f;
        singular = @"Untitled";
        plural = @"Untitled";
        military = @"Untitled";
        homeworld = @"Untitled";
    }
    return self;
}

- (void) dealloc {
    [illegalColors release];
    [singular release];
    [plural release];
    [military release];
    [homeworld release];
    [super dealloc];
}

//MARK: Lua Coding

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        raceId = [coder decodeIntegerForKey:@"id"];
        apparentColor = [coder decodeIntegerForKey:@"apparentColor"];
        illegalColors.hex = [coder decodeIntegerForKey:@"illegalColors"];
        advantage = [coder decodeFloatForKey:@"advantage"];
        singular = [[coder decodeStringForKey:@"singular"] retain];
        plural = [[coder decodeStringForKey:@"plural"] retain];
        military = [[coder decodeStringForKey:@"military"] retain];
        homeworld = [[coder decodeStringForKey:@"homeWorld"] retain];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:raceId forKey:@"id"];
    [coder encodeInteger:apparentColor forKey:@"apparentColor"];
    [coder encodeInteger:illegalColors.hex forKey:@"illegalColors"];
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
        illegalColors.hex = [coder decodeUInt32];
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

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt32:raceId];
    [coder encodeUInt8:apparentColor];
    [coder skip:1u];
    [coder encodeUInt32:illegalColors.hex];

    [coder encodeFixed:advantage];

    [coder addString:singular toStringTable:raceStringTableId];
    [coder addString:plural toStringTable:raceStringTableId];
    [coder addString:military toStringTable:raceStringTableId];
    [coder addString:homeworld toStringTable:raceStringTableId];
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
