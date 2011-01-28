//
//  RaceEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "RaceEditor.h"
#import "MainData.h"

@implementation RaceEditor
- (id) initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"RaceEditor"];
    if (self) {
        data = _data;
        [data retain];
    }
    return self;
}

- (void) dealloc {
    [data release];
    [super dealloc];
}
@end
