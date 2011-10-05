//
//  XSImageView.h
//  Athena
//
//  Created by Scott McClaugherty on 10/4/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XSImage;

@interface XSImageView : NSView {
    XSImage *image;

    NSTimer *dragTimer;
    NSEvent *dragStartEvent;
}
@property (readwrite, retain) XSImage *image;
@property (readwrite, retain) NSEvent *dragStartEvent;
- (void)beginDrag:(NSTimer *)timer;
@end
