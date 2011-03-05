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
#import "Action.h"

@implementation Condition
@synthesize type, location, counter, intValue, ddata;
@synthesize subject, direct, actions, flags;

- (id) init {
    self = [super init];
    type = NoCondition;
    location = [[XSPoint alloc] init];
    counter = [[Counter alloc] init];
    intValue = 0;
    ddata = [[NSMutableDictionary alloc] init];
    subject = -1;
    direct = -1;
    actions = [[NSMutableArray alloc] init];
    flags = [[ConditionFlags alloc] init];
    return self;
}

- (void) dealloc {
    [location release];
    [counter release];
    [ddata release];
    [actions release];
    [flags release];
    [super dealloc];
}

//MARK: Lua Coding

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
    [actions release];
    actions = [coder decodeArrayOfClass:[Action class] forKey:@"actions" zeroIndexed:YES];
    [actions retain];

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
    [coder encodeArray:actions forKey:@"actions" zeroIndexed:YES];

    [coder encodeObject:flags forKey:@"flags"];
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

//Res Coding

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        type = [coder decodeUInt8];
        [coder skip:1u];
        switch (type) {
            case LocationCondition:
                location.x = [coder decodeSInt32];
                location.y = [coder decodeSInt32];
                [coder skip:4u];
                break;
            case CounterCondition:
            case CounterGreaterCondition:
            case CounterNotCondition:
                [counter initWithResArchiver:coder];
                break;
            case ProximityCondition:
                intValue = sqrt([coder decodeUInt32]);
                [coder skip:8u];
                break;
            case DistanceGreaterCondition:
                intValue = [coder decodeUInt32];
                [coder skip:8u];
                break;
            case OwnerCondition:
            case DestructionCondition:
            case AgeCondition:
            case TimeCondition:
            case VelocityLessThanOrEqualCondition:
            case NoShipsLeftCondition:
            case ZoomLevelCondition:
                intValue = [coder decodeSInt32];
                [coder skip:8u];
                break;
            case CurrentMessageCondition:
                [ddata setObject:[NSNumber numberWithInt:[coder decodeSInt32]] forKey:@"id"];
                [ddata setObject:[NSNumber numberWithInt:[coder decodeSInt32]] forKey:@"page"];
                [coder skip:4u];
                break;
            case CurrentComputerSelectionCondition:
                [ddata setObject:[NSNumber numberWithInt:[coder decodeSInt32]] forKey:@"screen"];
                [ddata setObject:[NSNumber numberWithInt:[coder decodeSInt32]] forKey:@"line"];
                [coder skip:4u];
                break;
            default:
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
                [coder skip:12u];
                break;
        }
        subject = [coder decodeSInt32];
        direct = [coder decodeSInt32];

        int actionsStart = [coder decodeSInt32];
        int actionsCount = [coder decodeSInt32];
        for (int k = 0; k < actionsCount; k++) {
            [actions addObject:[coder decodeObjectOfClass:[Action class] atIndex:actionsStart + k]];
        }
        [flags initWithResArchiver:coder];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeUInt8:type];
    [coder skip:1u];
    switch (type) {
        case LocationCondition:
            [coder encodeSInt32:location.x];
            [coder encodeSInt32:location.y];
            [coder skip:4u];
            break;
        case CounterCondition:
        case CounterGreaterCondition:
        case CounterNotCondition:
            [counter encodeResWithCoder:coder];
            break;
        case ProximityCondition:
            [coder encodeUInt32:(UInt32)(intValue*intValue)];
            [coder skip:8u];
            break;
        case DistanceGreaterCondition:
            [coder encodeUInt32:intValue];
            [coder skip:8u];
            break;
        case OwnerCondition:
        case DestructionCondition:
        case AgeCondition:
        case TimeCondition:
        case VelocityLessThanOrEqualCondition:
        case NoShipsLeftCondition:
        case ZoomLevelCondition:
            [coder encodeSInt32:intValue];
            [coder skip:8u];
            break;
        case CurrentMessageCondition:
            [coder encodeSInt32:[[ddata objectForKey:@"id"] integerValue]];
            [coder encodeSInt32:[[ddata objectForKey:@"page"] integerValue]];
            [coder skip:4u];
            break;
        case CurrentComputerSelectionCondition:
            [coder encodeSInt32:[[ddata objectForKey:@"screen"] integerValue]];
            [coder encodeSInt32:[[ddata objectForKey:@"line"] integerValue]];
            [coder skip:4u];
            break;
        default:
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
            [coder skip:12u];
            break;
    }  
    [coder encodeSInt32:subject];
    [coder encodeSInt32:direct];
    NSEnumerator *enumerator = [actions objectEnumerator];
    int actionsStart = -1;
    if ([actions count] > 0) {
        actionsStart = [coder encodeObject:[enumerator nextObject]];
    }
    [coder encodeSInt32:actionsStart];
    for (Action *action in enumerator) {
        [coder encodeObject:action];
    }
    [coder encodeSInt32:[actions count]];
    [flags encodeResWithCoder:coder];
}

+ (ResType)resType {
    return 'sncd';
}

+ (NSString *)typeKey {
    return @"sncd";
}

+ (size_t)sizeOfResourceItem {
    return 38;
}

+ (BOOL)isPacked {
    return YES;
}

@end

@implementation Counter
@synthesize player, counterId, amount;

- (id) init {
    self = [super init];
    if (self) {
        player = 0;
        counterId = 0;
        amount = 0;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        player = [coder decodeIntegerForKey:@"player"];
        counterId = [coder decodeIntegerForKey:@"id"];
        amount = [coder decodeIntegerForKey:@"amount"];
    }
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

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        player = [coder decodeSInt32];
        counterId = [coder decodeSInt32];
        amount = [coder decodeSInt32];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt32:player];
    [coder encodeSInt32:counterId];
    [coder encodeSInt32:amount];
}
@end

static NSArray *conditionFlagKeys;
@implementation ConditionFlags
@synthesize trueOnlyOnce, initiallyTrue, hasBeenTrue;

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