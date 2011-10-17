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
#import "BriefingEditor.h"
#import "ConditionEditor.h"
#import "StarmapPicker.h"
#import "Scenario.h"

@interface ScenarioEditor (Private)
- (void) startObservingPlayer:(ScenarioPlayer *)player;
- (void) stopObservingPlayer:(ScenarioPlayer *)player;
- (void) insertObject:(ScenarioPlayer *)player inPlayersAtIndex:(NSUInteger)index;
- (void) removeObjectFromPlayersAtIndex:(NSUInteger)index;

- (void) startObservingScenario:(Scenario *)scenario;
- (void) stopObservingScenario:(Scenario *)scenario;
- (void) insertObject:(Scenario *)scenario inScenariosAtIndex:(NSUInteger)index;
- (void) removeObjectFromScenariosAtIndex:(NSUInteger)index;


- (void) insertObject:(NSMutableString *)string inScoreStringsAtIndex:(NSUInteger)index;
- (void) removeObjectFromScoreStringsAtIndex:(NSUInteger)index;

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value;
@end

@implementation ScenarioEditor
- (id) initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"ScenarioEditor"];
    if (self) {
        data = _data;
        [data retain];
        scenarios = [data mutableArrayValueForKey:@"scenarios"];;
        for (Scenario *scen in scenarios) {
            [self startObservingScenario:scen];
        }
        [scenarios retain];
    }
    return self;
}

- (void) startObservingPlayer:(ScenarioPlayer *)player {
    [player addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionOld context:NULL];
    [player addObserver:self forKeyPath:@"race" options:NSKeyValueObservingOptionOld context:NULL];
    [player addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld context:NULL];
    [player addObserver:self forKeyPath:@"earningPower" options:NSKeyValueObservingOptionOld context:NULL];
    [player addObserver:self forKeyPath:@"netRaceFlags" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void) stopObservingPlayer:(ScenarioPlayer *)player {
    [player removeObserver:self forKeyPath:@"type"];
    [player removeObserver:self forKeyPath:@"race"];
    [player removeObserver:self forKeyPath:@"name"];
    [player removeObserver:self forKeyPath:@"earningPower"];
    [player removeObserver:self forKeyPath:@"netRaceFlags"];
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

    for (ScenarioPlayer *player in scenario.players) {
        [self startObservingPlayer:player];
    }
    
    for (NSMutableString *string in scenario.scoreStrings) {
        [string addObserver:self forKeyPath:@"string" options:NSKeyValueObservingOptionOld context:NULL];
    }
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

    for (ScenarioPlayer *player in scenario.players) {
        [self stopObservingPlayer:player];
    }
    
    for (NSMutableString *string in scenario.scoreStrings) {
        [string removeObserver:self forKeyPath:@"string"];
    }
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

- (void) insertObject:(ScenarioPlayer *)player inPlayersAtIndex:(NSUInteger)index {
    [[[[self document] undoManager]
      prepareWithInvocationTarget:self]
     removeObjectFromPlayersAtIndex:index];
    [self startObservingPlayer:player];
    [players insertObject:player atIndex:index];
}

- (void) removeObjectFromPlayersAtIndex:(NSUInteger)index {
    ScenarioPlayer *player = [players objectAtIndex:index];
    [[[[self document] undoManager]
      prepareWithInvocationTarget:self]
     insertObject:player
     inPlayersAtIndex:index];
    [self stopObservingPlayer:player];
    [players removeObjectAtIndex:index];
}

- (void) insertObject:(Scenario *)scenario inScenariosAtIndex:(NSUInteger)index {
    [[[[self document] undoManager]
      prepareWithInvocationTarget:self]
     removeObjectFromScenariosAtIndex:index];
    [self startObservingScenario:scenario];
    [scenarios insertObject:scenario atIndex:index];
}

- (void) removeObjectFromScenariosAtIndex:(NSUInteger)index {
    Scenario *scen = [scenarios objectAtIndex:index];
    [[[[self document] undoManager]
      prepareWithInvocationTarget:self]
     insertObject:scen
     inScenariosAtIndex:index];
    [self stopObservingScenario:scen];
    [scenarios removeObjectAtIndex:index];
}

- (void) insertObject:(NSMutableString *)string inScoreStringsAtIndex:(NSUInteger)index {
    [[[[self document] undoManager]
      prepareWithInvocationTarget:self]
     removeObjectFromScoreStringsAtIndex:index];
    [string addObserver:self forKeyPath:@"string" options:NSKeyValueObservingOptionOld context:NULL];
    [scoreStrings insertObject:string atIndex:index];
}

- (void) removeObjectFromScoreStringsAtIndex:(NSUInteger)index {
    NSMutableString *string = [scoreStrings objectAtIndex:index];
    [[[[self document] undoManager]
      prepareWithInvocationTarget:self]
     insertObject:string inScoreStringsAtIndex:index];
    [string removeObserver:self forKeyPath:@"string"];
    [scoreStrings removeObjectAtIndex:index];
}

- (void) awakeFromNib {
    [scoreStringTable setTarget:self];
    [scoreStringTable setDoubleAction:@selector(scoreStringTableClick:)];
    [self bind:@"players" toObject:scenarioArray withKeyPath:@"selection.players" options:nil];
    [self bind:@"scoreStrings" toObject:scenarioArray withKeyPath:@"selection.scoreStrings" options:nil];
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

- (IBAction) openBriefingEditor:(id)sender {
    BriefingEditor *editor = [[BriefingEditor alloc] initWithMainData:data scenario:[scenarioArray selectionIndex]];
    [[self document] addWindowController:editor];
    [editor showWindow:self];
    [editor release];
}

- (IBAction) openConditionEditor:(id)sender {
    ConditionEditor *editor = [[ConditionEditor alloc] initWithMainData:data scenario:[scenarioArray selectionIndex]];
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

- (NSInteger)numberOfItemsInComboBoxCell:(NSComboBoxCell *)comboBoxCell {
    
    return [[data valueForKeyPath:@"scenarios.@distinctUnionOfArrays.players.name"] count];
}

- (id)comboBoxCell:(NSComboBoxCell *)aComboBoxCell objectValueForItemAtIndex:(NSInteger)index {
    return [[data valueForKeyPath:@"scenarios.@distinctUnionOfArrays.players.name"] objectAtIndex:index];
}
@end
