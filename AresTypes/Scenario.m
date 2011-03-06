//
//  Scenario.m
//  Athena
//
//  Created by Scott McClaugherty on 1/26/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "Scenario.h"
#import "Archivers.h"
#import "StringTable.h"
#import "NSStringExtensions.h"
#import "XSPoint.h"
#import "XSText.h"

#import "BriefPoint.h"
#import "ScenarioInitial.h"
#import "Condition.h"

@implementation Scenario
@synthesize name, netRaceFlags;
@synthesize playerNum, players, scoreStrings;
@synthesize initialObjects, conditions, briefings;
@synthesize starmap, par, angle, startTime, isTraining;
@synthesize prologue, epilogue, songId, movie;

- (id) init {
    self = [super init];
    if (self) {
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

        prologue = [[XSText alloc] init];
        epilogue = [[XSText alloc] init];

        songId = -1;
        movie = @"";
    }
    return self;
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
    [prologue release];
    [epilogue release];
    [movie release];
    [super dealloc];
}

//MARK: Lua Coding

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
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
        scoreStrings = [coder decodeArrayOfClass:[NSMutableString class] forKey:@"scoreString" zeroIndexed:YES];
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

        prologue.text = [coder decodeStringForKey:@"prologue"];

        epilogue.text = [coder decodeStringForKey:@"epilogue"];

        songId = [coder decodeIntegerForKey:@"songId"];

        [movie release];
        movie = [coder decodeStringForKey:@"movie"];
        [movie retain];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
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

    [coder encodeString:prologue.text forKey:@"prologue"];
    [coder encodeString:epilogue.text forKey:@"epilogue"];
    [coder encodeInteger:songId forKey:@"songId"];

    if ([movie isEqual:@""]) {
        [coder encodeNilForKey:@"movie"];
    } else {
        [coder encodeString:movie forKey:@"movie"];
    }
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

+ (NSUInteger) peekAtIndexWithCoder:(ResUnarchiver *)coder {
    [coder seek:114u];
    short index = [coder decodeSInt16]-1;
    [coder seek:0u];
    return index;
}

