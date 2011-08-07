//
//  SpecialViewController.h
//  Athena
//
//  Created by Scott McClaugherty on 8/2/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FrameData;

@interface SpecialViewController : NSViewController {
    FrameData *frame;
}
@property (readwrite, retain) FrameData *frame;
@end
