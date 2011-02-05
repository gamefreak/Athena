//
//  ScenarioEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData;

@interface ScenarioEditor : NSWindowController {
    IBOutlet NSArrayController *scenarioArray;
    MainData *data;
}
- (id) initWithMainData:(MainData *)data;
- (IBAction) openInitialEditor:(id)sender;
- (IBAction) openPrologueEditor:(id)sender;
- (IBAction) openEpilogueEditor:(id)sender;
@end