//MARK: Res Coding
- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        netRaceFlags = [coder decodeSInt16];
        playerNum = [coder decodeSInt16];
        [players removeAllObjects];
        for (NSUInteger i = 0; i < playerNum; i++) {
            [players addObject:[[[ScenarioPlayer alloc] initWithResArchiver:coder] autorelease]];
        }
        [coder skip:20u * (4-playerNum)];

        short scoreStringsId = [coder decodeSInt16];
        if (scoreStringsId > 0) {
            [scoreStrings release];
            scoreStrings = [[[coder decodeObjectOfClass:[StringTable class] atIndex:scoreStringsId] allStrings] retain];
        }


        short initialObjectStart = [coder decodeSInt16];

        short prologueId = [coder decodeSInt16];
        if (prologueId > 0) {
            [prologue release];
            prologue = [[coder decodeObjectOfClass:[XSText class] atIndex:prologueId] retain];
        }
        short initialObjectCount = [coder decodeSInt16];
        for (int k = 0; k < initialObjectCount; k++) {
            [initialObjects addObject:[coder decodeObjectOfClass:[ScenarioInitial class] atIndex:initialObjectStart + k]];
        }

        songId = [coder decodeSInt16];
        short conditionsStart = [coder decodeSInt16];
        short epilogueId = [coder decodeSInt16];
        if (epilogueId > 0) {
            [epilogue release];
            epilogue = [[coder decodeObjectOfClass:[XSText class] atIndex:epilogueId] retain];
        }
        short conditionsCount = [coder decodeSInt16];
        for (int k = 0; k < conditionsCount; k++) {
            [conditions addObject:[coder decodeObjectOfClass:[Condition class] atIndex:conditionsStart + k]];
        }
        starmap.x = (CGFloat)[coder decodeSInt16];
        short briefingStart = [coder decodeSInt16];
        starmap.y = (CGFloat)[coder decodeSInt16];
        angle = [coder decodeSInt8];
        short briefingCount = [coder decodeSInt8];

        for (int k = 0; k < briefingCount; k++) {
            [briefings addObject:[coder decodeObjectOfClass:[BriefPoint class]  atIndex:briefingStart + k]];
        }

        par.time = [coder decodeSInt16];
        short movieId = [coder decodeSInt16];
        if (movieId > -1) {
            [movie release];
            movie = [[[coder decodeObjectOfClass:[StringTable class] atIndex:STRMovieNames] stringAtIndex:movieId] retain];
        }

        par.kills = [coder decodeSInt16];
        short scenarioId = [coder decodeSInt16];
        [name release];
        name = [[[coder decodeObjectOfClass:[StringTable class] atIndex:STRScenarioNames] stringAtIndex:scenarioId - 1] retain];

        par.ratio = [coder decodeFixed];
        par.losses = [coder decodeSInt16];

        short startTime_training = [coder decodeSInt16];
        startTime = 0x7FFF & startTime_training;
        isTraining = (0x8000 & startTime_training?YES:NO);
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt16:netRaceFlags];
    playerNum = [players count];
    [coder encodeSInt16:(SInt16)playerNum];
    for (NSUInteger i = 0; i < playerNum; i++) {
        [[players objectAtIndex:i] encodeResWithCoder:coder];
    }
    [coder skip:20u * (4u-playerNum)];
    SInt16 statusesId = STRScenarioStatusesStart + self.objectIndex;// + 1;
    if ([scoreStrings count] > 0) {
        [coder encodeSInt16:statusesId];
        for (NSString *str in scoreStrings) {
            [coder addString:str toStringTable:statusesId];
        }
    } else {
        [coder encodeSInt16:-1];
    }
    NSEnumerator *enumerator;//Declared on a separate line for reuse
    //Using an NSEnumerator object so that the first item can be handled differently
    enumerator = [initialObjects objectEnumerator];
    short initialObjectsStart = [coder encodeObject:[enumerator nextObject]];
    [coder encodeSInt16:initialObjectsStart];
    for (ScenarioInitial *initial in enumerator) {
        [coder encodeObject:initial];
    }
    if ([prologue.text isNotEqualTo:@""]) {
        [coder encodeSInt16:[coder encodeObject:prologue]];
    } else {
        [coder encodeSInt16:-1];
    }
    [coder encodeSInt16:[initialObjects count]];
    [coder encodeSInt16:songId];
    //Conditions
    enumerator = [conditions objectEnumerator];
    short conditionsStart = -1;
    if ([conditions count] > 0) {
        conditionsStart = [coder encodeObject:[enumerator nextObject]];
    }
    [coder encodeSInt16:conditionsStart];
    for (Condition *condition in enumerator) {
        [coder encodeObject:condition];
    }
    if ([epilogue.text isNotEqualTo:@""]) {
        [coder encodeSInt16:[coder encodeObject:epilogue]];
    } else {
        [coder encodeSInt16:-1];
    }
    [coder encodeSInt16:[conditions count]];
    [coder encodeSInt16:(SInt16)starmap.x];
    //Briefings
    enumerator = [briefings objectEnumerator];
    short briefingsStart = -1;
    if ([briefings count] > 0) {
        briefingsStart = [coder encodeObject:[enumerator nextObject]];//WTF? now it isn't 1-indexed?!?!?
    }
    [coder encodeSInt16:briefingsStart];
    for (BriefPoint *briefing in enumerator) {
        [coder encodeObject:briefing];
    }
    [coder encodeSInt16:(SInt16)starmap.y];
    [coder encodeSInt8:angle];
    [coder encodeSInt8:[briefings count]];

    [coder encodeSInt16:par.time];
    if ([movie isNotEqualTo:@""]) {
        [coder encodeSInt16:[coder addString:movie toStringTable:STRMovieNames]];
    } else {
        [coder encodeSInt16:-1];
    }
    [coder encodeSInt16:par.kills];
    [coder encodeSInt16:self.objectIndex + 1];
    [coder addString:name toStringTable:STRScenarioNames];
    [coder encodeFixed:par.ratio];
    [coder encodeSInt16:par.losses];
    [coder encodeSInt16:((0x7fff & (SInt16)startTime) | (isTraining?0x8000:0x0000))];
}

