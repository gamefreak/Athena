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
#import "SubActions.h"

@implementation Condition
@synthesize subject, direct;
@synthesize actions, flags;
@dynamic subjectIsPlayer;

- (id) init {
    self = [super init];
    if (self) {
        subject = NoObjectFlag;
        direct = NoObjectFlag;
        actions = [[NSMutableArray alloc] init];
        flags = [[ConditionFlags alloc] init];
        
    }
    return self;
}

- (void) dealloc {
    [actions release];
    [flags release];
    [super dealloc];
}

//MARK: Lua Coding

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        subject = [coder decodeIntegerForKey:@"subject"];
        direct = [coder decodeIntegerForKey:@"direct"];
        [self setActions:[coder decodeArrayOfClass:[Action class] forKey:@"actions" zeroIndexed:YES]];
        [self setFlags:[coder decodeObjectOfClass:[ConditionFlags class] forKey:@"flags"]];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:[Condition stringForType:[Condition typeForClass:[self class]]] forKey:@"type"];
    [coder encodeInteger:subject forKey:@"subject"];
    [coder encodeInteger:direct forKey:@"direct"];
    [coder encodeArray:actions forKey:@"actions" zeroIndexed:YES];
    [coder encodeObject:flags forKey:@"flags"];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return [Condition classForType:[Condition typeForString:[coder decodeStringForKey:@"type"]]];
}

//Res Coding

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        [coder seek:14u];
        subject = [coder decodeSInt32];
        direct = [coder decodeSInt32];
        int actionsStart = [coder decodeSInt32];
        int actionsLength = [coder decodeSInt32];
        [actions removeAllObjects];
        for (int k = 0; k < actionsLength; k++) {
            [actions addObject:[coder decodeObjectOfClass:[Action class] atIndex:actionsStart + k]];
        }
        [flags initWithResArchiver:coder];
        [coder skip:4u];//unused value 'direction'
        [coder seek:2u];//seek back for subclasses
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeUInt8:[Condition typeForClass:[self class]]];
    [coder skip:1u];
    [coder seek:14u];
    [coder encodeSInt32:subject];
    [coder encodeSInt32:direct];
    int actionsStart = -1;
    NSEnumerator *enumerator = [actions objectEnumerator];
    if ([actions count] > 0) {
        actionsStart = [coder encodeObject:[enumerator nextObject]];
    }

    for (id action in enumerator) {
        [coder encodeObject:action];
    }

    [coder encodeSInt32:actionsStart];
    [coder encodeSInt32:[actions count]];
    [flags encodeResWithCoder:coder];
    [coder skip:4u];//unused
    [coder seek:2u];//loop back for subclasses
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

+ (Class<ResCoding>)classForResCoder:(ResUnarchiver *)coder {
    Class<ResCoding> class = [Condition classForType:[coder decodeUInt8]];
    [coder skip:1u];
    return class;
}

+ (ConditionType) typeForString:(NSString *)typeName {
    if ([typeName isEqual:@"none"]) {
        return NoConditionType;
    } else if ([typeName isEqual:@"location"]) {
        return LocationConditionType;
    } else if ([typeName isEqual:@"counter"]) {
        return CounterConditionType;
    } else if ([typeName isEqual:@"proximity"]) {
        return ProximityConditionType;
    } else if ([typeName isEqual:@"owner"]) {
        return OwnerConditionType;
    } else if ([typeName isEqual:@"destruction"]) {
        return DestructionConditionType;
    } else if ([typeName isEqual:@"age"]) {
        return AgeConditionType;
    } else if ([typeName isEqual:@"time"]) {
        return TimeConditionType;
    } else if ([typeName isEqual:@"random"]) {
        return RandomConditionType;
    } else if ([typeName isEqual:@"half health"]) {
        return HalfHealthConditionType;
    } else if ([typeName isEqual:@"is auxiliary"]) {
        return IsAuxiliaryConditionType;
    } else if ([typeName isEqual:@"is target"]) {
        return IsTargetConditionType;
    } else if ([typeName isEqual:@"counter greater"]) {
        return CounterGreaterConditionType;
    } else if ([typeName isEqual:@"counter not"]) {
        return CounterNotConditionType;
    } else if ([typeName isEqual:@"distance greater"]) {
        return DistanceGreaterConditionType;
    } else if ([typeName isEqual:@"velocity less than or equal"]) {
        return VelocityLessThanOrEqualConditionType;
    } else if ([typeName isEqual:@"no ships left"]) {
        return NoShipsLeftConditionType;
    } else if ([typeName isEqual:@"current message"]) {
        return CurrentMessageConditionType;
    } else if ([typeName isEqual:@"current computer selection"]) {
        return CurrentComputerSelectionConditionType;
    } else if ([typeName isEqual:@"zoom level"]) {
        return ZoomLevelConditionType;
    } else if ([typeName isEqual:@"autopilot"]) {
        return AutopilotConditionType;
    } else if ([typeName isEqual:@"not autopilot"]) {
        return NotAutopilotConditionType;
    } else if ([typeName isEqual:@"object being built"]) {
        return ObjectBeingBuiltConditionType;
    } else if ([typeName isEqual:@"direct is subject target"]) {
        return DirectIsSubjectTargetConditionType;
    } else if ([typeName isEqual:@"subject is player"]) {
        return SubjectIsPlayerConditionType;
    } else {
        @throw [NSString stringWithFormat:@"Unknown condition type string: \"%@\"", typeName];
    }
}

