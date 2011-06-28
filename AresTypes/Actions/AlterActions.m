//
//  AlterActions.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "AlterActions.h"
#import "Archivers.h"
#import "IndexedObject.h"
#import "XSPoint.h"

#import "BaseObject.h"

@implementation AlterAction
- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeString:[AlterAction stringForAlterType:[AlterAction alterTypeForClass:[self class]]] forKey:@"alterType"];

}



- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        [coder skip:1];//alterType
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeUInt8:[AlterAction alterTypeForClass:[self class]]];
}

+ (Class<ResCoding>) classForResCoder:(ResUnarchiver *)coder {
    [coder seek:24u];
    ActionAlterType type = [coder decodeUInt8];
    [coder seek:0u];
    return [AlterAction classForType:type];
}

+ (ActionAlterType) alterTypeForString:(NSString *)type {
    if ([type isEqual:@"health"]) {
        return AlterHealth;
    } else if ([type isEqual:@"velocity"]) {
        return AlterVelocity;
    } else if ([type isEqual:@"thrust"]) {
        return AlterThrust;
    } else if ([type isEqual:@"max thrust"]) {
        return AlterMaxThrust;
    } else if ([type isEqual:@"max velocity"]) {
        return AlterMaxVelocity;
    } else if ([type isEqual:@"max turn rate"]) {
        return AlterMaxTurnRate;
    } else if ([type isEqual:@"location"]) {
        return AlterLocation;
    } else if ([type isEqual:@"scale"]) {
        return AlterScale;
    } else if ([type isEqual:@"pulse weapon"]) {
        return AlterPulseWeapon;
    } else if ([type isEqual:@"beam weapon"]) {
        return AlterBeamWeapon;
    } else if ([type isEqual:@"special weapon"]) {
        return AlterSpecialWeapon;
    } else if ([type isEqual:@"energy"]) {
        return AlterEnergy;
    } else if ([type isEqual:@"owner"]) {
        return AlterOnwer;
    } else if ([type isEqual:@"hidden"]) {
        return AlterHidden;
    } else if ([type isEqual:@"cloak"]) {
        return AlterCloak;
    } else if ([type isEqual:@"offline"]) {
        return AlterOffline;
    } else if ([type isEqual:@"current turn rate"]) {
        return AlterCurrentTurnRate;
    } else if ([type isEqual:@"base type"]) {
        return AlterBaseType;
    } else if ([type isEqual:@"active condition"]) {
        return AlterActiveCondition;
    } else if ([type isEqual:@"occupation"]) {
        return AlterOccupation;
    } else if ([type isEqual:@"absolute cash"]) {
        return AlterAbsoluteCash;
    } else if ([type isEqual:@"age"]) {
        return AlterAge;
    } else if ([type isEqual:@"absolute location"]) {
        return AlterAbsoluteLocation;
    } else {
        @throw [NSString stringWithFormat:@"Invalid alter action type: %@", type];
    }
    return -1;
    
}

+ (NSString *) stringForAlterType:(ActionAlterType)type {
    switch (type) {
        case AlterHealth:
            return @"health";
            break;
        case AlterVelocity:
            return @"velocity";
            break;
        case AlterThrust:
            return @"thrust";
            break;
        case AlterMaxThrust:
            return @"max thrust";
            break;
        case AlterMaxVelocity:
            return @"max velocity";
            break;
        case AlterMaxTurnRate:
            return @"max turn rate";
            break;
        case AlterLocation:
            return @"location";
            break;
        case AlterScale:
            return @"scale";
            break;
        case AlterPulseWeapon:
            return @"pulse weapon";
            break;
        case AlterBeamWeapon:
            return @"beam weapon";
            break;
        case AlterSpecialWeapon:
            return @"special weapon";
            break;
        case AlterEnergy:
            return @"energy";
            break;
        case AlterOnwer:
            return @"owner";
            break;
        case AlterHidden:
            return @"hidden";
            break;
        case AlterCloak:
            return @"cloak";
            break;
        case AlterOffline:
            return @"offline";
            break;
        case AlterCurrentTurnRate:
            return @"current turn rate";
            break;
        case AlterBaseType:
            return @"base type";
            break;
        case AlterActiveCondition:
            return @"active condition";
            break;
        case AlterOccupation:
            return @"occupation";
            break;
        case AlterAbsoluteCash:
            return @"absolute cash";
            break;
        case AlterAge:
            return @"age";
            break;
        case AlterAbsoluteLocation:
            return @"absolute location";
            break;
        default:
            @throw [NSString stringWithFormat:@"Invalid alter action type: %d", type];
            break;
    }
    return nil;
}


