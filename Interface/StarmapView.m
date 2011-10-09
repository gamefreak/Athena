//
//  StarmapView.m
//  Athena
//
//  Created by Scott McClaugherty on 2/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "StarmapView.h"
#import "StarmapPicker.h"
#import "XSPoint.h"

@implementation StarmapView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Starmap" ofType:@"png"];
        starmap = [[NSImage alloc] initWithContentsOfFile:path];   
    }
    return self;
}

- (void)awakeFromNib {
    point = [[controller valueForKeyPath:@"scenario.starmap"] retain];
    [point addObserver:self forKeyPath:@"point" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [starmap drawInRect:[self bounds]
               fromRect:NSZeroRect
              operation:NSCompositeSourceOver
               fraction:1.0f];
    NSSize buffer = NSMakeSize(10.0f, 10.0f);
        NSRect bounds = [self bounds];
    NSBezierPath *path = [NSBezierPath bezierPath];
    CGFloat x = point.x;
    CGFloat y = bounds.size.height - point.y;
    
    [path setLineWidth:1.5f];
    [path setLineJoinStyle:NSMiterLineJoinStyle];
    [path moveToPoint:NSMakePoint(0, y)];//X-left
    [path lineToPoint:NSMakePoint(x - buffer.width, y)];
    [path moveToPoint:NSMakePoint(x + buffer.width, y)];//X-right
    [path lineToPoint:NSMakePoint(bounds.size.width, y)];
    
    [path moveToPoint:NSMakePoint(x, 0)];//Y-bottom
    [path lineToPoint:NSMakePoint(x, y - buffer.width)];
    [path moveToPoint:NSMakePoint(x, y + buffer.height)];//Y-top
    [path lineToPoint:NSMakePoint(x, bounds.size.height)];
    
    //Bracket-bottom
    [path moveToPoint:NSMakePoint(x - buffer.width, y - buffer.height + 4.0f)];
    [path lineToPoint:NSMakePoint(x - buffer.width, y - buffer.height)];
    [path lineToPoint:NSMakePoint(x + buffer.width, y - buffer.height)];
    [path lineToPoint:NSMakePoint(x + buffer.width, y - buffer.height + 4.0f)];
    
    //Bracket-top
    [path moveToPoint:NSMakePoint(x - buffer.width, y + buffer.height - 4.0f)];
    [path lineToPoint:NSMakePoint(x - buffer.width, y + buffer.height)];
    [path lineToPoint:NSMakePoint(x + buffer.width, y + buffer.height)];
    [path lineToPoint:NSMakePoint(x + buffer.width, y + buffer.height - 4.0f)];
    [[NSColor yellowColor] set];
    [path stroke];
    
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint newPoint = [self convertPoint:event.locationInWindow fromView:nil];
    newPoint.y = [self bounds].size.height - newPoint.y;
    point.point = newPoint;
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    [starmap release];
    [point release];
    [super dealloc];
}
@end
