//
//  MainData.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "MainData.h"
#import "Archivers.h"

#import "BaseObject.h"
#import "Action.h"
#import "Scenario.h"
#import "BriefPoint.h"
#import "ScenarioInitial.h"
#import "Condition.h"
#import "Race.h"

static NSArray *mainDataKeys;
@implementation MainDataFlags
@synthesize isNetworkable, customObjects, customRaces, customScenarios, isUnoptimized;

+ (NSArray *)keys {
    if (mainDataKeys == nil) {
        mainDataKeys = [[NSArray alloc] initWithObjects:@"isNetworkable", @"customObjects", @"customRaces", @"customScenarios", @"isUnoptimized", nil];
    }
    return mainDataKeys;
}
@end


@implementation MainData
@synthesize inFlareId, outFlareId, playerBodyId, energyBlobId;
@synthesize title, downloadUrl, author, authorUrl, flags;
@synthesize version, minVersion;
//@synthesize checkSum;

@synthesize objects, scenarios, races;
@synthesize sprites, sounds;

- (id) init {
    self = [super init];
    playerBodyId = 22;
    energyBlobId = 28;
    inFlareId = 32;
    outFlareId = 33;
    title = @"";
    downloadUrl = @"";
    author = @"";
    authorUrl = @"";

    flags = [[MainDataFlags alloc] init];

    objects = [[NSMutableArray alloc] init];
    scenarios = [[NSMutableArray alloc] init];
    races = [[NSMutableArray alloc] init];
    sprites = [[NSMutableDictionary alloc] init];
    sounds = [[NSMutableDictionary alloc] init];
    return self;
}

//MARK: Lua Coding
- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    [objects    setArray:[coder decodeArrayOfClass:[BaseObject class]      forKey:@"objects"    zeroIndexed:YES]];
    [scenarios  setArray:[coder decodeArrayOfClass:[Scenario class]        forKey:@"scenarios"  zeroIndexed:YES]];
    [races      setArray:[coder decodeArrayOfClass:[Race class]            forKey:@"race"       zeroIndexed:YES]];
    [sprites setDictionary:[coder decodeDictionaryOfClass:[NSString class] forKey:@"sprites"]];
    [sounds setDictionary:[coder decodeDictionaryOfClass:[NSString class] forKey:@"sounds"]];

    [flags initWithLuaCoder:coder];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [flags encodeLuaWithCoder:coder];
    [coder encodeArray:objects    forKey:@"objects"    zeroIndexed:YES];
    [coder encodeArray:scenarios  forKey:@"scenarios"  zeroIndexed:YES];
    [coder encodeArray:races      forKey:@"race"       zeroIndexed:YES];
    [coder encodeDictionary:sprites forKey:@"sprites" asArray:YES];
    [coder encodeDictionary:sounds forKey:@"sounds" asArray:YES];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

//MARK: Res Coding
- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        inFlareId = [coder decodeSInt32];
        outFlareId = [coder decodeSInt32];
        playerBodyId = [coder decodeSInt32];
        energyBlobId = [coder decodeSInt32];

        downloadUrl = [[coder decodePStringOfLength:0xff] retain];
        title = [[coder decodePStringOfLength:0xff] retain];
        author = [[coder decodePStringOfLength:0xff] retain];
        authorUrl = [[coder decodePStringOfLength:0xff] retain];

        version = [coder decodeUInt32];
        minVersion = [coder decodeUInt32];

        [flags initWithResArchiver:coder];
        checkSum = [coder decodeUInt32];
    }
    return self;
}

//- (void)encodeResWithCoder:(ResArchiver *)archiver {
//}

+ (ResType)resType {
    return 'nlAG';
}

+ (NSString *)typeKey {
    return @"nlAG";
}

+ (BOOL) isPacked {
    return NO;
}

- (void) dealloc {
    [objects release];
    [scenarios release];
    [races release];
    [super dealloc];
}
@end
