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
