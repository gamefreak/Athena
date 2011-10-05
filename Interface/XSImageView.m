//
//  XSImageView.m
//  Athena
//
//  Created by Scott McClaugherty on 10/4/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSImageView.h"
#import "XSImage.h"

@implementation XSImageView
@dynamic image;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        image = nil;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    if (image == nil) {
        return;
    }
    //Get the sizes of the objects we are working with
    NSRect thisRect = [self bounds];
    NSSize imageSize = [[image image] size];
    //Determine what to scale the image by to preserve whole image visibility.
    CGFloat scaleRatio = MIN(thisRect.size.width / imageSize.width, thisRect.size.height / imageSize.height);
    scaleRatio = MIN(scaleRatio, 1.0f);
    //Scale the image
    imageSize.width *= scaleRatio;
    imageSize.height *= scaleRatio;
    //Create some padding around the image
    NSSize sizeDiff = NSMakeSize(thisRect.size.width - imageSize.width, thisRect.size.height - imageSize.height);
    NSRect targetRect = NSInsetRect(thisRect, sizeDiff.width/2.0f, sizeDiff.height/2.0f);
    //draw it.
    [[image image] drawInRect:targetRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];

}

- (XSImage *)image {
    @synchronized(self) {
        return [[image retain] autorelease];
    }
}

- (void)setImage:(XSImage *)image_ {
    @synchronized(self) {
        [image_ retain];
        [image release];
        image = image_;
    }
    [self setNeedsDisplay:YES];
}

@end
