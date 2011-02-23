//
//  StarmapView.h
//  Athena
//
//  Created by Scott McClaugherty on 2/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XSPoint;
@class StarmapPicker;

@interface StarmapView : NSView {
    IBOutlet StarmapPicker *controller;
    NSImage *starmap;
    XSPoint *point;
}

@end
