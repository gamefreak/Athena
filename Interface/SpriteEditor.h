//
//  SpriteEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 2/14/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData;
@class SpriteView;
@class SMIVImage;

@interface SpriteEditor : NSWindowController {
    MainData *data;
    NSMutableArray *sprites;
    
    IBOutlet SpriteView *spriteView;
    IBOutlet NSArrayController *spriteController;

    IBOutlet NSWindow *dimensionsSheet;
    IBOutlet NSTextField *widthInput;
    IBOutlet NSTextField *heightInput;
}
@property (readwrite, assign) NSUInteger spriteId;
@property (readonly) NSArrayController *spriteController;
- (id) initWithMainData:(MainData *)data;
- (BOOL)addSpriteForPath:(NSString *)path;
- (IBAction)dimensionsOk:(id)sender;
- (IBAction)dimensionsCancel:(id)sender;
- (void)didEnd:(NSWindow *)sheet returnCode:(int)code context:(void *)context;
- (BOOL)addSprite:(SMIVImage *)sprite;
- (IBAction)openSprite:(id)sender;
- (IBAction)exportSprite:(id)sender;
@end
