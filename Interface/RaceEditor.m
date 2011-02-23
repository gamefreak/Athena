//
//  RaceEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "RaceEditor.h"
#import "MainData.h"
#import "Race.h"

@implementation RaceEditor
- (id) initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"RaceEditor"];
    if (self) {
        data = _data;
        [data retain];
        races = data.races;
        [races retain];
        for (Race *race in races) {
            [self startObservingRace:race];
        }
    }
    return self;
}

- (void) dealloc {
    [data release];
    for (Race *race in races) {
        [self stopObservingRace:race];
    }
    [races release];
    [super dealloc];
}

- (void) insertObject:(Race *)newRace
       inRacesAtIndex:(NSInteger)index {
    [self startObservingRace:newRace];
    NSUndoManager *undo = [[self document] undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromRacesAtIndex:index];
    [races insertObject:newRace atIndex:index];
}

- (void) removeObjectFromRacesAtIndex:(NSInteger)index {
    Race *old = [races objectAtIndex:index];
    [self stopObservingRace:old];
    NSUndoManager *undo = [[self document] undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:old
                                           inRacesAtIndex:index];
    [races removeObjectAtIndex:index];
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value {
    [object setValue:value forKeyPath:keyPath];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    NSUndoManager *undo = [[self document] undoManager];
    id old = [change objectForKey:NSKeyValueChangeOldKey];
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                  ofObject:object
                                                   toValue:old];
}



- (void) startObservingRace:(Race *)race {
    [race addObserver:self forKeyPath:@"raceId" options:NSKeyValueObservingOptionOld context:NULL];
    [race addObserver:self forKeyPath:@"advantage" options:NSKeyValueObservingOptionOld context:NULL];
    [race addObserver:self forKeyPath:@"singular" options:NSKeyValueObservingOptionOld context:NULL];
    [race addObserver:self forKeyPath:@"plural" options:NSKeyValueObservingOptionOld context:NULL];
    [race addObserver:self forKeyPath:@"military" options:NSKeyValueObservingOptionOld context:NULL];
    [race addObserver:self forKeyPath:@"homeworld" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void) stopObservingRace:(Race *)race {
    [race removeObserver:self forKeyPath:@"raceId"];
    [race removeObserver:self forKeyPath:@"advantage"];
    [race removeObserver:self forKeyPath:@"singular"];
    [race removeObserver:self forKeyPath:@"plural"];
    [race removeObserver:self forKeyPath:@"military"];
    [race removeObserver:self forKeyPath:@"homeworld"];
}
@end
