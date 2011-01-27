//
//  Condition.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "Condition.h"
#import "Archivers.h"
#import "XSPoint.h"
#import "XSInteger.h"

@implementation Condition
- (id) init {
    self = [super init];
    type = NoCondition;
    location = [[XSPoint alloc] init];
    counter = [[Counter alloc] init];
    intValue = 0;
    ddata = [[NSMutableDictionary alloc] init];
    subject = -1;
    direct = -1;
    start = 0;
    count = 0;
    flags = [[ConditionFlags alloc] init];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    type = [Condition typeForString:[coder decodeStringForKey:@"type"]];

    switch (type) {
        case NoCondition:
        case RandomCondition:
        case HalfHealthCondition:
        case IsAuxiliaryCondition:
        case IsTargetCondition:
        case AutopilotCondition:
        case NotAutopilotCondition:
        case ObjectBeingBuiltCondition:
        case DirectIsSubjectTargetCondition:
        case SubjectIsPlayerCondition:
            break;
        case LocationCondition:
            [location release];
            location = [coder decodeObjectOfClass:[XSPoint class] forKey:@"location"];
            [location retain];
            break;
        case CounterCondition:
        case CounterGreaterCondition:
        case CounterNotCondition:
            [counter release];
            counter = [coder decodeObjectOfClass:[Counter class] forKey:@"counter"];
            [counter retain];
            break;
        case ProximityCondition:
            intValue = [coder decodeIntegerForKey:@"location"];
            break;
        case OwnerCondition:
        case DestructionCondition:
        case AgeCondition:
        case TimeCondition:
        case DistanceGreaterCondition:
        case VelocityLessThanOrEqualCondition:
        case ZoomLevelCondition:
            intValue = [coder decodeIntegerForKey:@"value"];
            break;
        case NoShipsLeftCondition:
            intValue = [coder decodeIntegerForKey:@"player"];
            break;
        case CurrentMessageCondition:
            [ddata setObject:[coder decodeObjectOfClass:[XSInteger class]
                                                 forKey:@"id"]
                      forKey:@"id"];
            [ddata setObject:[coder decodeObjectOfClass:[XSInteger class]
                                                 forKey:@"page"]
                      forKey:@"page"];
            break;
        case CurrentComputerSelectionCondition:
            [ddata setObject:[coder decodeObjectOfClass:[XSInteger class]
                                                 forKey:@"screen"]
                      forKey:@"screen"];
            [ddata setObject:[coder decodeObjectOfClass:[XSInteger class]
                                                 forKey:@"line"]
                      forKey:@"line"];
            break;
        default:
            @throw [NSString stringWithFormat:@"Unknown condition type: %d", type];
            break;
    }

    subject = [coder decodeIntegerForKey:@"subject"];
    direct = [coder decodeIntegerForKey:@"direct"];
    start = [coder decodeIntegerForKey:@"start"];
    count = [coder decodeIntegerForKey:@"count"];
    
    [flags release];
    flags = [coder decodeObjectOfClass:[ConditionFlags class]
                                forKey:@"flags"];
    [flags retain];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:[Condition stringForType:type] forKey:@"type"];

    switch (type) {
        case NoCondition:
        case RandomCondition:
        case HalfHealthCondition:
        case IsAuxiliaryCondition:
        case IsTargetCondition:
        case AutopilotCondition:
        case NotAutopilotCondition:
        case ObjectBeingBuiltCondition:
        case DirectIsSubjectTargetCondition:
        case SubjectIsPlayerCondition:
            break;
        case LocationCondition:
            [coder encodeObject:location forKey:@"location"];
            break;
        case CounterCondition:
        case CounterGreaterCondition:
        case CounterNotCondition:
            [coder encodeObject:counter forKey:@"counter"];
            break;
        case ProximityCondition:
            [coder encodeInteger:intValue forKey:@"distance"];
            break;
        case OwnerCondition:
        case DestructionCondition:
        case AgeCondition:
        case TimeCondition:
        case DistanceGreaterCondition:
        case VelocityLessThanOrEqualCondition:
        case ZoomLevelCondition:
            [coder encodeInteger:intValue forKey:@"value"];
            break;
        case NoShipsLeftCondition:
            [coder encodeInteger:intValue forKey:@"player"];
            break;
        case CurrentMessageCondition:
            [coder encodeObject:[ddata objectForKey:@"id"] forKey:@"id"];
            [coder encodeObject:[ddata objectForKey:@"page"] forKey:@"page"];
            break;
        case CurrentComputerSelectionCondition:
            [coder encodeObject:[ddata objectForKey:@"screen"] forKey:@"screen"];
            [coder encodeObject:[ddata objectForKey:@"line"] forKey:@"line"];
            break;
        default:
            @throw [NSString stringWithFormat:@"Unknown condition type: %d", type];
            break;
    }

    [coder encodeInteger:subject forKey:@"subject"];
    [coder encodeInteger:direct forKey:@"direct"];
    [coder encodeInteger:start forKey:@"start"];
    [coder encodeInteger:count forKey:@"count"];

    [coder encodeObject:flags forKey:@"flags"];
}

