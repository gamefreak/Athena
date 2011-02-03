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
        initialObjects = scenario.initialObjects;
        [initialObjects retain];

        for (ScenarioInitial *initial in initialObjects) {
            [initial findBaseFromArray:data.objects];
        }
    }
    return self;
}

- (void) awakeFromNib {
    [initialView setInitials:initialObjects];
}

- (void) dealloc {
    [data release];
    [scenario release];
    [initialObjects release];
    [super dealloc];
}

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

#pragma mark Accessors
- (void) insertObject:(ScenarioInitial *)initial inInitialObjectsAtIndex:(NSInteger)index {
    [initialView addInitialObject:initial];
    [initialObjects insertObject:initial atIndex:index];
}

- (void) removeObjectFromInitialObjectsAtIndex:(NSInteger)index {
    ScenarioInitial *initial = [initialObjects objectAtIndex:index];
    [initialView removeInitialObject:initial];
    [initialObjects removeObjectAtIndex:index];
}
@end
