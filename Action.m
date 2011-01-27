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

+ (ActionType) typeForString:(NSString *)type {
    if ([type isEqual:@"none"]) {
        return NoActionType;
    } else if ([type isEqual:@"create object"]) {
        return CreateObjectActionType;
    } else if ([type isEqual:@"play sound"]) {
        return PlaySoundActionType;
    } else if ([type isEqual:@"alter"]) {
        return AlterActionType;
    } else if ([type isEqual:@"make sparks"]) {
        return MakeSparksActionType;
    } else if ([type isEqual:@"release energy"]) {
        return ReleaseEnergyActionType;
    } else if ([type isEqual:@"land at"]) {
        return LandAtActionType;
    } else if ([type isEqual:@"enter warp"]) {
        return EnterWarpActionType;
    } else if ([type isEqual:@"display message"]) {
        return DisplayMessageActionType;
    } else if ([type isEqual:@"change score"]) {
        return ChangeScoreActionType;
    } else if ([type isEqual:@"declare winner"]) {
        return DeclareWinnerActionType;
    } else if ([type isEqual:@"die"]) {
        return DieActionType;
    } else if ([type isEqual:@"set destination"]) {
        return SetDestinationActionType;
    } else if ([type isEqual:@"activate special"]) {
        return ActivateSpecialActionType;
    } else if ([type isEqual:@"activate pulse"]) {
        return ActivatePulseActionType;
    } else if ([type isEqual:@"activate beam"]) {
        return ActivateBeamActionType;
    } else if ([type isEqual:@"color flash"]) {
        return ColorFlashActionType;
    } else if ([type isEqual:@"create object set destination"]) {
        return CreateObjectSetDestinationActionType;
    } else if ([type isEqual:@"nil target"]) {
        return NilTargetActionType;
    } else if ([type isEqual:@"disable keys"]) {
        return DisableKeysActionType;
    } else if ([type isEqual:@"enable keys"]) {
        return EnableKeysActionType;
    } else if ([type isEqual:@"set zoom level"]) {
        return SetZoomLevelActionType;
    } else if ([type isEqual:@"computer select"]) {
        return ComputerSelectActionType;
    } else if ([type isEqual:@"assume initial object"]) {
        return AssumeInitialObjectActionType;
    } else {
        @throw [NSString stringWithFormat:@"Unknown action type: %@", type];
    }
    return NoActionType;
}
@end