- (void) dealloc {
    [location release];
    [counter release];
    [ddata release];
    [flags release];
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

+ (ConditionType) typeForString:(NSString *)typeName {
    if ([typeName isEqual:@"none"]) {
        return NoCondition;
    } else if ([typeName isEqual:@"location"]) {
        return LocationCondition;
    } else if ([typeName isEqual:@"counter"]) {
        return CounterCondition;
    } else if ([typeName isEqual:@"proximity"]) {
        return ProximityCondition;
    } else if ([typeName isEqual:@"owner"]) {
        return OwnerCondition;
    } else if ([typeName isEqual:@"destruction"]) {
        return DestructionCondition;
    } else if ([typeName isEqual:@"age"]) {
        return AgeCondition;
    } else if ([typeName isEqual:@"time"]) {
        return TimeCondition;
    } else if ([typeName isEqual:@"random"]) {
        return RandomCondition;
    } else if ([typeName isEqual:@"half health"]) {
        return HalfHealthCondition;
    } else if ([typeName isEqual:@"is auxiliary"]) {
        return IsAuxiliaryCondition;
    } else if ([typeName isEqual:@"is target"]) {
        return IsTargetCondition;
    } else if ([typeName isEqual:@"counter greater"]) {
        return CounterGreaterCondition;
    } else if ([typeName isEqual:@"counter not"]) {
        return CounterNotCondition;
    } else if ([typeName isEqual:@"distance greater"]) {
        return DistanceGreaterCondition;
    } else if ([typeName isEqual:@"velocity less than or equal"]) {
        return VelocityLessThanOrEqualCondition;
    } else if ([typeName isEqual:@"no ships left"]) {
        return NoShipsLeftCondition;
    } else if ([typeName isEqual:@"current message"]) {
        return CurrentMessageCondition;
    } else if ([typeName isEqual:@"current computer selection"]) {
        return CurrentComputerSelectionCondition;
    } else if ([typeName isEqual:@"zoom level"]) {
        return ZoomLevelCondition;
    } else if ([typeName isEqual:@"autopilot"]) {
        return AutopilotCondition;
    } else if ([typeName isEqual:@"not autopilot"]) {
        return NotAutopilotCondition;
    } else if ([typeName isEqual:@"object being built"]) {
        return ObjectBeingBuiltCondition;
    } else if ([typeName isEqual:@"direct is subject target"]) {
        return DirectIsSubjectTargetCondition;
    } else if ([typeName isEqual:@"subject is player"]) {
        return SubjectIsPlayerCondition;
    } else {
        @throw [NSString stringWithFormat:@"Unknown condition type string: \"%@\"", typeName];
    }
}

+ (NSString *) stringForType:(ConditionType)type {
    switch (type) {
        case NoCondition:
            return @"none";
            break;
        case LocationCondition:
            return @"location";
            break;
        case CounterCondition:
            return @"counter";
            break;
        case ProximityCondition:
            return @"proximity";
            break;
        case OwnerCondition:
            return @"owner";
            break;
        case DestructionCondition:
            return @"destruction";
            break;
        case AgeCondition:
            return @"age";
            break;
        case TimeCondition:
            return @"time";
            break;
        case RandomCondition:
            return @"random";
            break;
        case HalfHealthCondition:
            return @"half health";
            break;
        case IsAuxiliaryCondition:
            return @"is auxiliary";
            break;
        case IsTargetCondition:
            return @"is target";
            break;
        case CounterGreaterCondition:
            return @"counter greater";
            break;
        case CounterNotCondition:
            return @"counter not";
            break;
        case DistanceGreaterCondition:
            return @"distance greater";
            break;
        case VelocityLessThanOrEqualCondition:
            return @"velocity less than or equal";
            break;
        case NoShipsLeftCondition:
            return @"no ships left";
            break;
        case CurrentMessageCondition:
            return @"current message";
            break;
        case CurrentComputerSelectionCondition:
            return @"current computer selection";
            break;
        case ZoomLevelCondition:
            return @"zoom level";
            break;
        case AutopilotCondition:
            return @"autopilot";
            break;
        case NotAutopilotCondition:
            return @"not autopilot";
            break;
        case ObjectBeingBuiltCondition:
            return @"object being built";
            break;
        case DirectIsSubjectTargetCondition:
            return @"direct is subject target";
            break;
        case SubjectIsPlayerCondition:
            return @"subject is player";
            break;
        default:
            @throw [NSString stringWithFormat:@"Unknown condition type: %d", type];
            break;
    }
}
@end

@implementation Counter
- (id) init {
    self = [super init];
    player = 0;
    counterId = 0;
    amount = 0;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    player = [coder decodeIntegerForKey:@"player"];
    counterId = [coder decodeIntegerForKey:@"id"];
    amount = [coder decodeIntegerForKey:@"amount"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:player forKey:@"player"];
    [coder encodeInteger:counterId forKey:@"id"];
    [coder encodeInteger:amount forKey:@"amount"];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end

static NSArray *conditionFlagKeys;
@implementation ConditionFlags
+ (NSArray *) keys {
    if (conditionFlagKeys == nil) {
        conditionFlagKeys = [[NSArray alloc] initWithObjects:@"trueOnlyOnce", @"initiallyTrue", @"hasBeenTrue", nil];
    }
    return conditionFlagKeys;
}

@end


/* Saved just in case.
 switch (type) {
 case NoCondition:
 break;
 case LocationCondition:
 break;
 case CounterCondition:
 break;
 case ProximityCondition:
 break;
 case OwnerCondition:
 break;
 case DestructionCondition:
 break;
 case AgeCondition:
 break;
 case TimeCondition:
 break;
 case RandomCondition:
 break;
 case HalfHealthCondition:
 break;
 case IsAuxiliaryCondition:
 break;
 case IsTargetCondition:
 break;
 case CounterGreaterCondition:
 break;
 case CounterNotCondition:
 break;
 case DistanceGreaterCondition:
 break;
 case VelocityLestThanOrEqualCondition:
 break;
 case NoShipsLeftCondition:
 break;
 case CurrentMessageCondition:
 break;
 case CurrentComputerSelectionCondition:
 break;
 case ZoomLevelCondition:
 break;
 case AutopilotCondition:
 break;
 case NotAutopilotCondition:
 break;
 case ObjectBeingBuiltCondition:
 break;
 case DirectIsSubjectTargetCondition:
 break;
 case SubjectIsPlayerCondition:
 break;
 default:
 @throw [NSString stringWithFormat:@"Unknown condition type: %d", type];
 break;
 }
*/