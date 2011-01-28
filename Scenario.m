//
//  Scenario.m
//  Athena
//
//  Created by Scott McClaugherty on 1/26/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "Scenario.h"
#import "Archivers.h"
#import "NSString+LuaCoding.h"
#import "XSPoint.h"

#import "BriefPoint.h"
#import "ScenarioInitial.h"
#import "Condition.h"

@implementation Scenario
- (id) init {
    self = [super init];
//    scenId = 0;
    name = @"Untitled";

    netRaceFlags = 0x00000000;///?
    playerNum = 2;
    players = [[NSMutableArray alloc] initWithCapacity:2];
    [players addObject:[[[ScenarioPlayer alloc] initAsSinglePlayer] autorelease]];
    [players addObject:[[[ScenarioPlayer alloc] init] autorelease]];
    scoreStrings = [[NSMutableArray alloc] init];

    initialObjects = [[NSMutableArray alloc] init];
    conditions = [[NSMutableArray alloc] init];
    briefings = [[NSMutableArray alloc] init];

    starmap = [[XSPoint alloc] init];

    par = [[ScenarioPar alloc] init];

    angle = 0;

    prologueId = -1;
    epilogueId = -1;
    songId = -1;
    movie = @"";
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
//    scenId = [coder decodeIntegerForKey:@"id"];

    [name release];
    name = [coder decodeStringForKey:@"name"];
    [name retain];

    netRaceFlags = [coder decodeIntegerForKey:@"netRaceFlags"];
    playerNum = [coder decodeIntegerForKey:@"playerNum"];
    [players release];
    players = [coder decodeArrayOfClass:[ScenarioPlayer class]
                                 forKey:@"players"
                            zeroIndexed:NO];
    [players retain];

    [scoreStrings release];
    scoreStrings = [coder decodeArrayOfClass:[NSString class] forKey:@"scoreString" zeroIndexed:YES];
    [scoreStrings retain];

    [initialObjects release];
    initialObjects = [coder decodeArrayOfClass:[ScenarioInitial class] forKey:@"initialObjects" zeroIndexed:YES];
    [initialObjects retain];

    [conditions release];
    conditions = [coder decodeArrayOfClass:[Condition class] forKey:@"conditions" zeroIndexed:YES];
    [conditions retain];

    [briefings release];
    briefings = [coder decodeArrayOfClass:[BriefPoint class] forKey:@"briefing" zeroIndexed:YES];
    [briefings retain];

    [starmap release];
    starmap = [coder decodeObjectOfClass:[XSPoint class] forKey:@"starmap"];
    [starmap retain];

    [par release];
    par = [coder decodeObjectOfClass:[ScenarioPar class] forKey:@"par"];
    [par retain];

    angle = [coder decodeIntegerForKey:@"angle"];
    startTime = [coder decodeIntegerForKey:@"startTime"];
    isTraining = [coder decodeBoolForKey:@"isTraining"];

    prologueId = [coder decodeIntegerForKey:@"prologueId"];
    epilogueId = [coder decodeIntegerForKey:@"epilogueId"];
    songId = [coder decodeIntegerForKey:@"songId"];

    [movie release];
    movie = [coder decodeStringForKey:@"movie"];
    [movie retain];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
//    [coder encodeInteger:scenId forKey:@"id"];

    [coder encodeString:name forKey:@"name"];

    [coder encodeInteger:netRaceFlags forKey:@"netRaceFlags"];
    [coder encodeInteger:playerNum forKey:@"playerNum"];
    [coder encodeArray:players
                forKey:@"players"
           zeroIndexed:NO];
    [coder encodeArray:scoreStrings
                forKey:@"scoreString"
           zeroIndexed:YES];

    [coder encodeArray:initialObjects forKey:@"initialObjects" zeroIndexed:YES];
    [coder encodeArray:conditions forKey:@"conditions" zeroIndexed:YES];
    [coder encodeArray:briefings forKey:@"briefing" zeroIndexed:YES];

    [coder encodeObject:starmap forKey:@"starmap"];
    [coder encodeObject:par forKey:@"par"];

    [coder encodeInteger:angle forKey:@"angle"];
    [coder encodeInteger:startTime forKey:@"startTime"];
    [coder encodeBool:isTraining forKey:@"isTraining"];

    [coder encodeInteger:prologueId forKey:@"prologueId"];
    [coder encodeInteger:epilogueId forKey:@"epilogueId"];
    [coder encodeInteger:songId forKey:@"songId"];

    if ([movie isEqual:@""]) {
        [coder encodeNilForKey:@"movie"];
    } else {
        [coder encodeString:movie forKey:@"movie"];
    }
}

- (void) dealloc {
    [name release];
    [players release];
    [scoreStrings release];
    [initialObjects release];
    [conditions release];
    [briefings release];
    [starmap release];
    [par release];
    [movie release];
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end


@implementation ScenarioPlayer
- (id) init {
    self = [super init];
    type = PlayerTypeCpu;
    race = 100;
    name = @"Untitled";
    earningPower = 1.0f;
    netRaceFlags = 0x00000000;
    return self;
}

- (id) initAsSinglePlayer {
    self = [self init];
    type = PlayerTypeSingle;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    NSString *typeString = [coder decodeStringForKey:@"type"];
    if ([typeString isEqual:@"single"]) {
        type = PlayerTypeSingle;
    } else if ([typeString isEqual:@"net"]) {
        type = PlayerTypeNet;
    } else if ([typeString isEqual:@"cpu"]) {
        type = PlayerTypeCpu;
    }
    
    race = [coder decodeIntegerForKey:@"race"];
    [name release];
    name = [[coder decodeStringForKey:@"name"] retain];
    earningPower = [coder decodeFloatForKey:@"earningPower"];
    netRaceFlags = [coder decodeIntegerForKey:@"netRaceFlags"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    switch (type) {
        case PlayerTypeSingle:
            [coder encodeString:@"single" forKey:@"type"];
            break;
        case PlayerTypeNet:
            [coder encodeString:@"net" forKey:@"type"];
            break;
        case PlayerTypeCpu:
            [coder encodeString:@"cpu" forKey:@"type"];
            break;
        default:
            @throw @"Invalid Player Type";
            break;
    }
    
    [coder encodeInteger:race forKey:@"race"];
    [coder encodeString:name forKey:@"name"];
    [coder encodeFloat:earningPower forKey:@"earningPower"];
    [coder encodeInteger:netRaceFlags forKey:@"netRaceFlags"];
}

- (void) dealloc {
    [name release];
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end

@implementation ScenarioPar
- (id) init {
    self = [super init];
    time = 0;
    kills = 0;
    ratio = 1.0f;
    losses = 0;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    time = [coder decodeIntegerForKey:@"time"];
    kills = [coder decodeIntegerForKey:@"kills"];
    ratio = [coder decodeFloatForKey:@"ratio"];
    losses = [coder decodeIntegerForKey:@"losses"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:time forKey:@"time"];
    [coder encodeInteger:kills forKey:@"kills"];
    [coder encodeFloat:ratio forKey:@"ratio"];
    [coder encodeInteger:losses forKey:@"float"];
}

- (void) dealloc {
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end

