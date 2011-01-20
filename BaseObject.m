//
//  BaseObject.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseObject.h"


@implementation BaseObject
- (id) initWithCoder:(NSCoder *)coder {
    [super init];
    NSLog(@"BaseObject init");
    return self;
}

- (void) encodeWithCoder:(NSCoder *)coder {
    @throw @"Unimplemented";
}
@end
