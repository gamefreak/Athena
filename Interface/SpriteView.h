//
//  SpriteView.h
//  Athena
//
//  Created by Scott McClaugherty on 2/15/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMIVImage;

@interface SpriteView : NSView {
    SMIVImage *sprite;
    NSInteger direction;
    NSTimer *timer;
    CGFloat speed;//FPS
    NSRange frameRange;
}
@property (readwrite, retain) SMIVImage *sprite;
@property (readwrite) NSInteger direction;
@property (readwrite, assign) CGFloat speed;
@property (readwrite, assign) CGFloat angularVelocity;
@property (readwrite, assign) NSRange frameRange;

- (void) resetTimer;
- (IBAction) triggerChange:(id)sender;
@end
