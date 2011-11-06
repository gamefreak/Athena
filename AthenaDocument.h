//
//  AthenaDocument.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class MainData;

extern NSString *XSAntaresPluginUTI;
extern NSString *XSAresPluginUTI;
extern NSString *XSXseraPluginUTI;

@interface AthenaDocument : NSDocument {
    MainData *data;
    IBOutlet NSWindow *easter;
    IBOutlet NSTextField *identifierField;
}
@property (readonly) MainData *data;

- (IBAction) openObjectEditor:(id)sender;
- (IBAction) openScenarioEditor:(id)sender;
- (IBAction) openRaceEditor:(id)sender;
- (IBAction) openImageEditor:(id)sender;
- (IBAction) openSpriteEditor:(id)sender;
- (IBAction) openSoundEditor:(id)sender;
- (IBAction) displayEasterWindow:(id)sender;
@end

@interface AthenaDocumentWindow : NSWindow {
}
@end

@interface EasterWindow : NSWindow {
    IBOutlet NSTextField *label;
}
@end