+ (NSString *) stringForType:(ConditionType)type {
    switch (type) {
        case NoConditionType:
            return @"none";
            break;
        case LocationConditionType:
            return @"location";
            break;
        case CounterConditionType:
            return @"counter";
            break;
        case ProximityConditionType:
            return @"proximity";
            break;
        case OwnerConditionType:
            return @"owner";
            break;
        case DestructionConditionType:
            return @"destruction";
            break;
        case AgeConditionType:
            return @"age";
            break;
        case TimeConditionType:
            return @"time";
            break;
        case RandomConditionType:
            return @"random";
            break;
        case HalfHealthConditionType:
            return @"half health";
            break;
        case IsAuxiliaryConditionType:
            return @"is auxiliary";
            break;
        case IsTargetConditionType:
            return @"is target";
            break;
        case CounterGreaterConditionType:
            return @"counter greater";
            break;
        case CounterNotConditionType:
            return @"counter not";
            break;
        case DistanceGreaterConditionType:
            return @"distance greater";
            break;
        case VelocityLessThanOrEqualConditionType:
            return @"velocity less than or equal";
            break;
        case NoShipsLeftConditionType:
            return @"no ships left";
            break;
        case CurrentMessageConditionType:
            return @"current message";
            break;
        case CurrentComputerSelectionConditionType:
            return @"current computer selection";
            break;
        case ZoomLevelConditionType:
            return @"zoom level";
            break;
        case AutopilotConditionType:
            return @"autopilot";
            break;
        case NotAutopilotConditionType:
            return @"not autopilot";
            break;
        case ObjectBeingBuiltConditionType:
            return @"object being built";
            break;
        case DirectIsSubjectTargetConditionType:
            return @"direct is subject target";
            break;
        case SubjectIsPlayerConditionType:
            return @"subject is player";
            break;
        default:
            @throw [NSString stringWithFormat:@"Unknown condition type: %d", type];
            break;
    }
}

+ (ConditionType) typeForClass:(Class)class {
    if ([NoCondition class] == class) {
        return NoConditionType;
    } else if ([LocationCondition class] == class) {
        return LocationConditionType;
    } else if ([CounterCondition class] == class) {
        return CounterConditionType;
    } else if ([ProximityCondition class] == class) {
        return ProximityConditionType;
    } else if ([OwnerCondition class] == class) {
        return OwnerConditionType;
    } else if ([DestructionCondition class] == class) {
        return DestructionConditionType;
    } else if ([AgeCondition class] == class) {
        return AgeConditionType;
    } else if ([TimeCondition class] == class) {
        return TimeConditionType;
    } else if ([RandomCondition class] == class) {
        return RandomConditionType;
    } else if ([HalfHealthCondition class] == class) {
        return HalfHealthConditionType;
    } else if ([IsAuxiliaryCondition class] == class) {
        return IsAuxiliaryConditionType;
    } else if ([IsTargetCondition class] == class) {
        return IsTargetConditionType;
    } else if ([CounterGreaterCondition class] == class) {
        return CounterGreaterConditionType;
    } else if ([CounterNotCondition class] == class) {
        return CounterNotConditionType;
    } else if ([DistanceGreaterCondition class] == class) {
        return DistanceGreaterConditionType;
    } else if ([VelocityLessThanOrEqualCondition class] == class) {
        return VelocityLessThanOrEqualConditionType;
    } else if ([NoShipsLeftCondition class] == class) {
        return NoShipsLeftConditionType;
    } else if ([CurrentMessageCondition class] == class) {
        return CurrentMessageConditionType;
    } else if ([CurrentComputerSelectionCondition class] == class) {
        return CurrentComputerSelectionConditionType;
    } else if ([ZoomLevelCondition class] == class) {
        return ZoomLevelConditionType;
    } else if ([AutopilotCondition class] == class) {
        return AutopilotConditionType;
    } else if ([NotAutopilotCondition class] == class) {
        return NotAutopilotConditionType;
    } else if ([ObjectBeingBuiltCondition class] == class) {
        return ObjectBeingBuiltConditionType;
    } else if ([DirectIsSubjectTargetCondition class] == class) {
        return DirectIsSubjectTargetConditionType;
    } else if ([SubjectIsPlayerCondition class] == class) {
        return SubjectIsPlayerConditionType;
    } else {
        return NoConditionType;
    }
}

