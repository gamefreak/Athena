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
- (id) init {
    self = [super init];
    objects = [[NSMutableArray alloc] init];
    actions = [[NSMutableArray alloc] init];
    scenarios = [[NSMutableArray alloc] init];
    briefings = [[NSMutableArray alloc] init];
    initials = [[NSMutableArray alloc] init];
    conditions = [[NSMutableArray alloc] init];
    races = [[NSMutableArray alloc] init];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    [objects    setArray:[coder decodeArrayOfClass:[BaseObject class]      forKey:@"objects"    zeroIndexed:YES]];
    [actions    setArray:[coder decodeArrayOfClass:[Action class]          forKey:@"actions"    zeroIndexed:YES]];
    [scenarios  setArray:[coder decodeArrayOfClass:[Scenario class]        forKey:@"scenarios"  zeroIndexed:YES]];
    [briefings  setArray:[coder decodeArrayOfClass:[BriefPoint class]      forKey:@"briefings"  zeroIndexed:YES]];
    [initials   setArray:[coder decodeArrayOfClass:[ScenarioInitial class] forKey:@"initials"   zeroIndexed:YES]];
    [conditions setArray:[coder decodeArrayOfClass:[Condition class]       forKey:@"conditions" zeroIndexed:YES]];
    [races      setArray:[coder decodeArrayOfClass:[Race class]            forKey:@"race"       zeroIndexed:YES]];
   
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeArray:objects    forKey:@"objects"    zeroIndexed:YES];
    [coder encodeArray:actions    forKey:@"actions"    zeroIndexed:YES];
    [coder encodeArray:scenarios  forKey:@"scenarios"  zeroIndexed:YES];
    [coder encodeArray:briefings  forKey:@"briefings"  zeroIndexed:YES];
    [coder encodeArray:initials   forKey:@"initials"   zeroIndexed:YES];
    [coder encodeArray:conditions forKey:@"conditions" zeroIndexed:YES];
    [coder encodeArray:races      forKey:@"race"       zeroIndexed:YES];
}


- (void) dealloc {
    [objects release];
    [actions release];
    [scenarios release];
    [briefings release];
    [initials release];
    [conditions release];
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
