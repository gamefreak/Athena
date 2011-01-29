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
} ActionAlterType; //Blegh


@interface AlterAction : Action {
    ActionAlterType alterType;
    /*
     isRelative becomes:
        useObjectsOwner for alter-owner and alter-absolute-cash
        retainAmmoCount for alter-base-type
        conditionTrue   for alter-active-condion
     */
    BOOL isRelative;
    NSInteger value;
    NSInteger minimum, range;//becomes x, y for alter-absolute-location
    //ID becomes player for alter-absolute-cash
    NSInteger ID;
}
@property (readwrite, assign) ActionAlterType alterType;
@property (readwrite, assign) BOOL isRelative;
@property (readwrite, assign) NSInteger value;
@property (readwrite, assign) NSInteger minimum;
@property (readwrite, assign) NSInteger range;
@property (readwrite, assign) NSInteger ID;

+ (ActionAlterType) alterTypeForString:(NSString *)type;
+ (NSString *) stringForAlterType:(ActionAlterType)type;
@end