+ (Class<LuaCoding,ResCoding>)classForType:(ConditionType)type {
    switch (type) {
        case NoConditionType:
            return [NoCondition class];
            break;
        case LocationConditionType:
            return [LocationCondition class];
            break;
        case CounterConditionType:
            return [CounterCondition class];
            break;
        case ProximityConditionType:
            return [ProximityCondition class];
            break;
        case OwnerConditionType:
            return [OwnerCondition class];
            break;
        case DestructionConditionType:
            return [DestructionCondition class];
            break;
        case AgeConditionType:
            return [AgeCondition class];
            break;
        case TimeConditionType:
            return [TimeCondition class];
            break;
        case RandomConditionType:
            return [RandomCondition class];
            break;
        case HalfHealthConditionType:
            return [HalfHealthCondition class];
            break;
        case IsAuxiliaryConditionType:
            return [IsAuxiliaryCondition class];
            break;
        case IsTargetConditionType:
            return [IsTargetCondition class];
            break;
        case CounterGreaterConditionType:
            return [CounterGreaterCondition class];
            break;
        case CounterNotConditionType:
            return [CounterNotCondition class];
            break;
        case DistanceGreaterConditionType:
            return [DistanceGreaterCondition class];
            break;
        case VelocityLessThanOrEqualConditionType:
            return [VelocityLessThanOrEqualCondition class];
            break;
        case NoShipsLeftConditionType:
            return [NoShipsLeftCondition class];
            break;
        case CurrentMessageConditionType:
            return [CurrentMessageCondition class];
            break;
        case CurrentComputerSelectionConditionType:
            return [CurrentComputerSelectionCondition class];
            break;
        case ZoomLevelConditionType:
            return [ZoomLevelCondition class];
            break;
        case AutopilotConditionType:
            return [AutopilotCondition class];
            break;
        case NotAutopilotConditionType:
            return [NotAutopilotCondition class];
            break;
        case ObjectBeingBuiltConditionType:
            return [ObjectBeingBuiltCondition class];
            break;
        case DirectIsSubjectTargetConditionType:
            return [DirectIsSubjectTargetCondition class];
            break;
        case SubjectIsPlayerConditionType:
            return [SubjectIsPlayerCondition class];
            break;
        default:
            @throw [NSString stringWithFormat:@"Unknown condition type: %d", type];
            break;
    }
}

- (void)copyValuesTo:(Condition *)condition {
    [condition setSubject:subject];
    [condition setDirect:direct];
    [condition setActions:[[actions mutableCopy] autorelease]];
    [condition setFlags:flags];
}

- (NSString *)nibName {
    return @"NoParameter";
}

- (BOOL)subjectIsPlayer {
    return direct == SubjectIsPlayerSpecialFlag;
}

- (void)setSubjectIsPlayer:(BOOL)subjectIsPlayer {
    [self setDirect:(subjectIsPlayer?SubjectIsPlayerSpecialFlag:NoObjectFlag)];
}

+ (NSSet *)keyPathsForValuesAffectingSubjectIsPlayer {
    return [NSSet setWithObjects:@"direct", nil];
}

+ (NSSet *)keyPathsForValuesAffectingDirect {
    return [NSSet setWithObjects:@"subjectIsPlayer", nil];
}
@end

#pragma mark Intermediates
@implementation NoParameterCondition @end

@implementation SignedIntCondition
@synthesize value;

- (id)init {
    self = [super init];
    if (self) {
        value = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        value = [coder decodeIntegerForKey:@"value"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:value forKey:@"value"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        value = [coder decodeSInt32];
        [coder skip:8u];//unused
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:value];
    [coder skip:8u];//unused
}

- (NSString *)intLabel {
    return @"Signed Int";
}

- (NSString *)nibName {
    return @"SignedIntParameter";
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"value", nil];
}
@end

