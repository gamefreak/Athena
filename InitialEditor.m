//
//  InitialEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 1/28/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "InitialEditor.h"
#import "MainData.h"
#import "Scenario.h"
#import "ScenarioInitial.h"
#import "ScenarioInitialView.h"

@implementation InitialEditor
- (id) initWithMainData:(MainData *)_data scenario:(NSUInteger)scenarioId {
    self = [super initWithWindowNibName:@"InitialEditor"];
    if (self) {
        data = _data;
        [data retain];
        scenario = [data.scenarios objectAtIndex:scenarioId];
        [scenario retain];
        for (ScenarioInitial *initial in scenario.initialObjects) {
            [initial findBaseFromArray:data.objects];
        }
    }
    return self;
}

- (void) awakeFromNib {
    [initialView setInitials:scenario.initialObjects];
}

- (void) dealloc {
    [data release];
    [scenario release];
    [super dealloc];
}
@end
