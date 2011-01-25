//
//  BaseObjectFlags.m
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "BaseObjectFlags.h"

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

static NSArray *bsobBuildFlags;
@implementation BaseObjectBuildFlags
+ (NSArray *) keys {
    if (bsobBuildFlags == nil) {
        bsobBuildFlags = [[NSArray alloc] initWithObjects:
        @"uncapturedBaseExists", @"sufficientEscortExists", @"thisBaseNeedsProtection", @"friendUpTrend",
        @"friendDownTrend", @"foeUpTrend", @"foeDownTrend", @"matchingFoeExists",
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], @"onlyEngagedBy", @"canOnlyEngage",
        @"engageKey1", @"engageKey2", @"engageKey3", @"engageKey4",
        @"levelKey1", @"levelKey2", @"levelKey3", @"levelKey4", nil];
    }
    return bsobBuildFlags;
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