@implementation UnsignedIntCondition
@synthesize value;

- (id)init {
    self = [super init];
    if (self) {
        value = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        value = [coder decodeIntegerForKey:@"value"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:value forKey:@"value"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        value = [coder decodeUInt32];
        [coder skip:8u];//unused
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeUInt32:value];
    [coder skip:8u];//unused
}

- (NSString *)intLabel {
    return @"Unsigned Int";
}

- (NSString *)nibName {
    return @"UnsignedIntParameter";
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"value", nil];
}
@end

#pragma mark Subclasses
@implementation NoCondition @end

@implementation LocationCondition
@synthesize location;
- (id)init {
    self = [super init];
    if (self) {
        location = [[XSIPoint alloc] init];
    }
    return self;
}

- (void)dealloc {
    [location release];
    [super dealloc];
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        location = [[coder decodeObjectOfClass:[XSIPoint class] forKey:@"location"] retain];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeObject:location forKey:@"location"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        [location setX:[coder decodeSInt32]];
        [location setY:[coder decodeSInt32]];
        [coder skip:4u];//unused
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:[location x]];
    [coder encodeSInt32:[location y]];
    [coder skip:4u];//unused
}

- (NSString *)nibName {
    return @"LocationCondition";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Object is at location (%i, %i)", location.x, location.y];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"location", @"location.point", nil];
}
@end

@implementation CounterCondition
@synthesize player, counterId, amount;

- (id)init {
    self = [super init];
    if (self) {
        player = 0;
        counterId = 0;
        amount = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        player = [coder decodeIntegerForKeyPath:@"counter.player"];
        counterId = [coder decodeIntegerForKeyPath:@"counter.id"];
        amount = [coder decodeIntegerForKeyPath:@"counter.amount"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    //TO BE CHANGED (SOMEDAY)
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[XSInteger xsIntegerWithValue:player] forKey:@"player"];
    [dictionary setValue:[XSInteger xsIntegerWithValue:counterId] forKey:@"id"];
    [dictionary setValue:[XSInteger xsIntegerWithValue:amount] forKey:@"amount"];
    [coder encodeDictionary:dictionary forKey:@"counter" asArray:NO];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        player = [coder decodeSInt32];
        counterId = [coder decodeSInt32];
        amount = [coder decodeSInt32];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:player];
    [coder encodeSInt32:counterId];
    [coder encodeSInt32:amount];
}

- (NSString *)nibName {
    return @"CounterCondition";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Counter %i of player %i equals %i", counterId
            , player, amount];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"counterId", @"player", @"amount", nil];
}
@end

@implementation ProximityCondition
@synthesize distance;

