//
//  BriefingEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 2/8/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "BriefingEditor.h"


@implementation BriefingEditor

- (id) initWithScenario:(Scenario *)_scenario {
    self = [super initWithWindowNibName:@"BriefingEditor"];
    if (self) {
        scenario = _scenario;
        [scenario retain];
    }
    
    return self;
}

- (void)dealloc {
    [scenario release];
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
