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
    NoConditionType,
    LocationConditionType,
    CounterConditionType,
    ProximityConditionType,
    OwnerConditionType,
    DestructionConditionType,
    AgeConditionType,
    TimeConditionType,
    RandomConditionType,
    HalfHealthConditionType,
    IsAuxiliaryConditionType,
    IsTargetConditionType,
    CounterGreaterConditionType,
    CounterNotConditionType,
    DistanceGreaterConditionType,
    VelocityLessThanOrEqualConditionType,
    NoShipsLeftConditionType,
    CurrentMessageConditionType,
    CurrentComputerSelectionConditionType,
    ZoomLevelConditionType,
    AutopilotConditionType,
    NotAutopilotConditionType,
    ObjectBeingBuiltConditionType,
    DirectIsSubjectTargetConditionType,
    SubjectIsPlayerConditionType,
} ConditionType;

@class XSIPoint;
@class ConditionFlags;

@interface Condition : NSObject <LuaCoding, ResCoding, ResClassOverriding> {
@public
    int subject, direct;
    NSMutableArray *actions;
    ConditionFlags *flags;
}
@property (readwrite, assign) int subject;
@property (readwrite, assign) int direct;
@property (readwrite, retain) NSMutableArray *actions;
@property (readwrite, retain) ConditionFlags *flags;

+ (ConditionType) typeForString:(NSString *)typeName;
+ (NSString *) stringForType:(ConditionType)type;
+ (ConditionType) typeForClass:(Class)class;
+ (Class<LuaCoding, ResCoding>) classForType:(ConditionType)type;

- (NSString *)nibName;
@end

#pragma mark Intermediates
//Intermediate classes to save code
@interface NoParameterCondition : Condition {} @end

@interface SignedIntCondition : Condition {
@public
    signed int value;
}
@property (readwrite, assign) signed int value;
@end

@interface UnsignedIntCondition : Condition {
@public
    unsigned int value;
}
@property (readwrite, assign) unsigned int value;
@end

#pragma mark SubClasses
//The actual classes
@interface NoCondition : NoParameterCondition {} @end

@interface LocationCondition : Condition {
    XSIPoint *location;
}
@property (readwrite, retain) XSIPoint *location;
@end

@interface CounterCondition : Condition {
@public
    int player;
    int counterId;
    int amount;
}
@property (readwrite, assign) int player;
@property (readwrite, assign) int counterId;
@property (readwrite, assign) int amount;
@end

@interface ProximityCondition : Condition {
    unsigned int distance;
}
@property (readwrite, assign) unsigned int distance;
@end

@interface OwnerCondition : SignedIntCondition {} @end

@interface DestructionCondition : SignedIntCondition {} @end

@interface AgeCondition : SignedIntCondition {} @end

@interface TimeCondition : SignedIntCondition {} @end

@interface RandomCondition : NoParameterCondition {} @end

@interface HalfHealthCondition : NoParameterCondition {} @end

@interface IsAuxiliaryCondition : NoParameterCondition {} @end

@interface IsTargetCondition : NoParameterCondition {} @end

@interface CounterGreaterCondition : CounterCondition {} @end

@interface CounterNotCondition : CounterCondition {} @end

@interface DistanceGreaterCondition : UnsignedIntCondition {} @end

@interface VelocityLessThanOrEqualCondition : SignedIntCondition {} @end

@interface NoShipsLeftCondition : Condition {
    int player;
}
@property (readwrite, assign) int player;
@end

@interface CurrentMessageCondition : Condition {
    int ID;
    int page;
}
@property (readwrite, assign) int ID;
@property (readwrite, assign) int page;
@end

@interface CurrentComputerSelectionCondition : Condition {
    int screen;
    int line;
}
@property (readwrite, assign) int screen;
@property (readwrite, assign) int line;
@end

@interface ZoomLevelCondition : SignedIntCondition {} @end

@interface AutopilotCondition : NoParameterCondition {} @end

@interface NotAutopilotCondition : NoParameterCondition {} @end

@interface ObjectBeingBuiltCondition : NoParameterCondition {} @end

@interface DirectIsSubjectTargetCondition : NoParameterCondition {} @end

@interface SubjectIsPlayerCondition : NoParameterCondition {} @end


#pragma mark Flags
@interface ConditionFlags : FlagBlob {
    BOOL trueOnlyOnce;
    BOOL initiallyTrue;
    BOOL hasBeenTrue;
}
@property (readwrite, assign) BOOL trueOnlyOnce;
@property (readwrite, assign) BOOL initiallyTrue;
@property (readwrite, assign) BOOL hasBeenTrue;
@end

