//
//  MainData.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainData.h"
#import "Archivers.h"
#import "BaseObject.h"
#import "Race.h"
#import "Scenario.h"
#import "ScenarioInitial.h"
#import "Condition.h"
#import "BriefPoint.h"
#import "Action.h"

@implementation MainData
- (id) initWithLuaCoder:(LuaUnarchiver *)decoder {
    [super init];
    objects = [[decoder decodeArrayOfClass:[BaseObject class]
                                    forKey:@"objects"
                               zeroIndexed:YES] retain];
    
    races = [[decoder decodeArrayOfClass:[Race class]
                                 forKey:@"race"
                             zeroIndexed:YES] retain];
    
    briefings = [[decoder decodeArrayOfClass:[BriefPoint class]
                                      forKey:@"briefings"
                                 zeroIndexed:YES] retain];

    initials = [[decoder decodeArrayOfClass:[ScenarioInitial class]
                                     forKey:@"initials"
                                zeroIndexed:YES] retain];

    scenarios = [[decoder decodeArrayOfClass:[Scenario class]
                                      forKey:@"scenarios"
                                 zeroIndexed:YES] retain];
    conditions = [[decoder decodeArrayOfClass:[Condition class]
                                       forKey:@"conditions"
                                  zeroIndexed:YES] retain];
    actions = [[decoder decodeArrayOfClass:[Action class]
                                    forKey:@"actions"
                               zeroIndexed:YES] retain];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)aCoder {
    [aCoder encodeArray:objects forKey:@"objects" zeroIndexed:YES];
    [aCoder encodeArray:races forKey:@"race" zeroIndexed:YES];
    [aCoder encodeArray:briefings forKey:@"briefings" zeroIndexed:YES];
    [aCoder encodeArray:initials forKey:@"initials" zeroIndexed:YES];
    [aCoder encodeArray:scenarios forKey:@"scenarios" zeroIndexed:YES];
    [aCoder encodeArray:conditions forKey:@"conditions" zeroIndexed:YES];
    [aCoder encodeArray:actions forKey:@"actions" zeroIndexed:YES];
}


- (void) dealloc {
    [objects release];
    [races release];
    [briefings release];
    [initials release];
    [scenarios release];
    [conditions release];
    [actions release];
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end
