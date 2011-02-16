//
//  ObjectEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 2/16/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ObjectEditor.h"
#import "MainData.h"
#import "BaseObject.h"

@implementation ObjectEditor
- (id)initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"ObjectEditor"];
    if (self) {
        data = [_data retain];
        objects = [data.objects retain];
    }
    return self;
}

- (void)dealloc {
    [data release];
    [objects release];
    [super dealloc];
}
@end
