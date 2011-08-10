//
//  SpecialViewController.h
//  Athena
//
//  Created by Scott McClaugherty on 8/2/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BaseObject, FrameData, SMIVImage;
@class SpriteView;

@interface SpecialViewController : NSViewController {
    FrameData *frame;
    BaseObject *object;
    IBOutlet SpriteView *spriteView;
}
@property (readwrite, retain) FrameData *frame;
@property (readwrite, retain) BaseObject *object;
- (void) updateViewSprite;
@end
