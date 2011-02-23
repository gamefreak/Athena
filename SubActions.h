//
//  SubActions.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Action.h"

@class Index, XSText;

@interface NoAction : Action {
}
@end

@interface CreateObjectAction : Action {
    Index *baseType;
    NSInteger min, range;
    BOOL velocityRelative, directionRelative;
    NSInteger distanceRange;
}
@property (readwrite, retain) Index *baseType;
@property (readwrite, assign) NSInteger min;
@property (readwrite, assign) NSInteger range;
@property (readwrite, assign) BOOL velocityRelative;
@property (readwrite, assign) BOOL directionRelative;
@property (readwrite, assign) NSInteger distanceRange;
@end

@interface PlaySoundAction : Action {
    NSInteger priority, persistence;
    BOOL isAbsolute;
    NSInteger volume, volumeRange;
    NSInteger soundId, soundIdRange;
}
@property (readwrite, assign) NSInteger priority;
@property (readwrite, assign) NSInteger persistence;
@property (readwrite, assign) BOOL isAbsolute;
@property (readwrite, assign) NSInteger volume;
@property (readwrite, assign) NSInteger volumeRange;
@property (readwrite, assign) NSInteger soundId;
@property (readwrite, assign) NSInteger soundIdRange;
@end

@interface MakeSparksAction : Action {
    NSInteger count;
    NSInteger velocity, velocityRange;
    NSInteger color;
}
@property (readwrite, assign) NSInteger count;
@property (readwrite, assign) NSInteger velocity;
@property (readwrite, assign) NSInteger velocityRange;
@property (readwrite, assign) NSInteger color;
@end

@interface ReleaseEnergyAction : Action {
    float percent;
}
@property (readwrite, assign) float percent;
@end

@interface LandAtAction : Action {
    NSInteger speed;
}
@property (readwrite, assign) NSInteger speed;
@end

@interface EnterWarpAction : Action {
    NSInteger warpSpeed;
}
@property (readwrite, assign) NSInteger warpSpeed;
@end

@interface DisplayMessageAction : Action {
    NSInteger ID, page;
}
@property (readwrite, assign) NSInteger ID;
@property (readwrite, assign) NSInteger page;
@end

@interface ChangeScoreAction : Action {
    NSInteger player, score, amount;
}
@property (readwrite, assign) NSInteger player;
@property (readwrite, assign) NSInteger score;
@property (readwrite, assign) NSInteger amount;
@end

@interface DeclareWinnerAction : Action {
    NSInteger player;
    Index *nextLevel;
    XSText *text;
}
@property (readwrite, assign) NSInteger player;
@property (readwrite, retain) Index *nextLevel;
@property (readwrite, retain) XSText *text;
@end

typedef enum {
    DieActionNormal,
    DieActionExpire,
    DieActionDestroy
} DieActionHow;

@interface DieAction : Action {
    DieActionHow how;
}
@property (readwrite, assign) DieActionHow how;
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
@property (readwrite, assign) NSInteger duration;
@property (readwrite, assign) NSInteger color;
@property (readwrite, assign) NSInteger shade;
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
@property (readwrite, assign) NSUInteger keyMask;
@end

@interface EnableKeysAction : DisableKeysAction {
}
@end

@interface SetZoomLevelAction : Action {
    NSInteger zoomLevel;
}
@property (readwrite, assign) NSInteger zoomLevel;
@end

@interface ComputerSelectAction : Action {
    NSInteger screen, line;
}
@property (readwrite, assign) NSInteger screen;
@property (readwrite, assign) NSInteger line;
@end

@interface AssumeInitialObjectAction : Action {
    NSInteger ID;
}
@property (readwrite, assign) NSInteger ID;
@end

/* Copying stub.
@interface CN : Action {
    
}
@end
*/