+ (ResType)resType {
    return 'snro';
}

+ (NSString *)typeKey {
    return @"snro";
}

+ (BOOL)isPacked {
    return YES;
}

+ (size_t)sizeOfResourceItem {
    return 124;
}


@dynamic singleLineName;
- (NSString *) singleLineName {
    NSMutableString *slName = [NSMutableString stringWithString:name];
    [slName replaceOccurrencesOfString:@"\r"
                            withString:@" "
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(0, [slName length])];
    [slName replaceOccurrencesOfString:@"\\i"
                            withString:@""
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(0, [slName length])];
    return slName;
}
@end


@implementation ScenarioPlayer
@synthesize type, race, name, earningPower, netRaceFlags;

- (id) init {
    self = [super init];
    if (self) {
        type = PlayerTypeCpu;
        race = 100;
        name = @"Untitled";
        earningPower = 1.0f;
        netRaceFlags = 0x00000000;
    }
    return self;
}

- (void) dealloc {
    [name release];
    [super dealloc];
}

- (id) initAsSinglePlayer {
    self = [self init];
    if (self) {
        type = PlayerTypeSingle;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        NSString *typeString = [coder decodeStringForKey:@"type"];
        if ([typeString isEqual:@"single"]) {
            type = PlayerTypeSingle;
        } else if ([typeString isEqual:@"net"]) {
            type = PlayerTypeNet;
        } else if ([typeString isEqual:@"cpu"]) {
            type = PlayerTypeCpu;
        } else if ([typeString isEqual:@"null"]) {
            type = PlayerTypeNull;
        }

        race = [coder decodeIntegerForKey:@"race"];
        [name release];
        name = [[coder decodeStringForKey:@"name"] retain];
        earningPower = [coder decodeFloatForKey:@"earningPower"];
        netRaceFlags = [coder decodeIntegerForKey:@"netRaceFlags"];
    }
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
        case PlayerTypeNull:
            [coder encodeString:@"null" forKey:@"type"];
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

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        type = [coder decodeSInt16];
        if (type != PlayerTypeNull) {
            race = [coder decodeSInt16];
            short stringSet = [coder decodeSInt16];
            short stringId = [coder decodeSInt16];
            if (stringSet != -1 || stringId != -1) {
                [name release];
                name = [[[coder decodeObjectOfClass:[StringTable class] atIndex:stringSet] stringAtIndex:stringId] retain];
            }
            [coder skip:4];
            earningPower = [coder decodeFixed];
            netRaceFlags = [coder decodeSInt16];
            [coder skip:2];
        } else {
            [coder skip:18];
        }
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt16:type];
    [coder encodeSInt16:race];
    [coder encodeSInt16:STRPlayerNames];
    [coder encodeSInt16:[coder addUniqueString:name toStringTable:STRPlayerNames]];
    [coder skip:4u];
    [coder encodeFixed:earningPower];
    [coder encodeSInt16:netRaceFlags];
    [coder skip:2];
}
@end

@implementation ScenarioPar
@synthesize time, kills, ratio, losses;

- (id) init {
    self = [super init];
    if (self) {
        time = 0;
        kills = 0;
        ratio = 1.0f;
        losses = 0;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        time = [coder decodeIntegerForKey:@"time"];
        kills = [coder decodeIntegerForKey:@"kills"];
        ratio = [coder decodeFloatForKey:@"ratio"];
        losses = [coder decodeIntegerForKey:@"losses"];
    }
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

static NSSet *nameKeyPaths;
+ (NSSet *) keyPathsForValuesAffectingSingleLineName {
    if (nameKeyPaths == nil) {
        nameKeyPaths = [[NSSet alloc] initWithObjects:@"name", nil];
    }
    return nameKeyPaths;
}
@end

