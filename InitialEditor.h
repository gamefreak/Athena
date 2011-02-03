//
//  InitialEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 1/28/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData, Scenario;
@class ScenarioInitialView;

@interface InitialEditor : NSWindowController {
    MainData *data;
    Scenario *scenario;
    NSMutableArray *initialObjects;
    IBOutlet ScenarioInitialView *initialView;
}
- (id) initWithMainData:(MainData *)data scenario:(NSUInteger)scenario;

- (IBAction)fudge:(id)sender;
@end
