//
//  SpriteView.m
//  Athena
//
//  Created by Scott McClaugherty on 2/15/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SpriteView.h"
#import "SMIVImage.h"

@implementation SpriteView
@dynamic sprite, direction, speed, frameRange, angularVelocity;
@synthesize dragStartEvent;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"sprite" options:NSKeyValueObservingOptionOld context:NULL];
        direction = 0;
        speed = 1.0f;
        dragging = NO;
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"sprite"];
    [timer invalidate];
    [timer release];
    [dragTimer invalidate];
    [dragTimer release];
    [dragStartEvent release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor blackColor] set];
    NSRectFill(dirtyRect);
    NSRect frame = [self frame];
    NSSize size = [sprite cellSize];
    if (direction != 2) {
        [sprite drawAtPoint:CGPointMake((frame.size.width - size.width)/2.0f, (frame.size.height - size.height)/2.0f)];
    } else {
        NSSize grid = [sprite gridDistribution];
        [sprite drawSpriteSheetAtPoint:CGPointMake(
        floorf((frame.size.width  - size.width  * grid.width )/2.0f),
        floorf((frame.size.height - size.height * grid.height)/2.0f))];
    }

}

- (void) resetTimer {
    [timer invalidate];
    [timer release];
    timer = nil;
    if (direction == 1 || direction == -1) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:1.0f / (speed) target:self selector:@selector(triggerChange:) userInfo:NULL repeats:YES] retain];
    }
}

- (IBAction) triggerChange:(id)sender {
    if ([sprite count] == 0) {
        return;
    }
    if (direction == 1) {
        [sprite nextFrame];
    } else if (direction == -1) {
        [sprite previousFrame];
    }
    
    int pos = [sprite currentFrame];
    int left = frameRange.location;
    int right = (frameRange.location + frameRange.length - 1) % [sprite count];
    //Stupid wrapped ranges
    if (left < right) {
        //concave range |...[------]...|
        if (right < pos) {
            if (direction == 1) {
                [sprite setCurrentFrame:left];
            } else if (direction == -1) {
                [sprite setCurrentFrame:right];
            }
        } else if (pos < left) {
            if (direction == 1) {
                [sprite setCurrentFrame:left];
            } else if (direction == -1) {
                [sprite setCurrentFrame:right];
            }
        }
    } else if (right < left) {
        //convex range |---]......[---|
        if (right < pos && pos < left) {
            if (direction == 1) {
                [sprite setCurrentFrame:left];
            } else if (direction == -1) {
                [sprite setCurrentFrame:right];
            }
        }
    }
    [self setNeedsDisplay:YES];
}

- (void)setSprite:(SMIVImage *)sprite_ {
    [sprite release];
    sprite = sprite_;
    [sprite retain];
    [self setFrameRange:NSMakeRange(0, [sprite count])]; 
}

- (SMIVImage *)sprite {
    return sprite;
}

- (void)setDirection:(NSInteger)_direction {
    direction = _direction;
    [self resetTimer];
    [self setNeedsDisplay:YES];
}

- (NSInteger)direction {
    return direction;
}

- (void)setSpeed:(CGFloat)_speed {
    speed = _speed;
    [self resetTimer];
}

- (CGFloat)speed {
    return speed;
}

- (void)setAngularVelocity:(CGFloat)angularVelocity {
    [self setSpeed:angularVelocity * [sprite count] / (2.0f  * M_PI)];
}

- (CGFloat)angularVelocity {
    //circle/slices * slices / second = circles/second
    return 2.0f * M_PI / [sprite count] * speed;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay:YES];
}

- (void)setFrameRange:(NSRange)frameRange_ {
    frameRange = frameRange_;
    [sprite setCurrentFrame:frameRange.location];
}

- (NSRange)frameRange {
    return frameRange;
}

- (void)mouseDown:(NSEvent *)event {
    dragTimer = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(beginDrag:) userInfo:NULL repeats:NO] retain];

    [self setDragStartEvent:event];
}

- (void)mouseUp:(NSEvent *)event {
    if (!dragging) {
        if (direction == 1) {
            [self setDirection:-1];
        } else if (direction == -1) {
            [self setDirection:1];
        }
    }
    [dragTimer invalidate];
    [dragTimer release];
    dragTimer = nil;
    dragging = NO;
}

- (void)beginDrag:(NSTimer *)timer_ {
    NSAssert(dragTimer == timer_, @"Recieved beginDrag: message from wrong timer.");
    [dragTimer release];
    dragTimer = nil;
    dragging = YES;
    
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
    NSData *png = [sprite PNGData];
    //make a better drag image
    NSImage *dragImage;
    if ([dragStartEvent modifierFlags] & NSAlternateKeyMask) {//GIF
        //GIF gets only the first frame
        //or would the current frame be better?
        CGImageRef sheet = [sprite image];
        CGRect rect = [sprite rectForFrame:0];
        CGImageRef subImage = CGImageCreateWithImageInRect(sheet, rect);
        dragImage = [[[NSImage alloc] initWithCGImage:subImage size:rect.size] autorelease];
        CGImageRelease(subImage);
    } else {
        //PNG gets the spritesheet
        dragImage = [[[NSImage alloc] initWithData:png] autorelease];
    }
    //Add png data
    [pboard setData:png forType:NSPasteboardTypePNG];
    //calculate base point
    NSPoint point = [self convertPoint:[dragStartEvent locationInWindow] fromView:nil];
    //Offsest to center the image
    NSSize size = [dragImage size];
    point.x -= size.width / 2.0;
    point.y -= size.height / 2.0;
    [super dragImage:dragImage
                  at:point
              offset:NSZeroSize
               event:event
          pasteboard:pboard
              source:source
           slideBack:slideFlag];
}

- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination {
    NSString *path = [dropDestination path];
    NSString *fileName = nil;
    if ([dragStartEvent modifierFlags] & NSAlternateKeyMask) {//GIF
        fileName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", [sprite title]]];
        [[sprite GIFData] writeToFile:fileName atomically:NO];
    } else {//PNG
        fileName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [sprite title]]];
        [[sprite PNGData] writeToFile:fileName atomically:NO];
    }
    return [NSArray arrayWithObject:fileName];
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag {
    return NSDragOperationCopy;
}
@end
