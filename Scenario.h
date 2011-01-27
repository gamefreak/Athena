//
//  Scenario.h
//  Athena
//
//  Created by Scott McClaugherty on 1/26/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

@class XSRange, XSPoint;
@class ScenarioPar;

@interface Scenario : NSObject <LuaCoding> {
//    NSInteger scenId;
    NSString *name;

    NSUInteger netRaceFlags;
    NSInteger playerNum;//Number of players
    NSMutableArray *players;
    NSMutableArray *scoreStrings;
    XSRange *initialObjects;
    XSRange *conditions;
    XSRange *briefings;
    XSPoint *starmap;

    ScenarioPar *par;

    NSInteger angle;
    NSInteger startTime;
    BOOL isTraining;

    NSInteger prologueId;
    NSInteger epilogueId;
    NSInteger songId;
    NSString *movie;
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

@interface ScenarioPar : NSObject <LuaCoding> {
    NSInteger time;
    NSInteger kills;
    float ratio;
    NSInteger losses;
}
@end

