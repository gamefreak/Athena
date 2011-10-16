//
//  BaseObjectFlags.m
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "BaseObjectFlags.h"


@implementation BaseObjectAttributes
@synthesize canTurn, canBeEngaged, hasDirectionGoal,isRemote;
@synthesize isHumanControlled;
@synthesize isBeam, doesBounce, isSelfAnimated, shapeFromDirection;
@synthesize isPlayerShip, canBeDestination, canEngage, canEvade;
@synthesize canAcceptMessages, canAcceptBuild, canAcceptDestination, autoTarget;
@synthesize animationCycle, canCollide, canBeHit, isDestination;
@synthesize hideEffect, releaseEnergyOnDeath, hated, occupiesSpace;
@synthesize staticDestination, canBeEvaded, neutralDeath, isGuided;
@synthesize appearOnRadar, bit31, onAutoPilot;

+ (NSArray *) keys {
    static NSArray *bsobAttributeKeys;
    if (bsobAttributeKeys == nil) {
        bsobAttributeKeys = [[NSArray alloc] initWithObjects:@"canTurn", @"canBeEngaged", @"hasDirectionGoal", @"isRemote",
                             @"isHumanControlled", @"isBeam", @"doesBounce", @"isSelfAnimated",
                             @"shapeFromDirection", @"isPlayerShip", @"canBeDestination", @"canEngage",
                             @"canEvade", @"canAcceptMessages", @"canAcceptBuild", @"canAcceptDestination",
                             @"autoTarget", @"animationCycle", @"canCollide", @"canBeHit",
                             @"isDestination", @"hideEffect", @"releaseEnergyOnDeath", @"hated",
                             @"occupiesSpace", @"staticDestination", @"canBeEvaded", @"neutralDeath",
                             @"isGuided", @"appearOnRadar", @"bit31", @"onAutoPilot", nil];
        
    }
    return bsobAttributeKeys;
}

+ (NSArray *) names {
    static NSArray *bsobAttributeNames;
    if (bsobAttributeNames == nil) {
        bsobAttributeNames = [[NSArray alloc] initWithObjects:@"Can Turn", @"Can Be Engaged", @"Has Direction Goal", @"Is Remote",
                             @"Is Human Controlled", @"Is Beam", @"Does Bounce", @"Is Self Animated",
                             @"Shape From Direction", @"Is Player Ship", @"Can Be Destination", @"Can Engage",
                             @"Can Evade", @"Can Accept Messages", @"Can Accept Build", @"Can Accept Destination",
                             @"Auto Target", @"Animation Cycle", @"Can Collide", @"Can Be Hit",
                             @"Is Destination", @"Hide Effect", @"Release Energy On Death", @"Hated",
                             @"Occupies Space", @"Static Destination", @"Can Be Evaded", @"Neutral Death",
                             @"Is Guided [A]", @"Appears On Radar [B]", @"Bit 31 [C]", @"On Auto Pilot [D]", nil];
    }
    return bsobAttributeNames;
}
@end

@implementation BaseObjectBuildFlags
@synthesize uncapturedBaseExists, sufficientEscortExists, thisBaseNeedsProtection;
@synthesize friendUpTrend, friendDownTrend, foeUpTrend, foeDownTrend;
@synthesize matchingFoeExists, onlyEngagedBy, canOnlyEngage;
@synthesize engageKey1, engageKey2, engageKey3, engageKey4;
@synthesize levelKey1, levelKey2, levelKey3, levelKey4;

+ (NSArray *) keys {
    static NSArray *bsobBuildFlagsKeys;
    if (bsobBuildFlagsKeys == nil) {
        bsobBuildFlagsKeys = [[NSArray alloc] initWithObjects:
        @"uncapturedBaseExists", @"sufficientEscortExists", @"thisBaseNeedsProtection", @"friendUpTrend",
        @"friendDownTrend", @"foeUpTrend", @"foeDownTrend", @"matchingFoeExists",
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], @"onlyEngagedBy", @"canOnlyEngage",
        @"engageKey1", @"engageKey2", @"engageKey3", @"engageKey4",
        @"levelKey1", @"levelKey2", @"levelKey3", @"levelKey4", nil];
    }
    return bsobBuildFlagsKeys;
}

+ (NSArray *) names {
    static NSArray *bsobBuildFlagsNames;
    if (bsobBuildFlagsNames == nil) {
        bsobBuildFlagsNames = [[NSArray alloc] initWithObjects:
                              @"Uncaptured Base Exists", @"Sufficient Escort Exists", @"This Base Needs Protection", @"Friend Up Trend",
                              @"Friend Down Trend", @"Foe Up Trend", @"Foe Down Trend", @"Matching Foe Exists",
                              [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                              [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                              [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                              [NSNull null], [NSNull null], @"Only Engaged By", @"Can Only Engage",
                              @"Engage Key 1", @"Engage Key 2", @"Engage Key 3", @"Engage Key 4",
                              @"Level Key 1", @"Level Key 2", @"Level Key 3", @"Level Key 4", nil];
    }
    return bsobBuildFlagsNames;
}
@end

@implementation BaseObjectOrderFlags
@synthesize strongerThanTarget, targetIsBase, targetIsNotBase, targetIsLocal, targetIsRemote;
@synthesize onlyEscortNotBase, targetIsFriend, targetIsFoe, hardMatchingFriend, hardMatchingFoe;
@synthesize hardFriendlyEscortOnly, hardNoFriendlyEscort, hardTargetIsRemote, hardTargetIsLocal;
@synthesize hardTargetIsFoe, hardTargetIsFriend, hardTargetIsNotBase, hardTargetIsBase;
@synthesize orderKey1, orderKey2, orderKey3, orderKey4;

+ (NSArray *) keys {
    static NSArray *bsobOrderKeyKeys;
    if (bsobOrderKeyKeys == nil) {
        bsobOrderKeyKeys = [[NSArray alloc] initWithObjects:
        @"strongerThanTarget", @"targetIsBase", @"targetIsNotBase", @"targetIsLocal",
        @"targetIsRemote", @"onlyEscortNotBase", @"targetIsFriend", @"targetIsFoe",
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [NSNull null], [NSNull null], @"hardMatchingFriend", @"hardMatchingFoe",
        @"hardFriendlyEscortOnly", @"hardNoFriendlyEscort", @"hardTargetIsRemote", @"hardTargetIsLocal",
        @"hardTargetIsFoe", @"hardTargetIsFriend", @"hardTargetIsNotBase", @"hardTargetIsBase",
        @"orderKey1", @"orderKey2", @"orderKey3", @"orderKey4", nil];
    }
    return bsobOrderKeyKeys;
}

+ (NSArray *) names {
    static NSArray *bsobOrderKeyNames;
    if (bsobOrderKeyNames == nil) {
        bsobOrderKeyNames = [[NSArray alloc] initWithObjects:
                            @"Stronger Than Target", @"Target Is Base", @"Target Is Not Base", @"Target Is Local",
                            @"Target Is Remote", @"Only Escort Not Base", @"Target Is Friend", @"Target Is Foe",
                            [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                            [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                            [NSNull null], [NSNull null], @"Hard Matching Friend", @"Hard Matching Foe",
                            @"Hard Friendly Escort Only", @"Hard No Friendly Escort", @"Hard Target Is Remote", @"Hard Target Is Local",
                            @"Hard Target Is Foe", @"Hard Target Is Friend", @"Hard Target Is Not Base", @"Hard Target Is Base",
                            @"Order Key 1", @"Order Key 2", @"Order Key 3", @"Order Key 4", nil];
    }
    return bsobOrderKeyNames;
}
@end


