//
//  Condition.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"
#import "ResCoding.h"
#import "FlagBlob.h"

typedef enum {
    NoCondition,
    LocationCondition,
    CounterCondition,
    ProximityCondition,
    OwnerCondition,
    DestructionCondition,
    AgeCondition,
    TimeCondition,
    RandomCondition,
    HalfHealthCondition,
    IsAuxiliaryCondition,
    IsTargetCondition,
    CounterGreaterCondition,
    CounterNotCondition,
    DistanceGreaterCondition,
    VelocityLessThanOrEqualCondition,
    NoShipsLeftCondition,
    CurrentMessageCondition,
    CurrentComputerSelectionCondition,
    ZoomLevelCondition,
    AutopilotCondition,
    NotAutopilotCondition,
    ObjectBeingBuiltCondition,
    DirectIsSubjectTargetCondition,
    SubjectIsPlayerCondition
} ConditionType;

@class XSPoint;
@class Counter, ConditionFlags;

@interface Condition : NSObject <LuaCoding, ResCoding> {
    ConditionType type;
    XSPoint *location;
    Counter *counter;
    NSInteger intValue;
    NSMutableDictionary *ddata;
    NSInteger subject, direct;
    NSMutableArray *actions;
    ConditionFlags *flags;
}
@property (readwrite, assign) ConditionType type;
@property (readwrite, retain) XSPoint *location;
@property (readwrite, retain) Counter *counter;
@property (readwrite, assign) NSInteger intValue;
@property (readwrite, retain) NSMutableDictionary *ddata;
@property (readwrite, assign) NSInteger subject;
@property (readwrite, assign) NSInteger direct;
@property (readwrite, retain) NSMutableArray *actions;
@property (readwrite, retain) ConditionFlags *flags;

+ (ConditionType) typeForString:(NSString *)typeName;
+ (NSString *) stringForType:(ConditionType)type;
@end


@interface Counter : NSObject <LuaCoding, ResCoding> {
    NSInteger player, counterId, amount;
}
@property (readwrite, assign) NSInteger player;
@property (readwrite, assign) NSInteger counterId;
@property (readwrite, assign) NSInteger amount;
@end

@interface ConditionFlags : FlagBlob {
    BOOL trueOnlyOnce;
    BOOL initiallyTrue;
    BOOL hasBeenTrue;
}
@property (readwrite, assign) BOOL trueOnlyOnce;
@property (readwrite, assign) BOOL initiallyTrue;
@property (readwrite, assign) BOOL hasBeenTrue;
@end



