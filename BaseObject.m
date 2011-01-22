//
//  BaseObject.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseObject.h"
#import "Archivers.h"

@implementation BaseObject
- (id) initWithCoder:(NSCoder *)coder {
    [super init];
    return self;
}

- (void) encodeWithCoder:(NSCoder *)coder {
}

- (void) dealloc {
    [super dealloc];
}
@end
