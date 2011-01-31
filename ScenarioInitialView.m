//
//  ScenarioInitialView.m
//  Athena
//
//  Created by Scott McClaugherty on 1/30/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ScenarioInitialView.h"
#import "ScenarioInitial.h"
#import "BaseObject.h"
#import "XSPoint.h"
#import <math.h>

NSPoint NSPointAdd(NSPoint point, CGFloat x, CGFloat y) {
    return NSMakePoint(point.x + x, point.y + y);
}

@implementation ScenarioInitialView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        initialObjects = [[NSMutableArray alloc] init];
        scale = 1.0f;
        center = NSMakePoint(0.0f, 0.0f);
        viewTransform = [[NSAffineTransform alloc] init];
    }
    return self;
}

- (IBAction) autoScale:(id)sender {
    NSRect bounds = [self calculateScenariosBounds];
    NSRect frame = [self frame];
    NSLog(@"CALC: %@", NSStringFromRect(bounds));
    CGFloat xscale = frame.size.width / bounds.size.width;
    CGFloat yscale = frame.size.height / bounds.size.height;
    
    scale = MIN(xscale, yscale) / 1.1;
    center = NSMakePoint(NSMidX(bounds), NSMidY(bounds));
//    NSLog(@"CENTER)
    [self updateTransform];
    [self setNeedsDisplay:YES];
}

- (IBAction) zoomIn:(id)sender {
    scale *= 1.5;
    [self updateTransform];
    [self setNeedsDisplay:YES];
}

- (IBAction) zoomOut:(id)sender {
    scale /= 1.5;
    [self updateTransform];
    [self setNeedsDisplay:YES];
}

- (void) updateTransform {
    NSLog(@"Updating Transform");
    NSRect frame = [self frame];
    NSSize viewSize = NSMakeSize(frame.size.width/scale, frame.size.height/scale);
    [self setBoundsSize:viewSize];
    
    NSPoint origin;
    origin.x = center.x - viewSize.width * 0.5f;
    origin.y = center.y - viewSize.height * 0.5f;
    [self setBoundsOrigin:origin];
    NSLog(@"BOUNDS: %@", NSStringFromRect([self bounds]));
}


- (void) setInitials:(NSMutableArray *)initials {
    NSLog(@"Setting Initials");
    [initialObjects setArray:initials];
    [self autoScale:nil];
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    for (ScenarioInitial *initial in initialObjects) {
        NSColor *iconColor;
        switch (initial.owner) {
            case 0:
                iconColor = [NSColor greenColor];
                break;
            case -1:
                iconColor = [NSColor blueColor];
                break;
            default:
                iconColor = [NSColor redColor];
                break;
        }
        [self drawSquareOfSize:initial.base.iconSize
                       ofColor:iconColor
                       atPoint:initial.position.point];
    }
}

- (NSRect) calculateScenariosBounds {
    ScenarioInitial *init = [initialObjects objectAtIndex:0];
    NSPoint lowerLeft = init.position.point;
    NSPoint upperRight = lowerLeft;
    for (ScenarioInitial *init in initialObjects) {
        NSPoint position = init.position.point;
        lowerLeft.x = MIN(lowerLeft.x, position.x);
        upperRight.x = MAX(upperRight.x, position.x);
        lowerLeft.y = MIN(lowerLeft.y, position.y);
        upperRight.y = MAX(upperRight.y, position.y);
    }
    return NSMakeRect(lowerLeft.x, lowerLeft.y, upperRight.x - lowerLeft.x, upperRight.y - lowerLeft.y);
}

- (void) drawSquareOfSize:(NSInteger)size
                  ofColor:(NSColor *)color
                  atPoint:(NSPoint)point {
    [color setFill];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0.5f, 0.5f)];
    [path lineToPoint:NSMakePoint(0.5f, -0.5f)];
    [path lineToPoint:NSMakePoint(-0.5f, -0.5f)];
    [path lineToPoint:NSMakePoint(-0.5f, 0.5f)];
    [path closePath];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:point.x yBy:point.y];
    [transform scaleBy:size/scale];
    [path transformUsingAffineTransform:transform];

    [path fill];
    
}

- (void) dealloc {
    [initialObjects release];
    [viewTransform release];
    [super dealloc];
}
@end
