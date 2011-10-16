//
//  Action.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "Action.h"
#import "Archivers.h"
#import "AlterActions.h"
#import "SubActions.h"
#import "BaseObjectFlags.h"

@implementation Action
@synthesize reflexive, inclusiveFilter, exclusiveFilter;
@synthesize subjectOverride, directOverride, owner, delay;
@dynamic nibName, useLevelKeyFlags;
- (id) init {
    self = [super init];
    if (self) {
        reflexive = NO;//Best way?
        inclusiveFilter = [[BaseObjectAttributes alloc] init];
        exclusiveFilter = [[BaseObjectAttributes alloc] init];
        owner = ObjectOwnerAny;
        delay = 0;
    }
    return self;
}

- (void) dealloc {
    [inclusiveFilter release];
    [exclusiveFilter release];
    [super dealloc];
}

//MARK: Lua Coding

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        reflexive = [coder decodeBoolForKey:@"reflexive"];
        [inclusiveFilter setHex:[coder decodeIntegerForKey:@"inclusiveFilter"]];
        [exclusiveFilter setHex:[coder decodeIntegerForKey:@"exclusiveFilter"]];
        subjectOverride = [coder decodeIntegerForKey:@"subjectOverride"];
        directOverride = [coder decodeIntegerForKey:@"directOverride"];

        owner = [coder decodeIntegerForKey:@"owner"];
        delay = [coder decodeIntegerForKey:@"delay"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:[Action stringForType:[Action typeForClass:[self class]]]
                 forKey:@"type"];
    [coder encodeBool:reflexive forKey:@"reflexive"];
    [coder encodeInteger:[inclusiveFilter hex] forKey:@"inclusiveFilter"];
    [coder encodeInteger:[exclusiveFilter hex] forKey:@"exclusiveFilter"];
    [coder encodeInteger:subjectOverride forKey:@"subjectOverride"];
    [coder encodeInteger:directOverride forKey:@"directOverride"];

    [coder encodeInteger:owner forKey:@"owner"];
    [coder encodeInteger:delay forKey:@"delay"];
}

+ (BOOL) isComposite {
    return YES;
}

//MARK: Res Coding

//Because my <s>awesome</s> FAILURE doesn't work 
+ (Class) classForResCoder:(ResUnarchiver *)coder {
    sint8 type = [coder decodeSInt8];
    [coder seek:0u];
    Class actionClass = [self classForType:type];
    if (actionClass == [AlterAction class]) {
        actionClass = [AlterAction classForResCoder:coder];
    }
    return actionClass;
}


- (id)initWithResArchiver:(ResUnarchiver *)coder {
    /*
     * Let this stand as a monument to stupidity
     * And 6 hours of debugging + 2 downgrades of Xcode
     * //[self autorelease]
     * //This is crazy, I can make an object change it's own class!
     * //Remember kids, don't try this at home.
     * //    self = [[[[self class] classForType:type_] alloc] init];
     */
    self = [self init];
    if (self) {
        [coder skip:1u];//type
        reflexive = (BOOL)[coder decodeSInt8];
        [inclusiveFilter setHex:[coder decodeUInt32]];
        [exclusiveFilter setHex:[coder decodeUInt32]];
        owner = [coder decodeSInt16];
        delay = [coder decodeSInt32];
        subjectOverride = [coder decodeSInt16];
        directOverride = [coder decodeSInt16];
        [coder skip:4u];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt8:[Action typeForClass:[self class]]];
    [coder encodeSInt8:reflexive];
    [coder encodeUInt32:[inclusiveFilter hex]];
    [coder encodeUInt32:[exclusiveFilter hex]];
    [coder encodeSInt16:owner];
    [coder encodeSInt32:delay];
    [coder encodeSInt16:subjectOverride];
    [coder encodeSInt16:directOverride];
    [coder skip:4u];
}

+ (ResType)resType {
    return 'obac';
}

+ (NSString *)typeKey {
    return @"obac";
}

+ (BOOL)isPacked {
    return YES;
}

+ (size_t)sizeOfResourceItem {
    return 48;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    Class type = [self classForType:[self typeForString:[coder decodeStringForKey:@"type"]]];
    if (type == [AlterAction class]) {
        type = [AlterAction classForAlterType:[AlterAction alterTypeForString:[coder decodeStringForKey:@"alterType"]]];
    }
    return type;
}

