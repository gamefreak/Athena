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

@implementation MainData
@synthesize objects, scenarios, races;
@synthesize sprites, sounds;

- (id) init {
    self = [super init];
    objects = [[NSMutableArray alloc] init];
    scenarios = [[NSMutableArray alloc] init];
    races = [[NSMutableArray alloc] init];
    sprites = [[NSMutableDictionary alloc] init];
    sounds = [[NSMutableDictionary alloc] init];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    [objects    setArray:[coder decodeArrayOfClass:[BaseObject class]      forKey:@"objects"    zeroIndexed:YES]];
    [scenarios  setArray:[coder decodeArrayOfClass:[Scenario class]        forKey:@"scenarios"  zeroIndexed:YES]];
    [races      setArray:[coder decodeArrayOfClass:[Race class]            forKey:@"race"       zeroIndexed:YES]];
    [sprites setDictionary:[coder decodeDictionaryOfClass:[NSString class] forKey:@"sprites"]];
    [sounds setDictionary:[coder decodeDictionaryOfClass:[NSString class] forKey:@"sounds"]];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeArray:objects    forKey:@"objects"    zeroIndexed:YES];
    [coder encodeArray:scenarios  forKey:@"scenarios"  zeroIndexed:YES];
    [coder encodeArray:races      forKey:@"race"       zeroIndexed:YES];
    [coder encodeDictionary:sprites forKey:@"sprites" asArray:YES];
    [coder encodeDictionary:sounds forKey:@"sounds" asArray:YES];
}


- (void) dealloc {
    [objects release];
    [scenarios release];
    [races release];
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end
