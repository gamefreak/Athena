//
//  InitialEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 1/28/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "InitialEditor.h"
#import "MainData.h"
#import "BaseObject.h"
#import "Scenario.h"
#import "ScenarioInitial.h"

#import "ObjectEditor.h"
#import "ScenarioInitialView.h"

#import "XSInteger.h"

@interface InitialEditor (Private)
- (void) insertObject:(ScenarioInitial *)initial inInitialObjectsAtIndex:(NSInteger)index ;
- (void) removeObjectFromInitialObjectsAtIndex:(NSInteger)index;
@end

@implementation InitialEditor
@synthesize currentInitial;

- (id) initWithMainData:(MainData *)_data scenario:(NSUInteger)scenarioId {
    self = [super initWithWindowNibName:@"InitialEditor"];
    if (self) {
        data = _data;
        [data retain];
        scenario = [data.scenarios objectAtIndex:scenarioId];
        [scenario retain];
        initialObjects = scenario.initialObjects;
        [initialObjects retain];
    }
    return self;
}

- (void) dealloc {
    [data release];
    [scenario release];
    [initialObjects release];
    [super dealloc];
}

- (void) awakeFromNib {
    [initialView setInitials:initialObjects];
    [self bind:@"currentInitial"
      toObject:initialObjectsController
   withKeyPath:@"selection.self" //HACK!
       options:nil];
}

- (IBAction) openObjectPicker:(id)sender {
    ObjectEditor *editor = [[ObjectEditor alloc]
                            initAsPickerWithData:data
                            forDevices:NO];
    [[[[self window] windowController] document] addWindowController:editor];
    [editor showWindow:sender];
    [editor setSelection:currentInitial.type];
    [currentInitial bind:@"type" toObject:editor withKeyPath:@"selection" options:nil];
    [editor release];
}

#pragma mark Accessors
- (void) insertObject:(ScenarioInitial *)initial inInitialObjectsAtIndex:(NSInteger)index {
    [self startObservingInitial:initial];
    [initialObjects insertObject:initial atIndex:index];
    [initialView addInitialObject:initial];
    NSUndoManager *undo = [[self document] undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromInitialObjectsAtIndex:index];
}

- (void) removeObjectFromInitialObjectsAtIndex:(NSInteger)index {
    ScenarioInitial *initial = [initialObjects objectAtIndex:index];
    [self stopObservingInitial:initial];
    NSUndoManager *undo = [[self document] undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:initial inInitialObjectsAtIndex:index];
    [initialObjects removeObjectAtIndex:index];
    [initialView removeInitialObject:initial];
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value {
    [object setValue:value forKeyPath:keyPath];
}

- (void) startObservingInitial:(ScenarioInitial *)initial {
    [initial addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionOld context:NULL];
    [initial addObserver:self forKeyPath:@"owner" options:NSKeyValueObservingOptionOld context:NULL];

    [initial addObserver:self forKeyPath:@"position.x" options:NSKeyValueObservingOptionOld context:NULL];
    [initial addObserver:self forKeyPath:@"position.y" options:NSKeyValueObservingOptionOld context:NULL];

    [initial addObserver:self forKeyPath:@"earning" options:NSKeyValueObservingOptionOld context:NULL];
    [initial addObserver:self forKeyPath:@"distanceRange" options:NSKeyValueObservingOptionOld context:NULL];

    [initial addObserver:self forKeyPath:@"rotation" options:NSKeyValueObservingOptionOld context:NULL];
    [initial addObserver:self forKeyPath:@"rotationRange" options:NSKeyValueObservingOptionOld context:NULL];

    [initial addObserver:self forKeyPath:@"spriteIdOverride" options:NSKeyValueObservingOptionOld context:NULL];

    [initial addObserver:self forKeyPath:@"builds" options:NSKeyValueObservingOptionOld context:NULL];

    [initial addObserver:self forKeyPath:@"initialDestination" options:NSKeyValueObservingOptionOld context:NULL];
    [initial addObserver:self forKeyPath:@"nameOverride" options:NSKeyValueObservingOptionOld context:NULL];

    [initial addObserver:self forKeyPath:@"attributes.fixedRace" options:NSKeyValueObservingOptionOld context:NULL];
    [initial addObserver:self forKeyPath:@"attributes.initiallyHidden" options:NSKeyValueObservingOptionOld context:NULL];
    [initial addObserver:self forKeyPath:@"attributes.isPlayerShip" options:NSKeyValueObservingOptionOld context:NULL];
    [initial addObserver:self forKeyPath:@"attributes.staticDestination" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void) stopObservingInitial:(ScenarioInitial *)initial {
    [initial removeObserver:self forKeyPath:@"type"];
    [initial removeObserver:self forKeyPath:@"owner"];

    [initial removeObserver:self forKeyPath:@"position.x"];
    [initial removeObserver:self forKeyPath:@"position.y"];

    [initial removeObserver:self forKeyPath:@"earning"];
    [initial removeObserver:self forKeyPath:@"distanceRange"];

    [initial removeObserver:self forKeyPath:@"rotation"];
    [initial removeObserver:self forKeyPath:@"rotationRange"];

    [initial removeObserver:self forKeyPath:@"spriteIdOverride"];

    [initial removeObserver:self forKeyPath:@"builds"];

    [initial removeObserver:self forKeyPath:@"initialDestination"];
    [initial removeObserver:self forKeyPath:@"nameOverride"];

    [initial removeObserver:self forKeyPath:@"attributes.fixedRace"];
    [initial removeObserver:self forKeyPath:@"attributes.initiallyHidden"];
    [initial removeObserver:self forKeyPath:@"attributes.isPlayerShip"];
    [initial removeObserver:self forKeyPath:@"attributes.staticDestination"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    if (!initialView.isDragging) {
        [[[[self document] undoManager]
          prepareWithInvocationTarget:self]
         changeKeyPath:keyPath
         ofObject:object
         toValue:[change objectForKey:NSKeyValueChangeOldKey]];
    }
}

- (NSString *)tokenField:(NSTokenField *)tokenField displayStringForRepresentedObject:(id)representedObject {
    return [NSString stringWithFormat:@"%@", representedObject];
}

- (id) tokenField:(NSTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString {
    return [XSInteger xsIntegerWithValue:[editingString integerValue]];
}

- (void)setCurrentInitial:(ScenarioInitial *)currentInitial_ {
    [self stopObservingInitial:currentInitial];
    [currentInitial release];
    currentInitial = currentInitial_;
    [currentInitial retain];
    [self startObservingInitial:currentInitial];
}

- (ScenarioInitial *)currentInitial {
    return currentInitial;
}
@end
