//
//  BaseObjectFlags.h
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Archivers.h"
#import "FlagBlob.h"

@interface BaseObjectAttributes : FlagBlob {
    BOOL canTurn;
    BOOL canBeEngaged;
    BOOL hasDirectionGoal;
    BOOL isRemote;
    BOOL isHumanControlled;
    BOOL isBeam;
    BOOL doesBounce;
    BOOL isSelfAnimated;
    BOOL shapeFromDirection;
    BOOL isPlayerShip;
    BOOL canBeDestination;
    BOOL canEngage;
    BOOL canEvade;
    BOOL canAcceptMessages;
    BOOL canAcceptBuild;
    BOOL canAcceptDestination;
    BOOL autoTarget;
    BOOL animationCycle;
    BOOL canCollide;
    BOOL canBeHit;
    BOOL isDestination;
    BOOL hideEffect;
    BOOL releaseEnergyOnDeath;
    BOOL hated;
    BOOL occupiesSpace;
    BOOL staticDestination;
    BOOL canBeEvaded;
    BOOL neutralDeath;
    BOOL isGuided;
    BOOL appearOnRadar;
    BOOL onAutoPilot;
}
@property (readwrite, assign) BOOL canTurn;
@property (readwrite, assign) BOOL canBeEngaged;
@property (readwrite, assign) BOOL hasDirectionGoal;
@property (readwrite, assign) BOOL isRemote;
@property (readwrite, assign) BOOL isHumanControlled;
@property (readwrite, assign) BOOL isBeam;
@property (readwrite, assign) BOOL doesBounce;
@property (readwrite, assign) BOOL isSelfAnimated;
@property (readwrite, assign) BOOL shapeFromDirection;
@property (readwrite, assign) BOOL isPlayerShip;
@property (readwrite, assign) BOOL canBeDestination;
@property (readwrite, assign) BOOL canEngage;
@property (readwrite, assign) BOOL canEvade;
@property (readwrite, assign) BOOL canAcceptMessages;
@property (readwrite, assign) BOOL canAcceptBuild;
@property (readwrite, assign) BOOL canAcceptDestination;
@property (readwrite, assign) BOOL autoTarget;
@property (readwrite, assign) BOOL animationCycle;
@property (readwrite, assign) BOOL canCollide;
@property (readwrite, assign) BOOL canBeHit;
@property (readwrite, assign) BOOL isDestination;
@property (readwrite, assign) BOOL hideEffect;
@property (readwrite, assign) BOOL releaseEnergyOnDeath;
@property (readwrite, assign) BOOL hated;
@property (readwrite, assign) BOOL occupiesSpace;
@property (readwrite, assign) BOOL staticDestination;
@property (readwrite, assign) BOOL canBeEvaded;
@property (readwrite, assign) BOOL neutralDeath;
@property (readwrite, assign) BOOL isGuided;
@property (readwrite, assign) BOOL appearOnRadar;
@property (readwrite, assign) BOOL onAutoPilot;
@end

@interface BaseObjectBuildFlags : FlagBlob {
    BOOL uncapturedBaseExists;
    BOOL sufficientEscortExists;
    BOOL thisBaseNeedsProtection;
    BOOL friendUpTrend;
    BOOL friendDownTrend;
    BOOL foeUpTrend;
    BOOL foeDownTrend;
    BOOL matchingFoeExists;
    BOOL onlyEngagedBy;
    BOOL canOnlyEngage;
    BOOL engageKey1;
    BOOL engageKey2;
    BOOL engageKey3;
    BOOL engageKey4;
    BOOL levelKey1;
    BOOL levelKey2;
    BOOL levelKey3;
    BOOL levelKey4;
}
@property (readwrite, assign) BOOL uncapturedBaseExists;
@property (readwrite, assign) BOOL sufficientEscortExists;
@property (readwrite, assign) BOOL thisBaseNeedsProtection;
@property (readwrite, assign) BOOL friendUpTrend;
@property (readwrite, assign) BOOL friendDownTrend;
@property (readwrite, assign) BOOL foeUpTrend;
@property (readwrite, assign) BOOL foeDownTrend;
@property (readwrite, assign) BOOL matchingFoeExists;
@property (readwrite, assign) BOOL onlyEngagedBy;
@property (readwrite, assign) BOOL canOnlyEngage;
@property (readwrite, assign) BOOL engageKey1;
@property (readwrite, assign) BOOL engageKey2;
@property (readwrite, assign) BOOL engageKey3;
@property (readwrite, assign) BOOL engageKey4;
@property (readwrite, assign) BOOL levelKey1;
@property (readwrite, assign) BOOL levelKey2;
@property (readwrite, assign) BOOL levelKey3;
@property (readwrite, assign) BOOL levelKey4;

@end


@interface BaseObjectOrderFlags : FlagBlob {
    BOOL strongerThanTarget;
    BOOL targetIsBase;
    BOOL targetIsNotBase;
    BOOL targetIsLocal;
    BOOL targetIsRemote;
    BOOL onlyEscortNotBase;
    BOOL targetIsFriend;
    BOOL targetIsFoe;
    BOOL hardMatchingFriend;
    BOOL hardMatchingFoe;
    BOOL hardFriendlyEscortOnly;
    BOOL hardNoFriendlyEscort;
    BOOL hardTargetIsRemote;
    BOOL hardTargetIsLocal;
    BOOL hardTargetIsFoe;
    BOOL hardTargetIsFriend;
    BOOL hardTargetIsNotBase;
    BOOL hardTargetIsBase;
    BOOL orderKey1;
    BOOL orderKey2;
    BOOL orderKey3;
    BOOL orderKey4;
}
@property (readwrite, assign) BOOL strongerThanTarget;
@property (readwrite, assign) BOOL targetIsBase;
@property (readwrite, assign) BOOL targetIsNotBase;
@property (readwrite, assign) BOOL targetIsLocal;
@property (readwrite, assign) BOOL targetIsRemote;
@property (readwrite, assign) BOOL onlyEscortNotBase;
@property (readwrite, assign) BOOL targetIsFriend;
@property (readwrite, assign) BOOL targetIsFoe;
@property (readwrite, assign) BOOL hardMatchingFriend;
@property (readwrite, assign) BOOL hardMatchingFoe;
@property (readwrite, assign) BOOL hardFriendlyEscortOnly;
@property (readwrite, assign) BOOL hardNoFriendlyEscort;
@property (readwrite, assign) BOOL hardTargetIsRemote;
@property (readwrite, assign) BOOL hardTargetIsLocal;
@property (readwrite, assign) BOOL hardTargetIsFoe;
@property (readwrite, assign) BOOL hardTargetIsFriend;
@property (readwrite, assign) BOOL hardTargetIsNotBase;
@property (readwrite, assign) BOOL hardTargetIsBase;
@property (readwrite, assign) BOOL orderKey1;
@property (readwrite, assign) BOOL orderKey2;
@property (readwrite, assign) BOOL orderKey3;
@property (readwrite, assign) BOOL orderKey4;
@end