+ (ActionAlterType) alterTypeForClass:(Class)class {
    if (class == [AlterHealthAction class]) {
        return AlterHealth;
    } else if (class == [AlterVelocityAction class]) {
        return AlterVelocity;
    } else if (class == [AlterThrustAction class]) {
        return AlterThrust;
    } else if (class == [AlterMaxThrustAction class]) {
        return AlterMaxThrust;
    } else if (class == [AlterMaxVelocityAction class]) {
        return AlterMaxVelocity;
    } else if (class == [AlterMaxTurnRateAction class]) {
        return AlterMaxTurnRate;
    } else if (class == [AlterLocationAction class]) {
        return AlterLocation;
    } else if (class == [AlterScaleAction class]) {
        return AlterScale;
    } else if (class == [AlterPulseWeaponAction class]) {
        return AlterPulseWeapon;
    } else if (class == [AlterBeamWeaponAction class]) {
        return AlterBeamWeapon;
    } else if (class == [AlterSpecialWeaponAction class]) {
        return AlterSpecialWeapon;
    } else if (class == [AlterEnergyAction class]) {
        return AlterEnergy;
    } else if (class == [AlterOnwerAction class]) {
        return AlterOnwer;
    } else if (class == [AlterHiddenAction class]) {
        return AlterHidden;
    } else if (class == [AlterCloakAction class]) {
        return AlterCloak;
    } else if (class == [AlterOfflineAction class]) {
        return AlterOffline;
    } else if (class == [AlterCurrentTurnRateAction class]) {
        return AlterCurrentTurnRate;
    } else if (class == [AlterBaseTypeAction class]) {
        return AlterBaseType;
    } else if (class == [AlterActiveConditionAction class]) {
        return AlterActiveCondition;
    } else if (class == [AlterOccupationAction class]) {
        return AlterOccupation;
    } else if (class == [AlterAbsoluteCashAction class]) {
        return AlterAbsoluteCash;
    } else if (class == [AlterAgeAction class]) {
        return AlterAge;
    } else if (class == [AlterAbsoluteLocationAction class]) {
        return AlterAbsoluteLocation;
    }
}

+ (Class) classForType:(ActionAlterType)type {
    switch (type) {
        case AlterHealth:
            return [AlterHealthAction class];
            break;
        case AlterVelocity:
            return [AlterVelocityAction class];
            break;
        case AlterThrust:
            return [AlterThrustAction class];
            break;
        case AlterMaxThrust:
            return [AlterMaxThrustAction class];
            break;
        case AlterMaxVelocity:
            return [AlterMaxVelocityAction class];
            break;
        case AlterMaxTurnRate:
            return [AlterMaxTurnRateAction class];
            break;
        case AlterLocation:
            return [AlterLocationAction class];
            break;
        case AlterScale:
            return [AlterScaleAction class];
            break;
        case AlterPulseWeapon:
            return [AlterPulseWeaponAction class];
            break;
        case AlterBeamWeapon:
            return [AlterBeamWeaponAction class];
            break;
        case AlterSpecialWeapon:
            return [AlterSpecialWeaponAction class];
            break;
        case AlterEnergy:
            return [AlterEnergyAction class];
            break;
        case AlterOnwer:
            return [AlterOnwerAction class];
            break;
        case AlterHidden:
            return [AlterHiddenAction class];
            break;
        case AlterCloak:
            return [AlterCloakAction class];
            break;
        case AlterOffline:
            return [AlterOfflineAction class];
            break;
        case AlterCurrentTurnRate:
            return [AlterCurrentTurnRateAction class];
            break;
        case AlterBaseType:
            return [AlterBaseTypeAction class];
            break;
        case AlterActiveCondition:
            return [AlterActiveConditionAction class];
            break;
        case AlterOccupation:
            return [AlterOccupationAction class];
            break;
        case AlterAbsoluteCash:
            return [AlterAbsoluteCashAction class];
            break;
        case AlterAge:
            return [AlterAgeAction class];
            break;
        case AlterAbsoluteLocation:
            return [AlterAbsoluteLocationAction class];
            break;
        default:
            @throw [NSString stringWithFormat:@"Invalid alter action type: %@", type];

            break;
    }
}
@end

