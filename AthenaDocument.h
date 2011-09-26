//
//  AthenaDocument.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class MainData;

@interface AthenaDocument : NSDocument {
    MainData *data;
}
@property (readonly) MainData *data;

- (IBAction) openObjectEditor:(id)sender;
- (IBAction) openScenarioEditor:(id)sender;
- (IBAction) openRaceEditor:(id)sender;
- (IBAction) openSpriteEditor:(id)sender;
- (IBAction) openSoundEditor:(id)sender;
@end
