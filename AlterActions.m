//
//  AlterActions.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "AlterActions.h"
#import "Archivers.h"

@implementation AlterAction
@synthesize alterType, isRelative, value;
@synthesize minimum, range, ID;

- (id) init {
    self = [super init];
    alterType = AlterHealth;
    isRelative = NO;
    value = 0;
    minimum = 0;
    range = 0;
    ID = -1;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    alterType = [AlterAction alterTypeForString:[coder decodeStringForKey:@"alterType"]];

    switch (alterType) {
        case AlterVelocity:
        case AlterThrust:
        case AlterLocation:
        case AlterAge:
        case AlterAbsoluteLocation:
            isRelative = [coder decodeBoolForKey:@"relative"];
            break;
        case AlterOnwer:
        case AlterAbsoluteCash:
            isRelative = [coder decodeBoolForKey:@"useObjectsOwner"];
            break;
        case AlterBaseType:
            isRelative = [coder decodeBoolForKey:@"retainAmmoCount"];
            break;
        default:
            break;
    }

    switch (alterType) {
        case AlterHealth:
        case AlterMaxThrust:
        case AlterMaxVelocity:
        case AlterMaxTurnRate:
        case AlterScale:
        case AlterEnergy:
        case AlterOnwer:
        case AlterOccupation:
        case AlterAbsoluteCash:
            value = [coder decodeIntegerForKey:@"value"];
            break;
        default:
            break;
    }

    switch (alterType) {
        case AlterVelocity:
        case AlterThrust:
        case AlterLocation:
        case AlterHidden:
        case AlterOnwer:
        case AlterCurrentTurnRate:
        case AlterActiveCondition:
        case AlterAge:
            minimum = [coder decodeIntegerForKey:@"minimum"];
            range = [coder decodeIntegerForKey:@"range"];
            break;
        case AlterAbsoluteLocation:
            minimum = [coder decodeIntegerForKey:@"x"];
            range = [coder decodeIntegerForKey:@"y"];
            break;
        default:
            break;
    }

    switch (alterType) {
        case AlterPulseWeapon:
        case AlterBeamWeapon:
        case AlterSpecialWeapon:
        case AlterBaseType:
            ID = [coder decodeIntegerForKey:@"id"];
            break;
        case AlterAbsoluteCash:
            ID = [coder decodeIntegerForKey:@"player"];
            break;
        default:
            break;
    }

    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeString:[AlterAction stringForAlterType:alterType] forKey:@"alterType"];

    switch (alterType) {
        case AlterVelocity:
        case AlterThrust:
        case AlterLocation:
        case AlterAge:
        case AlterAbsoluteLocation:
            [coder encodeBool:isRelative forKey:@"relative"];
            break;
        case AlterOnwer:
        case AlterAbsoluteCash:
            [coder encodeBool:isRelative forKey:@"useObjectsOwner"];
            break;
        case AlterBaseType:
            [coder encodeBool:isRelative forKey:@"retainAmmoCount"];
            break;
        default:
            break;
    }

    switch (alterType) {
        case AlterHealth:
        case AlterMaxThrust:
        case AlterMaxVelocity:
        case AlterMaxTurnRate:
        case AlterScale:
        case AlterEnergy:
        case AlterOnwer:
        case AlterOccupation:
        case AlterAbsoluteCash:
            [coder encodeInteger:value forKey:@"value"];
            break;
        default:
            break;
    }

    switch (alterType) {
        case AlterVelocity:
        case AlterThrust:
        case AlterLocation:
        case AlterHidden:
        case AlterOnwer:
        case AlterCurrentTurnRate:
        case AlterActiveCondition:
        case AlterAge:
            [coder encodeInteger:minimum forKey:@"minimum"];
            [coder encodeInteger:range forKey:@"range"];
            break;
        case AlterAbsoluteLocation:
            [coder encodeInteger:minimum forKey:@"x"];
            [coder encodeInteger:range forKey:@"y"];
            break;
        default:
            break;
    }

    switch (alterType) {
        case AlterPulseWeapon:
        case AlterBeamWeapon:
        case AlterSpecialWeapon:
        case AlterBaseType:
            [coder encodeInteger:ID forKey:@"id"];
            break;
        case AlterAbsoluteCash:
            [coder encodeInteger:ID forKey:@"player"];
            break;
        default:
            break;
    }
}

