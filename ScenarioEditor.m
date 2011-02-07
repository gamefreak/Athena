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
#import "TextEditor.h"
#import "StarmapPicker.h"
#import "Scenario.h"

@interface ScenarioEditor (Private)
- (void) startObservingScenario:(Scenario *)scenario;
- (void) stopObservingScenario:(Scenario *)scenario;
- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value;
- (void) insertObject:(Scenario *)scenario inScenariosAtIndex:(NSInteger)index;
- (void) removeObjectFromScenariosAtIndex:(NSInteger)index;
@end

@implementation ScenarioEditor
- (id) initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"ScenarioEditor"];
    if (self) {
        data = _data;
        [data retain];
        scenarios = data.scenarios;
        for (Scenario *scen in scenarios) {
            [self startObservingScenario:scen];
        }
        [scenarios retain];
    }
    return self;
}

- (void) startObservingScenario:(Scenario *)scenario {
    [scenario addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld context:NULL];
    [scenario addObserver:self forKeyPath:@"netRaceFlags" options:NSKeyValueObservingOptionOld context:NULL];

    [scenario addObserver:self forKeyPath:@"par.time" options:NSKeyValueObservingOptionOld context:NULL];
    [scenario addObserver:self forKeyPath:@"par.kills" options:NSKeyValueObservingOptionOld context:NULL];
    [scenario addObserver:self forKeyPath:@"par.ratio" options:NSKeyValueObservingOptionOld context:NULL];
    [scenario addObserver:self forKeyPath:@"par.losses" options:NSKeyValueObservingOptionOld context:NULL];

    [scenario addObserver:self forKeyPath:@"angle" options:NSKeyValueObservingOptionOld context:NULL];
    [scenario addObserver:self forKeyPath:@"startTime" options:NSKeyValueObservingOptionOld context:NULL];
    [scenario addObserver:self forKeyPath:@"isTraining" options:NSKeyValueObservingOptionOld context:NULL];
    [scenario addObserver:self forKeyPath:@"songId" options:NSKeyValueObservingOptionOld context:NULL];
    [scenario addObserver:self forKeyPath:@"movie" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void) stopObservingScenario:(Scenario *)scenario {
    [scenario removeObserver:self forKeyPath:@"name"];
    [scenario removeObserver:self forKeyPath:@"netRaceFlags"];

    [scenario removeObserver:self forKeyPath:@"par.time"];
    [scenario removeObserver:self forKeyPath:@"par.kills"];
    [scenario removeObserver:self forKeyPath:@"par.ratio"];
    [scenario removeObserver:self forKeyPath:@"par.losses"];

    [scenario removeObserver:self forKeyPath:@"angle"];
    [scenario removeObserver:self forKeyPath:@"startTime"];
    [scenario removeObserver:self forKeyPath:@"isTraining"];
    [scenario removeObserver:self forKeyPath:@"songId"];
    [scenario removeObserver:self forKeyPath:@"movie"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [[[[self document] undoManager]
      prepareWithInvocationTarget:self]
     changeKeyPath:keyPath
     ofObject:object
     toValue:[change objectForKey:NSKeyValueChangeOldKey]];
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value {
    [object setValue:value forKeyPath:keyPath];
}

- (void) insertObject:(Scenario *)scenario inScenariosAtIndex:(NSUInteger)index {
    [[[[self document] undoManager]
      prepareWithInvocationTarget:self]
     removeObjectFromScenariosAtIndex:index];
    NSLog(@"INSERTED");
    [self startObservingScenario:scenario];
    [scenarios insertObject:scenario atIndex:index];
}

- (void) removeObjectFromScenariosAtIndex:(NSInteger)index {
    Scenario *scen = [scenarios objectAtIndex:index];
    [[[[self document] undoManager]
      prepareWithInvocationTarget:self]
     insertObject:scen
     inScenariosAtIndex:index];
    NSLog(@"REMOVED");
    [self stopObservingScenario:scen];
    [scenarios removeObjectAtIndex:index];
}

- (void) awakeFromNib {
    [scoreStringTable setTarget:self];
    [scoreStringTable setDoubleAction:@selector(scoreStringTableClick:)];
}

- (IBAction) openInitialEditor:(id)sender {
    InitialEditor *editor = [[InitialEditor alloc] initWithMainData:data scenario:[scenarioArray selectionIndex]];
    [[self document] addWindowController:editor];
    [editor showWindow:self];
    [editor release];
}

- (IBAction) openStarmapPicker:(id)sender {
    StarmapPicker *picker = [[StarmapPicker alloc] initWithScenario:[scenarioArray selection]];
    [[self document] addWindowController:picker];
    [picker showWindow:self];
    [picker release];
}

- (IBAction) openPrologueEditor:(id)sender {
    NSString *text = [[scenarioArray selection] valueForKey:@"prologue"];
    TextEditor *editor = [[TextEditor alloc] initWithTitle:@"Prologue" text:text];
    [[self document] addWindowController:editor];
    [editor showWindow:self];
    [editor release];
    NSLog(@"Starmap");
}

- (IBAction) openEpilogueEditor:(id)sender {
    NSString *text = [[scenarioArray selection] valueForKey:@"epilogue"];
    TextEditor *editor = [[TextEditor alloc] initWithTitle:@"Epilogue" text:text];
    [[self document] addWindowController:editor];
    [editor showWindow:self];
    [editor release];
}

- (IBAction) scoreStringTableClick:(id)sender {
    NSUInteger row = [scoreStringTable clickedRow];
    if (row == -1) {
        NSMutableString *newEntry = [scoreStringController newObject];
        [scoreStringController addObject:newEntry];
        row = [[scoreStringController arrangedObjects] indexOfObjectIdenticalTo:newEntry];
        [newEntry release];
    }
    [scoreStringTable editColumn:0 row:row withEvent:nil select:NO];
}

- (void) dealloc {
    [data release];
    for (Scenario *scen in scenarios) {
        [self stopObservingScenario:scen];
    }
    [scenarios release];
    [super dealloc];
}
@end
