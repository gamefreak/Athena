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

@interface SpriteEditor : NSWindowController {
    MainData *data;
    NSMutableDictionary *sprites;
    IBOutlet SpriteView *spriteView;
    IBOutlet NSDictionaryController *spriteController;
}
- (id) initWithMainData:(MainData *)data;
@end