+ (ActionAlterType) alterTypeForString:(NSString *)type {
    if ([type isEqual:@"health"]) {
        return AlterHealth;
    } else if ([type isEqual:@"velocity"]) {
        return AlterVelocity;
    } else if ([type isEqual:@"thrust"]) {
        return AlterThrust;
    } else if ([type isEqual:@"max thrust"]) {
        return AlterMaxThrust;
    } else if ([type isEqual:@"max velocity"]) {
        return AlterMaxVelocity;
    } else if ([type isEqual:@"max turn rate"]) {
        return AlterMaxTurnRate;
    } else if ([type isEqual:@"location"]) {
        return AlterLocation;
    } else if ([type isEqual:@"scale"]) {
        return AlterScale;
    } else if ([type isEqual:@"pulse weapon"]) {
        return AlterPulseWeapon;
    } else if ([type isEqual:@"beam weapon"]) {
        return AlterBeamWeapon;
    } else if ([type isEqual:@"special weapon"]) {
        return AlterSpecialWeapon;
    } else if ([type isEqual:@"energy"]) {
        return AlterEnergy;
    } else if ([type isEqual:@"owner"]) {
        return AlterOnwer;
    } else if ([type isEqual:@"hidden"]) {
        return AlterHidden;
    } else if ([type isEqual:@"cloak"]) {
        return AlterCloak;
    } else if ([type isEqual:@"offline"]) {
        return AlterOffline;
    } else if ([type isEqual:@"current turn rate"]) {
        return AlterCurrentTurnRate;
    } else if ([type isEqual:@"base type"]) {
        return AlterBaseType;
    } else if ([type isEqual:@"active condition"]) {
        return AlterActiveCondition;
    } else if ([type isEqual:@"occupation"]) {
        return AlterOccupation;
    } else if ([type isEqual:@"absolute cash"]) {
        return AlterAbsoluteCash;
    } else if ([type isEqual:@"age"]) {
        return AlterAge;
    } else if ([type isEqual:@"absolute location"]) {
        return AlterAbsoluteLocation;
    } else {
        @throw [NSString stringWithFormat:@"Invalid alter action type: %@", type];
    }
    return -1;
    
}

+ (NSString *) stringForAlterType:(ActionAlterType)type {
    switch (type) {
        case AlterHealth:
            return @"health";
            break;
        case AlterVelocity:
            return @"velocity";
            break;
        case AlterThrust:
            return @"thrust";
            break;
        case AlterMaxThrust:
            return @"max thrust";
            break;
        case AlterMaxVelocity:
            return @"max velocity";
            break;
        case AlterMaxTurnRate:
            return @"max turn rate";
            break;
        case AlterLocation:
            return @"location";
            break;
        case AlterScale:
            return @"scale";
            break;
        case AlterPulseWeapon:
            return @"pulse weapon";
            break;
        case AlterBeamWeapon:
            return @"beam weapon";
            break;
        case AlterSpecialWeapon:
            return @"special";
            break;
        case AlterEnergy:
            return @"energy";
            break;
        case AlterOnwer:
            return @"owner";
            break;
        case AlterHidden:
            return @"hidden";
            break;
        case AlterCloak:
            return @"cloak";
            break;
        case AlterOffline:
            return @"offline";
            break;
        case AlterCurrentTurnRate:
            return @"current turn rate";
            break;
        case AlterBaseType:
            return @"base type";
            break;
        case AlterActiveCondition:
            return @"active condition";
            break;
        case AlterOccupation:
            return @"occupation";
            break;
        case AlterAbsoluteCash:
            return @"absolute cash";
            break;
        case AlterAge:
            return @"age";
            break;
        case AlterAbsoluteLocation:
            return @"absolute location";
            break;
        default:
            @throw [NSString stringWithFormat:@"Invalid alter action type: %d", type];
            break;
    }
    return nil;
}
@end
