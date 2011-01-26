//
//  Scenario.h
//  Athena
//
//  Created by Scott McClaugherty on 1/26/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

@interface Scenario : NSObject <LuaCoding> {
    NSUInteger netRaceFlags;
    NSInteger playerNum;//Number of players
    NSMutableArray *players;
    NSMutableArray *scoreStrings;
}
@end

typedef enum {
    PlayerTypeSingle,
    PlayerTypeNet,
    PlayerTypeCpu
} PlayerType;

@interface ScenarioPlayer : NSObject <LuaCoding> {
    PlayerType type;
    NSInteger race;
    NSString *name;
    float earningPower;
    NSUInteger netRaceFlags;
}
- (id) initAsSinglePlayer;
@end
