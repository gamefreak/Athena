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

/* Copying stub.
@interface CN : Action {
    
}
@end
*/