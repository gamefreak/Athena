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

#import "BriefPoint.h"

@implementation MainData
- (id) initWithCoder:(LuaUnarchiver *)decoder {
    [super init];
    objects = [[decoder decodeArrayOfClass:[BaseObject class]
                                    forKey:@"objects"] retain];
    
    races = [[decoder decodeArrayOfClass:[Race class]
                                 forKey:@"race"] retain];
    
    briefings = [[decoder decodeArrayOfClass:[BriefPoint class]
                                      forKey:@"briefings"] retain];;
    return self;
}

- (void) encodeWithCoder:(LuaArchiver *)aCoder {
    [aCoder encodeArray:objects forKey:@"objects"];
    [aCoder encodeArray:races forKey:@"race"];
    [aCoder encodeArray:briefings forKey:@"briefings"];
}


- (void) dealloc {
    [objects release];
    [races release];
    [briefings release];
    [super dealloc];
}
@end
