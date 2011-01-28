//
//  AthenaDocument.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class MainData;
@class RaceEditor, ScenarioEditor;

@interface AthenaDocument : NSDocument {
    MainData *data;
    RaceEditor *raceEditor;
    ScenarioEditor *scenarioEditor;
}
- (IBAction) openRaceEditor:(id)sender;
- (IBAction) openScenarioEditor:(id)sender;
@end
