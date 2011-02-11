//
//  Action.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@interface Action : NSObject <LuaCoding> {
    ActionType type;
    BOOL reflexive;
    NSUInteger inclusiveFilter, exclusiveFilter;
    NSInteger subjectOverride, directOverride;
    NSInteger owner;
    NSInteger delay;
}
@property (readwrite, assign) ActionType type;
@property (readwrite, assign) BOOL reflexive;
@property (readwrite, assign) NSUInteger inclusiveFilter;
@property (readwrite, assign) NSUInteger exclusiveFilter;
@property (readwrite, assign) NSInteger subjectOverride;
@property (readwrite, assign) NSInteger directOverride;
@property (readwrite, assign) NSInteger owner;
@property (readwrite, assign) NSInteger delay;

+ (ActionType) typeForString:(NSString *)type;
+ (NSString *) stringForType:(ActionType) type;
@end