- (id)init {
    self = [super init];
    if (self) {
        distance = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        distance = [coder decodeIntegerForKey:@"location"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:distance forKey:@"location"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        unsigned int location = [coder decodeUInt32];
        distance = (unsigned int)sqrt((double)location);
        [coder skip:8u];//unused
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeUInt32:distance * distance];//location
    [coder skip:8u];//unused
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Subject is within %u pixels of direct.", distance];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"distance", nil];
}

- (NSString *)nibName {
    return @"ProximityCondition";
}
@end

@implementation OwnerCondition
- (NSString *)intLabel {
    return @"Owner";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Object is owned by player %i", value];
}
@end

@implementation DestructionCondition

- (NSString *)intLabel {
    return @"Object";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Object %i does not exist", value];
}@end

@implementation AgeCondition
- (NSString *)intLabel {
    return @"Age";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Subject is older than %i time steps", value];
}
@end

@implementation TimeCondition
- (NSString *)intLabel {
    return @"Ticks";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%i ticks have elapsed.", value];
}
@end

@implementation RandomCondition
- (NSString *)description {
    return @"Occurs at random";
}
@end

@implementation HalfHealthCondition
- (NSString *)description {
    return @"Subject is below half health";
}
@end

@implementation IsAuxiliaryCondition
- (NSString *)description {
    return @"Subject is an auxiliary object";
}
@end

@implementation IsTargetCondition
- (NSString *)description {
    return @"Subject is current target";
}
@end

@implementation CounterGreaterCondition
- (NSString *)description {
    return [NSString stringWithFormat:@"Counter %i of player %i is greater than %i", counterId
            , player, amount];
}
@end

@implementation CounterNotCondition
- (NSString *)description {
    return [NSString stringWithFormat:@"Counter %i of player %i is not %i", counterId
            , player, amount];
}
@end

@implementation DistanceGreaterCondition
- (NSString *)intLabel {
    return @"Distance";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Subject is further than %u units from direct", value];
}
@end

@implementation VelocityLessThanOrEqualCondition
- (NSString *)intLabel {
    return @"Velocity";
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Subject has a velocity of %i or less", value];
}
@end

@implementation NoShipsLeftCondition
@synthesize player;

- (id)init {
    self = [super init];
    if (self) {
        player = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        player = [coder decodeIntegerForKey:@"player"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:player forKey:@"player"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        player = [coder decodeSInt32];
        [coder skip:8u];//unused
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:player];
    [coder skip:8u];//unused
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Player %i has no ships remaining", player];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"player", nil];
}

- (NSString *)nibName {
    return @"NoShipsLeftCondition";
}
@end

@implementation CurrentMessageCondition
@synthesize ID, page;

- (id)init {
    self = [super init];
    if (self) {
        ID = 0;
        page = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        ID = [coder decodeIntegerForKey:@"id"];
        page = [coder decodeIntegerForKey:@"page"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:ID forKey:@"id"];
    [coder encodeInteger:page forKey:@"page"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        ID = [coder decodeSInt32];
        page = [coder decodeSInt32];
        [coder skip:4u];//unused
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:ID];
    [coder encodeSInt32:page];
    [coder skip:4u];//unused
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Message %i page %i is being displayed", ID, page];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"ID", @"page", nil];
}

- (NSString *)nibName {
    return @"CurrentMessageCondition";
}
@end

@implementation CurrentComputerSelectionCondition
@synthesize screen, line;

- (id)init {
    self = [super init];
    if (self) {
        screen = 0;
        line = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        screen = [coder decodeIntegerForKey:@"screen"];
        line = [coder decodeIntegerForKey:@"line"];
        
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:screen forKey:@"screen"];
    [coder encodeInteger:line forKey:@"line"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        screen = [coder decodeSInt32];
        line = [coder decodeSInt32];
        [coder skip:4u];//unused
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt32:screen];
    [coder encodeSInt32:line];
    [coder skip:4u];//unused
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Line %i of screen %i is selected in the minicomputer", line, screen];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"line", @"screen", nil];
}

- (NSString *)nibName {
    return @"CurrentComputerSelectionCondition";
}
@end


@implementation ZoomLevelCondition
- (NSString *) zoomString {
    switch (value) {
        case ZoomLevelDoubleSize:
            return @"2:1";
            break;
        case ZoomLevelActualSize:
            return @"1:1";
            break;
        case ZoomLevelHalfSize:
            return @"1:2";
            break;
        case ZoomLevelQuarterSize:
            return @"1:4";
            break;
        case ZoomLevelSixteenthSize:
            return @"1:16";
            break;
        case ZoomLevelNearestFoe:
            return @"nearest hostile";
            break;
        case ZoomLevelNearestObject:
            return @"nearest object";
            break;
        case ZoomLevelAll:
            return @"all";
            break;
        default:
            return @"<invalid zoom level>";
            break;
    }
    NSAssert(0, @"Unreachable");
}

+ (NSSet *)keyPathsForValuesAffectingZoomString {
    return [NSSet setWithObjects:@"value", nil];
}

+ (NSSet *)keyPathsForValuesAffectingDescription {
    return [NSSet setWithObjects:@"zoomString", nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Zoom level is %@", [self zoomString]];
}

- (NSString *)nibName {
    return @"ZoomLevelCondition";
}
@end

@implementation AutopilotCondition
- (NSString *)description {
    return @"Player is on autopilot";
}
@end

@implementation NotAutopilotCondition
- (NSString *)description {
    return @"Player is not on autopilot";
}
@end

@implementation ObjectBeingBuiltCondition
- (NSString *)description {
    return @"Subject is building something";
}
@end

@implementation DirectIsSubjectTargetCondition
- (NSString *)description {
    return @"Direct object is targeted by subject";
}
@end

@implementation SubjectIsPlayerCondition
- (NSString *)description {
    return @"Subject is player";
}   
@end

//Flags
@implementation ConditionFlags
@synthesize trueOnlyOnce, initiallyTrue, hasBeenTrue;

+ (NSArray *) keys {
    return [NSArray arrayWithObjects:@"trueOnlyOnce", @"initiallyTrue", @"hasBeenTrue", nil];
}
@end
