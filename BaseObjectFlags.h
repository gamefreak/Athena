//
//  BaseObjectFlags.h
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Archivers.h"

//Abstract Class
@interface ObjectFlags : NSObject <NSCoding> {}
+ (NSArray *)keys;
@end

@interface BaseObjectAttributes : ObjectFlags {
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
@end

@interface BaseObjectOrderFlags : ObjectFlags {
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
@end
