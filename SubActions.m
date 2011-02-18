//
//  SubActions.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SubActions.h"
#import "Archivers.h"
#import "IndexedObject.h"

#import "BaseObject.h"
#import "Scenario.h"

@implementation NoAction
- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        [coder skip:24u];
    }
    return self;
};
@end

@implementation CreateObjectAction
@synthesize baseType, min, range;
@synthesize velocityRelative, directionRelative, distanceRange;

- (id) init {
    self = [super init];
    if (self) {
        baseType = [[Index alloc] init];
        min = 1;
        range = 0;
        velocityRelative = YES;//???
        directionRelative = YES;//???
        distanceRange = 0;
    }
    return self;
}

- (void) dealloc {
    [baseType release];
    [super dealloc];
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        [baseType release];
        baseType = [[coder getIndexRefWithIndex:[coder decodeIntegerForKey:@"baseType"]
                                       forClass:[BaseObject class]] retain];
        min = [coder decodeIntegerForKey:@"min"];
        range = [coder decodeIntegerForKey:@"range"];
        velocityRelative = [coder decodeBoolForKey:@"velocityRelative"];
        directionRelative = [coder decodeBoolForKey:@"directionRelative"];
        distanceRange = [coder decodeIntegerForKey:@"distanceRange"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:baseType.index forKey:@"baseType"];
    [coder encodeInteger:min forKey:@"min"];
    [coder encodeInteger:range forKey:@"range"];
    [coder encodeBool:velocityRelative forKey:@"velocityRelative"];
    [coder encodeBool:directionRelative forKey:@"directionRelative"];
    [coder encodeInteger:distanceRange forKey:@"distanceRange"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        baseType = [[coder getIndexRefWithIndex:[coder decodeSInt32]
                                       forClass:[BaseObject class]] retain];
        min = [coder decodeSInt32];
        range = [coder decodeSInt32];
        velocityRelative = (BOOL)[coder decodeSInt8];
        directionRelative = (BOOL)[coder decodeSInt8];
        distanceRange = [coder decodeSInt32];
        [coder skip:6u];
    }
    return self;
}
@end

@implementation PlaySoundAction
@synthesize priority, persistence, isAbsolute;
@synthesize volume, volumeRange;
@synthesize soundId, soundIdRange;

