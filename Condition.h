//
//  Condition.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"
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

@interface Condition : NSObject <LuaCoding> {
    ConditionType type;
    XSPoint *location;
    Counter *counter;
    NSInteger intValue;
    NSMutableDictionary *ddata;
    NSInteger subject, direct;
    NSMutableArray *actions;
    ConditionFlags *flags;
}

+ (ConditionType) typeForString:(NSString *)typeName;
+ (NSString *) stringForType:(ConditionType)type;
@end


@interface Counter : NSObject <LuaCoding> {
    NSInteger player, counterId, amount;
}
@end

@interface ConditionFlags : FlagBlob {
    BOOL trueOnlyOnce;
    BOOL initiallyTrue;
    BOOL hasBeenTrue;
}
@end



