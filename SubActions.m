//
//  SubActions.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SubActions.h"
#import "Archivers.h"

@implementation NoAction
@end

@implementation CreateObjectAction
- (id) init {
    self = [super init];
    baseType = -1;
    min = 1;
    range = 0;
    velocityRelative = YES;//???
    directionRelative = YES;//???
    distanceRange = 0;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    baseType = [coder decodeIntegerForKey:@"baseType"];
    min = [coder decodeIntegerForKey:@"min"];
    range = [coder decodeIntegerForKey:@"range"];
    velocityRelative = [coder decodeBoolForKey:@"velocityRelative"];
    directionRelative = [coder decodeBoolForKey:@"directionRelative"];
    distanceRange = [coder decodeIntegerForKey:@"distanceRange"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:baseType forKey:@"baseType"];
    [coder encodeInteger:min forKey:@"min"];
    [coder encodeInteger:range forKey:@"range"];
    [coder encodeBool:velocityRelative forKey:@"velocityRelative"];
    [coder encodeBool:directionRelative forKey:@"directionRelative"];
    [coder encodeInteger:distanceRange forKey:@"distanceRange"];
}
@end

@implementation PlaySoundAction
- (id) init {
    self = [super init];
    priority = 1;//???
    persistence = 1;///???
    isAbsolute = YES;//???
    volume = 1;//???
    volumeRange = 0;
    soundId = -1;//???
    soundIdRange = 0;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    priority = [coder decodeIntegerForKey:@"priority"];
    persistence = [coder decodeIntegerForKey:@"persistence"];
    isAbsolute = [coder decodeBoolForKey:@"isAbsolute"];
    volume = [coder decodeIntegerForKey:@"volume"];
    volumeRange = [coder decodeIntegerForKey:@"volumeRange"];
    soundId = [coder decodeIntegerForKey:@"soundId"];
    soundIdRange = [coder decodeIntegerForKey:@"soundIdRange"];
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
@end

@implementation MakeSparksAction
- (id) init {
    self = [super init];
    count = 1;//???
    velocity = 1;//???
    velocityRange = 0;
    color = 0;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    count = [coder decodeIntegerForKey:@"count"];
    velocity = [coder decodeIntegerForKey:@"velocity"];
    velocityRange = [coder decodeIntegerForKey:@"velocityRange"];
    color = [coder decodeIntegerForKey:@"color"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:count forKey:@"count"];
    [coder encodeInteger:velocity forKey:@"velocity"];
    [coder encodeInteger:velocityRange forKey:@"velocityRange"];
    [coder encodeInteger:color forKey:@"color"];
}
@end

@implementation ReleaseEnergyAction
- (id) init {
    self = [super init];
    percent = 100.0f;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    percent = [coder decodeFloatForKey:@"percent"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeFloat:percent forKey:@"percent"];
}
@end

@implementation LandAtAction
- (id) init {
    self = [super init];
    speed = 1;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    speed = [coder decodeIntegerForKey:@"speed"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:speed forKey:@"speed"];
}
@end

@implementation EnterWarpAction
- (id) init {
    self = [super init];
    warpSpeed = 1;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    warpSpeed = [coder decodeIntegerForKey:@"warpSpeed"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:warpSpeed forKey:@"warpSpeed"];
}
@end

@implementation DisplayMessageAction
- (id) init {
    self = [super init];
    ID = -1;
    page = -1;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    ID = [coder decodeIntegerForKey:@"id"];
    page = [coder decodeIntegerForKey:@"page"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:ID forKey:@"id"];
    [coder encodeInteger:page forKey:@"page"];
}
@end

@implementation ChangeScoreAction
- (id) init {
    self = [super init];
    player = 0;//???
    score = 0;//???
    amount = 0;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    player = [coder decodeIntegerForKey:@"player"];
    score = [coder decodeIntegerForKey:@"score"];
    amount = [coder decodeIntegerForKey:@"amount"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:player forKey:@"player"];
    [coder encodeInteger:score forKey:@"score"];
    [coder encodeInteger:amount forKey:@"amount"];
}
@end

@implementation DeclareWinnerAction
- (id) init {
    self = [super init];
    player = 0;
    nextLevel = 0;
    text = [[NSMutableString alloc] init];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    player = [coder decodeIntegerForKey:@"player"];
    nextLevel = [coder decodeIntegerForKey:@"nextLevel"];

    [text setString:[coder decodeStringForKey:@"text"]];

    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:player forKey:@"player"];
    [coder encodeInteger:nextLevel forKey:@"nextLevel"];
    [coder encodeString:text forKey:@"text"];
}

- (void) dealloc {
    [text release];
    [super dealloc];
}
@end

@implementation DieAction
- (id) init {
    self = [super init];
    how = DieActionNormal;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    NSString *howStr = [coder decodeStringForKey:@"how"];
    if ([howStr isEqual:@"plain"]) {
        how = DieActionNormal;
    } else if ([howStr isEqual:@"expire"]) {
        how = DieActionExpire;
    } else if ([howStr isEqual:@"destroy"]){
        how = DieActionDestroy;
    } else {
        @throw [NSString stringWithFormat:@"Invalid die action type: %@", howStr];
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
- (id) init {
    self = [super init];
    duration = 1;//???
    color = 0;//??? grey
    shade = 0;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    duration = [coder decodeIntegerForKey:@"duration"];
    color = [coder decodeIntegerForKey:@"color"];
    shade = [coder decodeIntegerForKey:@"shade"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:duration forKey:@"duration"];
    [coder encodeInteger:color forKey:@"color"];
    [coder encodeInteger:shade forKey:@"shade"];
}
@end

@implementation CreateObjectSetDestinationAction
@end

@implementation NilTargetAction
@end

@implementation DisableKeysAction
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
@end

@implementation EnableKeysAction
@end

@implementation SetZoomLevelAction
- (id) init {
    self = [super init];
    zoomLevel = 1;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    zoomLevel = [coder decodeIntegerForKey:@"zoomLevel"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:zoomLevel forKey:@"value"];
}
@end

@implementation ComputerSelectAction
- (id) init {
    self = [super init];
    screen = 1;//???
    line = 1;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    screen = [coder decodeIntegerForKey:@"screen"];
    line = [coder decodeIntegerForKey:@"line"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:screen forKey:@"screen"];
    [coder encodeInteger:line forKey:@"line"];
}
@end

@implementation AssumeInitialObjectAction
- (id) init {
    self = [super init];
    ID = -1;//???
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    ID = [coder decodeIntegerForKey:@"id"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:ID forKey:@"id"];
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