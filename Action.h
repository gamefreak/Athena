//
//  Action.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

typedef enum {
    NoActionType,
    CreateObjectActionType,
    PlaySoundActionType,
    AlterActionType,
    MakeSparksActionType,
    ReleaseEnergyActionType,
    LandAtActionType,
    EnterWarpActionType,
    DisplayMessageActionType,
    ChangeScoreActionType,
    DeclareWinnerActionType,
    DieActionType,
    SetDestinationActionType,
    ActivateSpecialActionType,
    ActivatePulseActionType,
    ActivateBeamActionType,
    ColorFlashActionType,
    CreateObjectSetDestinationActionType,
    NilTargetActionType,
    DisableKeysActionType,
    EnableKeysActionType,
    SetZoomLevelActionType,
    ComputerSelectActionType,
    AssumeInitialObjectActionType
} ActionType;

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
} AlterAction;

@interface Action : NSObject <LuaCoding> {
    ActionType type;
    BOOL reflexive;
    NSUInteger inclusiveFilter, exclusiveFilter;
    NSInteger subjectOverride, directOverride;
    NSInteger owner;
    NSInteger delay;
}
+ (ActionType) typeForString:(NSString *)type;
+ (NSString *) stringForType:(ActionType) type;
@end

@interface NoAction : Action {}
@end