@implementation AlterActionValueClass
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
        [coder skip:1u];//relative
        value = [coder decodeSInt32];
        [coder skip:18u];//int + 14 byte padding
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder skip:1u];//relative
    [coder encodeSInt32:value];
    [coder skip:18u];//int + 14 byte padding
}
@end

@implementation AlterActionRangeClass
@synthesize min, range;
- (id)init {
    self = [super init];
    if (self) {
        min = 0;
        range = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        min = [coder decodeIntegerForKey:@"minimum"];
        range = [coder decodeIntegerForKey:@"range"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:min forKey:@"minimum"];
    [coder encodeInteger:range forKey:@"range"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        [coder skip:1u];//relative
        min = [coder decodeSInt32];
        range = [coder decodeSInt32];
        [coder skip:14u];//padding
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder skip:1u];//relative
    [coder encodeSInt32:min];
    [coder encodeSInt32:range];
    [coder skip:14u];
}
@end

@implementation AlterActionRelativeRangeClass
@synthesize relative, min, range;
- (id)init {
    self = [super init];
    if (self) {
        relative = YES;
        min = 0;
        range = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        relative = [coder decodeBoolForKey:@"relative"];
        min = [coder decodeIntegerForKey:@"minimum"];
        range = [coder decodeIntegerForKey:@"range"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeBool:relative forKey:@"relative"];
    [coder encodeInteger:min forKey:@"minimum"];
    [coder encodeInteger:range forKey:@"range"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        relative = (BOOL)[coder decodeSInt8];
        min = [coder decodeSInt32];
        range = [coder decodeSInt32];
        [coder skip:14u];//padding
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt8:relative];
    [coder encodeSInt32:min];
    [coder encodeSInt32:range];
    [coder skip:14u];
}
@end

@implementation AlterActionIDRefClass
@synthesize IDRef;
- (id)init {
    self = [super init];
    if (self) {
        IDRef = nil;
    }
    return self;
}

- (void)dealloc {
    [IDRef release];
    [super dealloc];
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        IDRef = [[coder getIndexRefWithIndex:[coder decodeIntegerForKey:@"id"]
                                    forClass:[BaseObject class]] retain];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:[IDRef index] forKey:@"id"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        [coder skip:1u];//relative
        IDRef = [[coder getIndexRefWithIndex:[coder decodeSInt32]
                                    forClass:[BaseObject class]] retain];
        [coder skip:18u];//int + 14 bytes padding
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder skip:1u];//relative
    [coder encodeSInt32:[IDRef index]];
    [coder skip:18u];//int + 14 bytes padding
}
@end

@implementation AlterHealthAction @end
@implementation AlterVelocityAction @end
@implementation AlterThrustAction @end
@implementation AlterMaxThrustAction @end
@implementation AlterMaxVelocityAction @end
@implementation AlterMaxTurnRateAction @end
@implementation AlterLocationAction @end
@implementation AlterScaleAction @end
@implementation AlterPulseWeaponAction @end
@implementation AlterBeamWeaponAction @end
@implementation AlterSpecialWeaponAction @end
@implementation AlterEnergyAction @end
//@implementation AlterOnwerAction @end
@implementation AlterHiddenAction @end
@implementation AlterCloakAction @end
@implementation AlterOfflineAction @end
@implementation AlterCurrentTurnRateAction @end

@implementation AlterOnwerAction
@synthesize useObjectsOwner, value;
- (id)init {
    self = [super init];
    if (self) {
        useObjectsOwner = YES;
        value = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        useObjectsOwner = [coder decodeBoolForKey:@"useObjectsOwner"];
        value = [coder decodeIntegerForKey:@"useObjectsOwner"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeBool:useObjectsOwner forKey:@"useObjectsOwner"];
    [coder encodeInteger:value forKey:@"value"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        useObjectsOwner = (BOOL)[coder decodeSInt8];
        value = [coder decodeSInt32];
        [coder skip:18u];//int + 14 bytes padding
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt8:useObjectsOwner];
    [coder encodeSInt32:value];
    [coder skip:18u];//int + 14 bytes padding
}
@end


@implementation AlterBaseTypeAction
@synthesize retainAmmoCount, IDRef;

- (id)init {
    self = [super init];
    if (self) {
        retainAmmoCount = NO;
        IDRef = nil;
    }
    return self;
}

- (void)dealloc {
    [IDRef release];
    [super dealloc];
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        retainAmmoCount = [coder decodeBoolForKey:@"retainAmmoCount"];
        IDRef = [[coder getIndexRefWithIndex:[coder decodeIntegerForKey:@"id"]
                                    forClass:[BaseObject class]] retain];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeBool:retainAmmoCount forKey:@"retainAmmoCount"];
    [coder encodeInteger:[IDRef index]
                  forKey:@"id"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        retainAmmoCount = (BOOL)[coder decodeSInt8];
        int id = [coder decodeSInt32];
        IDRef = [[coder getIndexRefWithIndex:id
                                    forClass:[BaseObject class]] retain];
        [coder skip:18u];//int + 14 bytes padding
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt8:retainAmmoCount];
    [coder encodeSInt32:[IDRef index]];
    [coder skip:18u];//int + 14 bytes padding
}
@end

@implementation AlterActiveConditionAction
@synthesize conditionTrue, min, range;
- (id)init {
    self = [super init];
    if (self) {
        conditionTrue = YES;
        min = 0;
        range = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        conditionTrue = [coder decodeBoolForKey:@"conditionTrue"];
        min = [coder decodeIntegerForKey:@"minimum"];
        range = [coder decodeIntegerForKey:@"range"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeBool:conditionTrue forKey:@"conditionTrue"];
    [coder encodeInteger:min forKey:@"minimum"];
    [coder encodeInteger:range forKey:@"range"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        conditionTrue = (BOOL)[coder decodeSInt8];
        min = [coder decodeSInt32];
        range = [coder decodeSInt32];
        [coder skip:14u];//padding
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt8:conditionTrue];
    [coder encodeUInt32:min];
    [coder encodeSInt32:range];
    [coder skip:14u];//padding
}
@end

@implementation AlterOccupationAction @end

@implementation AlterAbsoluteCashAction
@synthesize useObjectsOwner, value, player;
- (id)init {
    self = [super init];
    if (self) {
        useObjectsOwner = NO;
        value = 0;
        player = 0;
    }
    return self;
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        useObjectsOwner = [coder decodeBoolForKey:@"useObjectsOwner"];
        value = [coder decodeIntegerForKey:@"value"];
        player = [coder decodeIntegerForKey:@"player"];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeBool:useObjectsOwner forKey:@"useObjectsOwner"];
    [coder encodeInteger:value forKey:@"value"];
    [coder encodeInteger:player forKey:@"player"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        useObjectsOwner = (BOOL)[coder decodeSInt8];
        value = [coder decodeSInt32];
        player = [coder decodeSInt32];
        [coder skip:14];//padding
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt8:useObjectsOwner];
    [coder encodeSInt32:value];
    [coder encodeSInt32:player];
}
@end

@implementation AlterAgeAction @end

@implementation AlterAbsoluteLocationAction
@synthesize relative, point;

- (id)init {
    self = [super init];
    if (self) {
        relative = NO;
        point = [[XSPoint alloc] init];
    }
    return self;
}

- (void)dealloc {
    [point release];
    [super dealloc];
}

- (id)initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        relative = [coder decodeBoolForKey:@"relative"];
        int x = [coder decodeIntegerForKey:@"x"];
        int y = [coder decodeIntegerForKey:@"y"];
        point = [[XSIPoint alloc] initWithIntegerX:x Y:y];
    }
    return self;
}

- (void)encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeBool:relative forKey:@"relative"];
    [coder encodeInteger:point.x forKey:@"x"];
    [coder encodeInteger:point.y forKey:@"y"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        relative = [coder decodeSInt8];
        int x = [coder decodeSInt32];
        int y = [coder decodeSInt32];
        point = [[XSPoint alloc] initWithX:x Y:y];
        [coder skip:14u];//padding
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [super encodeResWithCoder:coder];
    [coder encodeSInt8:relative];
    [coder encodeSInt32:point.x];
    [coder encodeSInt32:point.y];
    [coder skip:14u];//padding
}
@end

