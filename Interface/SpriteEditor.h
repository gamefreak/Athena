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
}
@property (readwrite, assign) NSUInteger spriteId;
- (id) initWithMainData:(MainData *)data;
@end
