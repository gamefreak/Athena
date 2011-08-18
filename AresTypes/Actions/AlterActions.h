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
    AlterAge,//=21
    AlterAbsoluteLocation = 26
} ActionAlterType; //Blegh


@interface AlterAction : Action <ResClassOverriding> {
}
+ (ActionAlterType) alterTypeForString:(NSString *)type;
+ (NSString *) stringForAlterType:(ActionAlterType)type;

+ (ActionAlterType) alterTypeForClass:(Class)class;
+ (Class) classForAlterType:(ActionAlterType)type;
@end

@interface AlterActionValueClass : AlterAction {
    int value;
}
@property (readwrite, assign) int value;
- (NSString *)valueLabel;
@end

@interface AlterActionFloatValueClass : AlterAction {
    float value;
}
@property (readwrite, assign) float value;
- (NSString *)valueLabel;
@end

@interface AlterActionRangeClass : AlterAction {
    int min;
    int range;
}
@property (readwrite, assign) int min;
@property (readwrite, assign) int range;
- (NSString *)minLabel;
- (NSString *)rangeLabel;
@end

@interface AlterActionFloatRangeClass : AlterAction {
    float min;
    float range;
}
@property (readwrite, assign) float min;
@property (readwrite, assign) float range;
- (NSString *)minLabel;
- (NSString *)rangeLabel;
@end

@interface AlterActionRelativeRangeClass : AlterAction {
    BOOL relative;
    int min, range;
}
@property (readwrite, assign) BOOL relative;
@property (readwrite, assign) int min;
@property (readwrite, assign) int range;
- (NSString *)relativeLabel;
- (NSString *)minLabel;
- (NSString *)rangeLabel;
@end

@interface AlterActionRelativeFloatRangeClass : AlterAction {
    BOOL relative;
    float min, range;
}
@property (readwrite, assign) BOOL relative;
@property (readwrite, assign) float min;
@property (readwrite, assign) float range;
- (NSString *)relativeLabel;
- (NSString *)minLabel;
- (NSString *)rangeLabel;
@end

@interface AlterActionIDRefClass : AlterAction {
    Index *IDRef;
}
@property (readwrite, retain) Index *IDRef;
- (NSString *)pickerLabel;
@end

@interface AlterHealthAction : AlterActionValueClass {} @end
@interface AlterVelocityAction : AlterActionRelativeFloatRangeClass {} @end
@interface AlterThrustAction : AlterActionRelativeRangeClass {} @end
@interface AlterMaxThrustAction : AlterActionFloatValueClass {} @end
@interface AlterMaxVelocityAction : AlterActionFloatValueClass {} @end
@interface AlterMaxTurnRateAction : AlterActionFloatValueClass {} @end
@interface AlterLocationAction : AlterActionRelativeRangeClass {} @end
@interface AlterScaleAction : AlterActionValueClass {} @end
@interface AlterPulseWeaponAction : AlterActionIDRefClass {} @end
@interface AlterBeamWeaponAction : AlterActionIDRefClass {} @end
@interface AlterSpecialWeaponAction : AlterActionIDRefClass {} @end
@interface AlterEnergyAction : AlterActionValueClass {} @end
//@interface AlterOwnerAction : AlterAction {} @end
@interface AlterHiddenAction : AlterActionRangeClass {} @end
@interface AlterCloakAction : AlterAction {} @end
@interface AlterOfflineAction : AlterActionFloatRangeClass {} @end
@interface AlterCurrentTurnRateAction : AlterActionFloatRangeClass {} @end
//@interface AlterBaseTypeAction : AlterAction {} @end
//@interface AlterActiveConditionAction : AlterAction {} @end
@interface AlterOccupationAction : AlterActionValueClass {} @end
//@interface AlterAbsoluteCashAction : AlterAction {} @end
@interface AlterAgeAction : AlterActionRelativeRangeClass {} @end
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
- (NSString *)pickerLabel;
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
- (NSString *)relativeLabel;
- (NSString *)minLabel;
- (NSString *)rangeLabel;
@end

@interface AlterAbsoluteLocationAction : AlterAction {
    BOOL relative;
    XSIPoint *point;
}
@property (readwrite, assign) BOOL relative;
@property (readwrite, retain) XSIPoint *point;
@end
