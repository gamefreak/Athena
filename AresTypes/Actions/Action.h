//
//  Action.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"
#import "ResCoding.h"

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
    ObjectOwnerAny = 0,
    ObjectOwnerSame = 1,
    ObjectOwnerDifferent = -1
} ObjectOwner;

@class BaseObjectAttributes;

@interface Action : NSObject <LuaCoding, ResCoding, ResClassOverriding> {
    BOOL reflexive;
    BaseObjectAttributes *inclusiveFilter, *exclusiveFilter;
    NSInteger subjectOverride, directOverride;
    ObjectOwner owner;
    NSInteger delay;
}
@property (readwrite, assign) BOOL reflexive;
@property (readwrite, copy) BaseObjectAttributes *inclusiveFilter;
@property (readwrite, copy) BaseObjectAttributes *exclusiveFilter;
@property (readwrite, assign) NSInteger subjectOverride;
@property (readwrite, assign) NSInteger directOverride;
@property (readwrite, assign) BOOL useLevelKeyFlags;
@property (readwrite, assign) ObjectOwner owner;
@property (readwrite, assign) NSInteger delay;
@property (readonly) NSString *nibName;
+ (ActionType) typeForClass:(Class)class;
+ (Class) classForType:(ActionType)type;
+ (ActionType) typeForString:(NSString *)type;
+ (NSString *) stringForType:(ActionType)type;
- (void) addObserver:(NSObject *)observer;
- (void) removeObserver:(NSObject *)observer;
- (void) copyValuesTo:(Action *)otherAction;
@end
