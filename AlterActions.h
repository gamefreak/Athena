//
//  AlterActions.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Action.h"

typedef enum {
    AlterHealth,
    AlterVelocity,
    AlterThrust,
    AlterMaxThrust,
    AlterMaxVelocity,
    AlterMaxTurnRate,
    AlterLocation,
    AlterScale,
    AlterPulseWeapon,
    AlterBeamWeapon,
    AlterSpecialWeapon,
    AlterEnergy,
    AlterOnwer,
    AlterHidden,
    AlterCloak,
    AlterOffline,
    AlterCurrentTurnRate,
    AlterBaseType,
    AlterActiveCondition,
    AlterOccupation,
    AlterAbsoluteCash,
    AlterAge,
    AlterAbsoluteLocation
} ActionAlterType;


@interface AlterAction : Action {
}
+ (ActionAlterType) alterTypeForString:(NSString *)type;
+ (NSString *) stringForAlterType:(ActionAlterType)type;
@end
