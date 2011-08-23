//
//  InitialEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 1/28/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData;
@class Scenario, ScenarioInitial;
@class ScenarioInitialView;

@interface InitialEditor : NSWindowController <NSTokenFieldDelegate> {
    MainData *data;
    Scenario *scenario;
    ScenarioInitial *currentInitial;//BOUND
    NSMutableArray *initialObjects;
    IBOutlet NSArrayController *initialObjectsController;
    IBOutlet ScenarioInitialView *initialView;
}
@property (readwrite, retain) ScenarioInitial *currentInitial;
- (id) initWithMainData:(MainData *)data scenario:(NSUInteger)scenario;

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value;
- (void) startObservingInitial:(ScenarioInitial *)initial;
- (void) stopObservingInitial:(ScenarioInitial *)initial;


- (IBAction) openObjectPicker:(id)sender;
@end
