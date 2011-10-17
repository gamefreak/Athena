//
//  ScenarioEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData;

@interface ScenarioEditor : NSWindowController <NSComboBoxCellDataSource> {
    IBOutlet NSArrayController *scenarioArray;
    IBOutlet NSTableView *scoreStringTable;
    IBOutlet NSArrayController *scoreStringController;
    MainData *data;
    NSMutableArray *scenarios;
    NSMutableArray *players;
    NSMutableArray *scoreStrings;
}
- (id) initWithMainData:(MainData *)data;
- (IBAction) openInitialEditor:(id)sender;
- (IBAction) openStarmapPicker:(id)sender;
- (IBAction) openBriefingEditor:(id)sender;
- (IBAction) openConditionEditor:(id)sender;

- (IBAction) scoreStringTableClick:(id)sender;
@end