- (id) init {
    self = [super init];
    if (self) {
        priority = 1;//???
        persistence = 1;///???
        isAbsolute = YES;//???
        volume = 1;//???
        volumeRange = 0;
        soundId = -1;//???
        soundIdRange = 0;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        priority = [coder decodeIntegerForKey:@"priority"];
        persistence = [coder decodeIntegerForKey:@"persistence"];
        isAbsolute = [coder decodeBoolForKey:@"isAbsolute"];
        volume = [coder decodeIntegerForKey:@"volume"];
        volumeRange = [coder decodeIntegerForKey:@"volumeRange"];
        soundId = [coder decodeIntegerForKey:@"soundId"];
        soundIdRange = [coder decodeIntegerForKey:@"soundIdRange"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:priority forKey:@"priority"];
    [coder encodeInteger:persistence forKey:@"persistence"];
    [coder encodeBool:isAbsolute forKey:@"isAbsolute"];
    [coder encodeInteger:volume forKey:@"volume"];
    [coder encodeInteger:volumeRange forKey:@"volumeRange"];
    [coder encodeInteger:soundId forKey:@"soundId"];
    [coder encodeInteger:soundIdRange forKey:@"soundIdRange"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    if (self) {
        priority = [coder decodeUInt8];
        [coder skip:1u];
        persistence = [coder decodeSInt32];
        isAbsolute = (BOOL)[coder decodeSInt8];
        [coder skip:1u];
        volume = [coder decodeSInt32];
        volumeRange = [coder decodeSInt32];
        soundId = [coder decodeSInt32];
        soundIdRange = [coder decodeSInt32];
    }
    return self;
}
@end

@implementation MakeSparksAction
@synthesize count, velocity, velocityRange, color;

- (id) init {
    self = [super init];
    if (self) {
        count = 1;//???
        velocity = 1;//???
        velocityRange = 0;
        color = 0;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        count = [coder decodeIntegerForKey:@"count"];
        velocity = [coder decodeIntegerForKey:@"velocity"];
        velocityRange = [coder decodeIntegerForKey:@"velocityRange"];
        color = [coder decodeIntegerForKey:@"color"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:count forKey:@"count"];
    [coder encodeInteger:velocity forKey:@"velocity"];
    [coder encodeInteger:velocityRange forKey:@"velocityRange"];
    [coder encodeInteger:color forKey:@"color"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    if (self) {
        count = [coder decodeSInt32];
        velocity = [coder decodeSInt32];
        velocityRange = [coder decodeSInt32];
        color = [coder decodeUInt8];
        [coder skip:11u];
    }
    return self;
}
@end

@implementation ReleaseEnergyAction
@synthesize percent;

- (id) init {
    self = [super init];
    if (self) {
        percent = 100.0f;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        percent = [coder decodeFloatForKey:@"percent"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeFloat:percent forKey:@"percent"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        percent = [coder decodeFixed];
        [coder skip:20u];
    }
    return self;
}
@end

@implementation LandAtAction
@synthesize speed;

- (id) init {
    self = [super init];
    if (self) {
        speed = 1;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        speed = [coder decodeIntegerForKey:@"speed"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:speed forKey:@"speed"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        speed = [coder decodeSInt32];
        [coder skip:20u];
    }
    return self;
}
@end

@implementation EnterWarpAction
@synthesize warpSpeed;

- (id) init {
    self = [super init];
    if (self) {
        warpSpeed = 1;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        warpSpeed = [coder decodeIntegerForKey:@"warpSpeed"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:warpSpeed forKey:@"warpSpeed"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        warpSpeed = [coder decodeSInt32];
        [coder skip:20u];
    }
    return self;
}
@end

@implementation DisplayMessageAction
@synthesize ID, page;

- (id) init {
    self = [super init];
    if (self) {
        ID = -1;
        page = -1;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        ID = [coder decodeIntegerForKey:@"id"];
        page = [coder decodeIntegerForKey:@"page"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:ID forKey:@"id"];
    [coder encodeInteger:page forKey:@"page"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        ID = [coder decodeSInt16];
        page = [coder decodeSInt16];
        [coder skip:20u];
    }
    return self;
}
@end

@implementation ChangeScoreAction
@synthesize player, score, amount;

- (id) init {
    self = [super init];
    if (self) {
        player = 0;//???
        score = 0;//???
        amount = 0;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        player = [coder decodeIntegerForKey:@"player"];
        score = [coder decodeIntegerForKey:@"score"];
        amount = [coder decodeIntegerForKey:@"amount"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:player forKey:@"player"];
    [coder encodeInteger:score forKey:@"score"];
    [coder encodeInteger:amount forKey:@"amount"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        player = [coder decodeSInt32];
        score = [coder decodeSInt32];
        amount = [coder decodeSInt32];
        [coder skip:12u];
    }
    return self;
}
@end

@implementation DeclareWinnerAction
@synthesize player, nextLevel, text;

- (id) init {
    self = [super init];
    if (self) {
        player = 0;
        nextLevel = [[Index alloc] init];
        text = [[NSMutableString alloc] init];
    }
    return self;
}

- (void) dealloc {
    [nextLevel release];
    [text release];
    [super dealloc];
}
- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        player = [coder decodeIntegerForKey:@"player"];
        [nextLevel release];
        nextLevel = [[coder getIndexRefWithIndex:[coder decodeIntegerForKey:@"nextLevel"]
                                        forClass:[Scenario class]] retain];
        [text setString:[coder decodeStringForKey:@"text"]];
    }

    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:player forKey:@"player"];
    [coder encodeInteger:nextLevel.index forKey:@"nextLevel"];
    [coder encodeString:text forKey:@"text"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        player = [coder decodeSInt32];
        [nextLevel release];
        nextLevel = [[coder getIndexRefWithIndex:[coder decodeSInt32]
                                        forClass:[Scenario class]] retain];
        text = [[NSNumber alloc] initWithInt:[coder decodeSInt32]];
        [coder skip:12u];
    }
    return self;
}
@end

@implementation DieAction
@synthesize how;

- (id) init {
    self = [super init];
    if (self) {
        how = DieActionNormal;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        NSString *howStr = [coder decodeStringForKey:@"how"];
        if ([howStr isEqual:@"plain"]) {
            how = DieActionNormal;
        } else if ([howStr isEqual:@"expire"]) {
            how = DieActionExpire;
        } else if ([howStr isEqual:@"destroy"]){
            how = DieActionDestroy;
        } else if ([howStr isEqual:@""]) {//Glitch? set to Normal
            how = DieActionNormal;
        } else {
            @throw [NSString stringWithFormat:@"Invalid die action type: %@", howStr];
        }
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    switch (how) {
        case DieActionNormal:
            [coder encodeString:@"plain" forKey:@"how"];
            break;
        case DieActionExpire:
            [coder encodeString:@"expire" forKey:@"how"];
            break;
        case DieActionDestroy:
            [coder encodeString:@"destroy" forKey:@"how"];
            break;
        default:
            @throw [NSString stringWithFormat:@"Invalid die action type: %d", how];
            break;
    }
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        how = [coder decodeSInt8];
        [coder skip:23u];
    }
    return self;
}
@end

@implementation SetDestinationAction
@end

@implementation ActivateSpecialAction
@end

@implementation ActivatePulseAction
@end

@implementation ActivateBeamAction
@end

@implementation ColorFlashAction
@synthesize duration, color, shade;

- (id) init {
    self = [super init];
    if (self) {
        duration = 1;//???
        color = 0;//??? grey
        shade = 0;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        duration = [coder decodeIntegerForKey:@"duration"];
        color = [coder decodeIntegerForKey:@"color"];
        shade = [coder decodeIntegerForKey:@"shade"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:duration forKey:@"duration"];
    [coder encodeInteger:color forKey:@"color"];
    [coder encodeInteger:shade forKey:@"shade"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        duration = [coder decodeSInt32];
        color = [coder decodeUInt8];
        shade = [coder decodeUInt8];
        [coder skip:18u];
    }
    return self;
}
@end

@implementation CreateObjectSetDestinationAction
@end

@implementation NilTargetAction
@end

@implementation DisableKeysAction
@synthesize keyMask;

- (id) init {
    self = [super init];
    keyMask = 0x00000000;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    keyMask = [coder decodeIntegerForKey:@"keyMask"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:keyMask forKey:@"keyMask"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    keyMask = [coder decodeUInt32];
    [coder skip:20u];
    return self;
}
@end

@implementation EnableKeysAction
@end

@implementation SetZoomLevelAction
@synthesize zoomLevel;

- (id) init {
    self = [super init];
    if (self) {
        zoomLevel = 1;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        zoomLevel = [coder decodeIntegerForKey:@"zoomLevel"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:zoomLevel forKey:@"value"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        zoomLevel = [coder decodeUInt32];
        [coder skip:20u];
    }
    return self;
}
@end

@implementation ComputerSelectAction
@synthesize screen, line;

- (id) init {
    self = [super init];
    if (self) {
        screen = 1;//???
        line = 1;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        screen = [coder decodeIntegerForKey:@"screen"];
        line = [coder decodeIntegerForKey:@"line"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:screen forKey:@"screen"];
    [coder encodeInteger:line forKey:@"line"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        screen = [coder decodeSInt32];
        line = [coder decodeSInt32];
        [coder skip:16u];
    }
    return self;
}
@end

@implementation AssumeInitialObjectAction
@synthesize ID;

- (id) init {
    self = [super init];
    if (self) {
        ID = -1;//???
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        ID = [coder decodeIntegerForKey:@"id"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:ID forKey:@"id"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        ID = [coder decodeUInt32];
        [coder skip:20u];
    }
    return self;
}
@end

/* Copying stub.
@implementation CN
- (id) init {
    self = [super init];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
}
@end
*/