- (BOOL)useLevelKeyFlags {
    return ([exclusiveFilter hex] & 0xffffffff) == 0xffffffff;
}

- (void)setUseLevelKeyFlags:(BOOL)useLevelKeyFlags {
    @synchronized(self) {
        assert(useLevelKeyFlags == 1 || useLevelKeyFlags == 0);
        if (useLevelKeyFlags == 1) {
            [exclusiveFilter setHex:0xffffffff];
        } else {
            [exclusiveFilter setHex:0x00000000];
        }
    }
}

+ (ActionType)typeForClass:(Class)class {
    if ([NoAction class] == class) {
        return NoActionType;
    } else if ([CreateObjectAction class] == class) {
        return CreateObjectActionType;
    } else if ([PlaySoundAction class] == class) {
        return PlaySoundActionType;
    } else if ([class isSubclassOfClass:[AlterAction class]]) {
        return AlterActionType;
    } else if ([MakeSparksAction class] == class) {
        return MakeSparksActionType;
    } else if ([ReleaseEnergyAction class] == class) {
        return ReleaseEnergyActionType;
    } else if ([LandAtAction class] == class) {
        return LandAtActionType;
    } else if ([EnterWarpAction class] == class) {
        return EnterWarpActionType;
    } else if ([DisplayMessageAction class] == class) {
        return DisplayMessageActionType;
    } else if ([ChangeScoreAction class] == class) {
        return ChangeScoreActionType;
    } else if ([DeclareWinnerAction class] == class) {
        return DeclareWinnerActionType;
    } else if ([DieAction class] == class) {
        return DieActionType;
    } else if ([SetDestinationAction class] == class) {
        return SetDestinationActionType;
    } else if ([ActivateSpecialAction class] == class) {
        return ActivateSpecialActionType;
    } else if ([ActivatePulseAction class] == class) {
        return ActivatePulseActionType;
    } else if ([ActivateBeamAction class] == class) {
        return ActivateBeamActionType;
    } else if ([ColorFlashAction class] == class) {
        return ColorFlashActionType;
    } else if ([CreateObjectSetDestinationAction class] == class) {
        return CreateObjectSetDestinationActionType;
    } else if ([NilTargetAction class] == class) {
        return NilTargetActionType;
    } else if ([DisableKeysAction class] == class) {
        return DisableKeysActionType;
    } else if ([EnableKeysAction class] == class) {
        return EnableKeysActionType;
    } else if ([SetZoomLevelAction class] == class) {
        return SetZoomLevelActionType;
    } else if ([ComputerSelectAction class] == class) {
        return ComputerSelectActionType;
    } else if ([AssumeInitialObjectAction class] == class) {
        return AssumeInitialObjectActionType;
    }
    return NoActionType;
}

+ (Class) classForType:(ActionType)type {
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
        case AlterActionType:
            //Intermediate step to trigger another +classFor(Res|Lua)Coder method
            return [AlterAction class];
            break;
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

- (NSString *)nibName {
    return @"NoAction";
}

- (void)addObserver:(NSObject *)observer {
    [self addObserver:observer forKeyPath:@"reflexive" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"inclusiveFilter.hex" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"exclusiveFilter.hex" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"subjectOverride" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"directOverride" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"owner" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"delay" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [self removeObserver:observer forKeyPath:@"reflexive"];
    [self removeObserver:observer forKeyPath:@"inclusiveFilter.hex"];
    [self removeObserver:observer forKeyPath:@"exclusiveFilter.hex"];
    [self removeObserver:observer forKeyPath:@"subjectOverride"];
    [self removeObserver:observer forKeyPath:@"directOverride"];
    [self removeObserver:observer forKeyPath:@"owner"];
    [self removeObserver:observer forKeyPath:@"delay"];
}

//copies non subclass specific values to another action object
//used for changing action types.
- (void) copyValuesTo:(Action *)otherAction {
    [otherAction setReflexive:reflexive];
    [otherAction setInclusiveFilter:inclusiveFilter];
    [otherAction setExclusiveFilter:exclusiveFilter];
    [otherAction setSubjectOverride:subjectOverride];
    [otherAction setDirectOverride:directOverride];
    [otherAction setOwner:owner];
    [otherAction setDelay:delay];
}
@end
