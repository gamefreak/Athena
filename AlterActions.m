//
//  AlterActions.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "AlterActions.h"


@implementation AlterAction
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
    } else if ([type isEqual:@"special"]) {
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
