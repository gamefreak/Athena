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
@synthesize dragStartEvent;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        image = nil;
        dragTimer = nil;
        dragStartEvent = nil;
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

- (void)mouseDown:(NSEvent *)event {
    dragTimer = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(beginDrag:) userInfo:NULL repeats:NO] retain];
    [self setDragStartEvent:event];
}

- (void)mouseUp:(NSEvent *)event {
    [dragTimer invalidate];
    [dragTimer release];
    dragTimer = nil;
}

- (void)beginDrag:(NSTimer *)timer_ {
    NSAssert(dragTimer == timer_, @"Recieved beginDrag: message from wrong timer.");
    [dragTimer release];
    dragTimer = nil;

    [self dragPromisedFilesOfTypes:[NSArray arrayWithObject:NSPasteboardTypePNG]
                          fromRect:NSZeroRect
                            source:self
                         slideBack:YES
                             event:dragStartEvent];
}

- (void)dragImage:(NSImage *)image_
               at:(NSPoint)location
           offset:(NSSize)offset
            event:(NSEvent *)event
       pasteboard:(NSPasteboard *)pboard
           source:(id)source
        slideBack:(BOOL)slideFlag {
    //Add png data
    [pboard setData:[image PNGData] forType:NSPasteboardTypePNG];
    //calculate base point
    NSPoint point = [self convertPoint:[dragStartEvent locationInWindow] fromView:nil];
    //Offsest to center the image
    NSSize size = [[image image] size];
    point.x -= size.width / 2.0;
    point.y -= size.height / 2.0;
    [super dragImage:[image image]
                  at:point
              offset:NSZeroSize
               event:event
          pasteboard:pboard
              source:source
           slideBack:slideFlag];
}

- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination {
    NSString *path = [dropDestination path];
    NSString *fileName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [image name]]];
    [[image PNGData] writeToFile:fileName atomically:NO];
    return [NSArray arrayWithObject:fileName];
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag {
    return NSDragOperationCopy;
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
