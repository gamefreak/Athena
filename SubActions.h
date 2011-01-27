//
//  SubActions.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Action.h"

@interface NoAction : Action {
}
@end

@interface CreateObjectAction : Action {
    NSInteger baseType;
    NSInteger min, range;
    BOOL velocityRelative, directionRelative;
    NSInteger distanceRange;
}
@end

@interface PlaySoundAction : Action {
    NSInteger priority, persistence;
    BOOL isAbsolute;
    NSInteger volume, volumeRange;
    NSInteger soundId, soundIdRange;
}
@end

@interface MakeSparksAction : Action {
    NSInteger count;
    NSInteger velocity, velocityRange;
    NSInteger color;
}
@end

@interface ReleaseEnergyAction : Action {
    float percent;
}
@end

@interface LandAtAction : Action {
    NSInteger speed;
}
@end

@interface EnterWarpAction : Action {
    NSInteger warpSpeed;
}
@end

@interface DisplayMessageAction : Action {
    NSInteger ID, page;
}
@end

@interface ChangeScoreAction : Action {
    NSInteger player, score, amount;
}
@end

@interface DeclareWinnerAction : Action {
    NSInteger player, nextLevel;
    NSMutableString *text;
}
@end

typedef enum {
    DieActionNormal,
    DieActionExpire,
    DieActionDestroy
} DieActionHow;

@interface DieAction : Action {
    DieActionHow how;
}
@end

@interface SetDestinationAction : Action {
}
@end

@interface ActivateSpecialAction : Action {
}
@end

@interface ActivatePulseAction : Action {
}
@end

@interface ActivateBeamAction : Action {
}
@end

@interface ColorFlashAction : Action {
    NSInteger duration;
    NSInteger color, shade;
}
@end

@interface CreateObjectSetDestinationAction : CreateObjectAction {
}
@end

@interface NilTargetAction : Action {
}
@end

@interface DisableKeysAction : Action {
    NSUInteger keyMask;
}
@end

@interface EnableKeysAction : DisableKeysAction {
}
@end

@interface SetZoomLevelAction : Action {
    NSInteger zoomLevel;
}
@end

@interface ComputerSelectAction : Action {
    NSInteger screen, line;
}
@end

@interface AssumeInitialObjectAction : Action {
    NSInteger ID;
}
@end

/* Copying stub.
@interface CN : Action {
    
}
@end
*/