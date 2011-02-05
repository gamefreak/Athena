//
//  ScenarioEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ScenarioEditor.h"
#import "MainData.h"
#import "InitialEditor.h"

@implementation ScenarioEditor
- (id) initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"ScenarioEditor"];
    if (self) {
        data = _data;
        [data retain];
    }
    return self;
}

- (IBAction) openInitialEditor:(id)sender {
    InitialEditor *editor = [[InitialEditor alloc] initWithMainData:data scenario:[scenarioArray selectionIndex]];
    [[self document] addWindowController:editor];
    [editor showWindow:self];
    [editor release];
}


- (void) dealloc {
    [data release];
    [super dealloc];
}
@end
