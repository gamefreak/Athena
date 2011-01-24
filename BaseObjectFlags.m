//
//  BaseObjectFlags.m
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "BaseObjectFlags.h"

static NSArray *attributeBlobKeys;
@implementation ObjectFlags
+ (NSArray *) keys {
    if (attributeBlobKeys == nil) {
        attributeBlobKeys = [[NSArray alloc] init];
    }
    return attributeBlobKeys;
    
}

- (id) init {
    self = [super init];
    NSArray *keys = [[self class] keys];
    for (id key in keys) {
        if (key == [NSNull null]) {
            continue;
        }
        [self setValue:[NSNumber numberWithBool:NO] forKey:key];
    }
    return self;
}

- (id) initWithCoder:(LuaUnarchiver *)coder {
    self = [self init];
    NSArray *keys = [[self class] keys];
    for (id key in keys) {
        if (key == [NSNull null]) {
            continue;
        }
        [self setValue:[NSNumber numberWithBool:[coder decodeBoolForKey:key]]
                forKey:key];
    }
    return self;
}

- (void) encodeWithCoder:(LuaArchiver *)coder {
    NSUInteger hex = 0x00000000;
    NSArray *keys = [[self class] keys];
    NSInteger position = 0;
    for (id key in keys) {
        if (key == [NSNull null]) {
            continue;
        }
        [coder encodeBool:[[self valueForKey:key] boolValue] forKey:key];
        hex |= 1 << position;
        position++;
    }
    [coder encodeInteger:hex forKey:@"hex"];
}
@end

static NSArray *bsobAttributeKeys;
@implementation BaseObjectAttributes
+ (NSArray *) keys {
    if (bsobAttributeKeys == nil) {
        bsobAttributeKeys = [[NSArray alloc] initWithObjects:@"canTurn", @"canBeEngaged", @"hasDirectionGoal", @"isRemote",
                             @"isHumanControlled", @"isBeam", @"doesBounce", @"isSelfAnimated",
                             @"shapeFromDirection", @"isPlayerShip", @"canBeDestination", @"canEngage",
                             @"canEvade", @"canAcceptMessages", @"canAcceptBuild", @"canAcceptDestination",
                             @"autoTarget", @"animationCycle", @"canCollide", @"canBeHit",
                             @"isDestination", @"hideEffect", @"releaseEnergyOnDeath", @"hated",
                             @"occupiesSpace", @"staticDestination", @"canBeEvaded", @"neutralDeath",
                             @"isGuided", @"appearOnRadar", [NSNull null], @"onAutoPilot", nil];
        
    }
    return bsobAttributeKeys;
}
@end


static NSArray *bsobOrderKeys;
@implementation BaseObjectOrderFlags
+ (NSArray *) keys {
    if (bsobOrderKeys == nil) {
        bsobOrderKeys = [[NSArray alloc] initWithObjects:
        @"strongerThanTarget", @"targetIsBase", @"targetIsNotBase", @"targetIsLocal",
        @"targetIsRemote", @"onlyEscortNotBase", @"targetIsFriend", @"targetIsFoe",
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], @"hardMatchingFriend", @"hardMatchingFoe",
        @"hardFriendlyEscortOnly", @"hardNoFriendlyEscort", @"hardTargetIsRemote", @"hardTargetIsLocal",
        @"hardTargetIsFoe", @"hardTargetIsFriend", @"hardTargetIsNotBase", @"hardTargetIsBase",
        @"orderKey1", @"orderKey2", @"orderKey3", @"orderKey4", nil];
    }
    return bsobOrderKeys;
}

@end


