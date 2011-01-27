//
//  Action.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "Action.h"
#import "Archivers.h"
#import "SubActions.h"

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
    type = [Action typeForString:[coder decodeStringForKey:@"type"]];
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
    [coder encodeString:[Action stringForType:type]
                 forKey:@"type"];
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
    ActionType type = [self typeForString:[coder decodeStringForKey:@"type"]];
    switch (type) {
        case NoActionType:
            return [NoAction class];
            break;
        case CreateObjectActionType:
            return [CreateObjectAction class];
            break;
        case PlaySoundActionType:
            return [PlaySoundAction class];
            break;
//        case AlterActionType:
        case MakeSparksActionType:
            return [MakeSparksAction class];
            break;
        case ReleaseEnergyActionType:
            return [ReleaseEnergyAction class];
            break;
        case LandAtActionType:
            return [LandAtAction class];
            break;
        case EnterWarpActionType:
            return [EnterWarpAction class];
            break;
        case DisplayMessageActionType:
            return [DisplayMessageAction class];
            break;
        case ChangeScoreActionType:
            return [ChangeScoreAction class];
            break;
        case DeclareWinnerActionType:
            return [DeclareWinnerAction class];
            break;
        case DieActionType:
            return [DieAction class];
            break;
        case SetDestinationActionType:
            return [SetDestinationAction class];
            break;
        case ActivateSpecialActionType:
            return [ActivateSpecialAction class];
            break;
        case ActivatePulseActionType:
            return [ActivatePulseAction class];
            break;
        case ActivateBeamActionType:
            return [ActivateBeamAction class];
            break;
        case ColorFlashActionType:
            return [ColorFlashAction class];
            break;
        case CreateObjectSetDestinationActionType:
            return [CreateObjectSetDestinationAction class];
            break;
        case NilTargetActionType:
            return [NilTargetAction class];
            break;
        case DisableKeysActionType:
            return [DisableKeysAction class];
            break;
        case EnableKeysActionType:
            return [EnableKeysAction class];
            break;
        case SetZoomLevelActionType:
            return [SetZoomLevelAction class];
            break;
        case ComputerSelectActionType:
            return [ComputerSelectAction class];
            break;
        case AssumeInitialObjectActionType:
            return [AssumeInitialObjectAction class];
            break;
        case AlterActionType:
            @throw [NSString stringWithFormat:@"Unimplemented action type: %@", [self stringForType:type]];
            break;
        default:
            @throw [NSString stringWithFormat:@"Unknown action type: %d", type];
            break;
    }
    return nil;
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

+ (NSString *) stringForType:(ActionType) type {
    switch (type) {
        case NoActionType:
            return @"none";
            break;
        case CreateObjectActionType:
            return @"create object";
            break;
        case PlaySoundActionType:
            return @"play sound";
            break;
        case AlterActionType:
            return @"alter";
            break;
        case MakeSparksActionType:
            return @"make sparks";
            break;
        case ReleaseEnergyActionType:
            return @"release energy";
            break;
        case LandAtActionType:
            return @"land at";
            break;
        case EnterWarpActionType:
            return @"enter warp";
            break;
        case DisplayMessageActionType:
            return @"display message";
            break;
        case ChangeScoreActionType:
            return @"change score";
            break;
        case DeclareWinnerActionType:
            return @"declare winner";
            break;
        case DieActionType:
            return @"die";
            break;
        case SetDestinationActionType:
            return @"set destination";
            break;
        case ActivateSpecialActionType:
            return @"activate special";
            break;
        case ActivatePulseActionType:
            return @"activate pulse";
            break;
        case ActivateBeamActionType:
            return @"activate beam";
            break;
        case ColorFlashActionType:
            return @"color flash";
            break;
        case CreateObjectSetDestinationActionType:
            return @"create object set destination";
            break;
        case NilTargetActionType:
            return @"nil target";
            break;
        case DisableKeysActionType:
            return @"disable keys";
            break;
        case EnableKeysActionType:
            return @"enable keys";
            break;
        case SetZoomLevelActionType:
            return @"set zoom level";
            break;
        case ComputerSelectActionType:
            return @"computer select";
            break;
        case AssumeInitialObjectActionType:
            return @"assume initial object";
            break;
        default:
            @throw [NSString stringWithFormat:@"Unknown action type: %d", type];
            break;
    }
    return nil;
}

@end
