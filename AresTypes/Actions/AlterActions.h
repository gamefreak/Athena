//
//  AlterActions.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Action.h"

@class Index;
@class XSIPoint;

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
    AlterOwner,
    AlterHidden,
    AlterCloak,
    AlterOffline,
    AlterCurrentTurnRate,
    AlterBaseType,
    AlterActiveCondition,
    AlterOccupation,
    AlterAbsoluteCash,
    AlterAge,
    AlterAbsoluteLocation = 26
} ActionAlterType; //Blegh


@interface AlterAction : Action <ResClassOverriding> {
}
+ (ActionAlterType) alterTypeForString:(NSString *)type;
+ (NSString *) stringForAlterType:(ActionAlterType)type;

+ (ActionAlterType) alterTypeForClass:(Class)class;
+ (Class) classForType:(ActionAlterType)type;
@end

@interface AlterActionValueClass : AlterAction {
    int value;
}
@property (readwrite, assign) int value;
@end

@interface AlterActionRangeClass : AlterAction {
    int min;
    int range;
}
@property (readwrite, assign) int min;
@property (readwrite, assign) int range;
@end

@interface AlterActionRelativeRangeClass : AlterAction {
    BOOL relative;
    int min, range;
}
@property (readwrite, assign) BOOL relative;
@property (readwrite, assign) int min;
@property (readwrite, assign) int range;
@end

@interface AlterActionIDRefClass : AlterAction {
    Index *IDRef;
}
@property (readwrite, retain) Index *IDRef;
@end

@interface AlterHealthAction : AlterActionValueClass {} @end
@interface AlterVelocityAction : AlterActionRelativeRangeClass {} @end
@interface AlterThrustAction : AlterActionRelativeRangeClass {} @end
@interface AlterMaxThrustAction : AlterActionValueClass {} @end
@interface AlterMaxVelocityAction : AlterActionValueClass {} @end
@interface AlterMaxTurnRateAction : AlterActionValueClass {} @end
@interface AlterLocationAction : AlterActionRelativeRangeClass {} @end
@interface AlterScaleAction : AlterActionValueClass {} @end
@interface AlterPulseWeaponAction : AlterActionIDRefClass {} @end
@interface AlterBeamWeaponAction : AlterActionIDRefClass {} @end
@interface AlterSpecialWeaponAction : AlterActionIDRefClass {} @end
@interface AlterEnergyAction : AlterActionValueClass {} @end
//@interface AlterOnwerAction : AlterAction {} @end
@interface AlterHiddenAction : AlterActionRangeClass {} @end
@interface AlterCloakAction : AlterAction {} @end
@interface AlterOfflineAction : AlterActionRangeClass {} @end
@interface AlterCurrentTurnRateAction : AlterActionRangeClass {} @end
//@interface AlterBaseTypeAction : AlterAction {} @end
//@interface AlterActiveConditionAction : AlterAction {} @end
@interface AlterOccupationAction : AlterActionValueClass {} @end
//@interface AlterAbsoluteCashAction : AlterAction {} @end
@interface AlterAgeAction : AlterActionRangeClass {} @end
//@interface AlterAbsoluteLocationAction : AlterAction {} @end

@interface AlterOwnerAction : AlterAction {
    BOOL useObjectsOwner;
    int value;
}
@property (readwrite, assign) BOOL useObjectsOwner;
@property (readwrite, assign) int value;
@end


@interface AlterBaseTypeAction : AlterAction {
    BOOL retainAmmoCount;
    Index *IDRef;
}
@property (readwrite, assign) BOOL retainAmmoCount;
@property (readwrite, retain) Index *IDRef;
@end

@interface AlterActiveConditionAction : AlterAction {
    BOOL conditionTrue;
    int min, range;
}
@property (readwrite, assign) BOOL conditionTrue;
@property (readwrite, assign) int min;
@property (readwrite, assign) int range;
@end

@interface AlterAbsoluteCashAction : AlterAction {
    BOOL useObjectsOwner;
    int value;
    int player;
}

@property (readwrite, assign) BOOL useObjectsOwner;
@property (readwrite, assign) int value;
@property (readwrite, assign) int player;
@end

@interface AlterAbsoluteLocationAction : AlterAction {
    BOOL relative;
    XSIPoint *point;
}
@property (readwrite, assign) BOOL relative;
@property (readwrite, retain) XSIPoint *point;
@end
