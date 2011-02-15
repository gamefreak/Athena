//
//  BriefingEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 2/8/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "BriefingEditor.h"
#import "MainData.h"
#import "Scenario.h"
#import "BriefPoint.h"

@implementation BriefingEditor

- (id) initWithMainData:(MainData *)_data scenario:(NSUInteger)_scenario {
    self = [super initWithWindowNibName:@"BriefingEditor"];
    if (self) {
        data = [_data retain];
        scenario = [[data.scenarios objectAtIndex:_scenario] retain];
        briefings = [scenario.briefings retain];
    }
    
    return self;
}

- (void)dealloc {
    [data release];
    [scenario release];
    [briefings release];
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
