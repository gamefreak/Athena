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
    NSMutableDictionary *sprites;
    
    IBOutlet SpriteView *spriteView;
    IBOutlet NSDictionaryController *spriteController;

    IBOutlet NSWindow *dimensionsSheet;
    IBOutlet NSTextField *widthInput;
    IBOutlet NSTextField *heightInput;
}
@property (readwrite, assign) NSUInteger spriteId;
@property (readonly) NSDictionaryController *spriteController;
- (id) initWithMainData:(MainData *)data;
- (BOOL)addSpriteForPath:(NSString *)path;
- (IBAction)dimensionsOk:(id)sender;
- (IBAction)dimensionsCancel:(id)sender;
- (void)didEnd:(NSWindow *)sheet returnCode:(int)code context:(void *)context;
- (BOOL)addSprite:(SMIVImage *)sprite;
@end
