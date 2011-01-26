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

@implementation Scenario
- (id) init {
    self = [super init];
    netRaceFlags = 0x00000000;///?
    playerNum = 2;
    players = [[NSMutableArray alloc] initWithCapacity:2];
    [players addObject:[[[ScenarioPlayer alloc] initAsSinglePlayer] autorelease]];
    [players addObject:[[[ScenarioPlayer alloc] init] autorelease]];
    scoreStrings = [[NSMutableArray alloc] init];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
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
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:netRaceFlags forKey:@"netRaceFlags"];
    [coder encodeInteger:playerNum forKey:@"playerNum"];
    [coder encodeArray:players
                forKey:@"players"
           zeroIndexed:NO];
    [coder encodeArray:scoreStrings
                forKey:@"scoreString"
           zeroIndexed:YES];
}

- (void) dealloc {
    [players release];
    [scoreStrings release];
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
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
@end

