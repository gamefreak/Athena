//
//  MainData.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainData.h"
#import "LuaUnarchiver.h"
#import "BaseObject.h"

@implementation MainData
- (id) initWithCoder:(LuaUnarchiver *)decoder {
    [super init];
    objects = [[decoder decodeArrayOfClass:[BaseObject class]
                                    forKey:@"objects"] retain];
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    @throw @"Unimplemented";
}


- (void) dealloc {
    [objects release];
    [super dealloc];
}
@end
