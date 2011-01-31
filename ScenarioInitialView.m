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
    }
    return self;
}

- (IBAction) autoScale:(id)sender {
    NSRect bounds = [self calculateScenariosBounds];
    NSRect frame = [self frame];
    CGFloat xscale = frame.size.width / bounds.size.width;
    CGFloat yscale = frame.size.height / bounds.size.height;
    
    scale = MIN(xscale, yscale) / 1.1;
    center = NSMakePoint(NSMidX(bounds), NSMidY(bounds));
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

        static const CGFloat iconSizeScale = 2.0f;

        switch (initial.base.iconShape) {
            case IconShapeSquare:
                [self drawSquareOfSize:initial.base.iconSize * iconSizeScale
                                 color:iconColor
                               atPoint:initial.position.point];
                break;
            case IconShapeFramedSquare:
                [self drawFramedSquareOfSize:initial.base.iconSize * iconSizeScale
                                       color:iconColor
                                     atPoint:initial.position.point];
                break;
            case IconShapeTriangle:
                [self drawTriangleOfSize:initial.base.iconSize * iconSizeScale
                                   color:iconColor
                                 atPoint:initial.position.point];
                break;
            case IconShapePlus:
                [self drawPlusOfSize:initial.base.iconSize * iconSizeScale
                                   color:iconColor
                                 atPoint:initial.position.point];
                break;
            case IconShapeDiamond:
                [self drawDiamondOfSize:initial.base.iconSize * iconSizeScale
                                  color:iconColor
                                atPoint:initial.position.point];
                break;
            default:
                break;
        }
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

- (void) drawSquareOfSize:(CGFloat)size
                    color:(NSColor *)color
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

- (void) drawFramedSquareOfSize:(CGFloat)size
                    color:(NSColor *)color
                  atPoint:(NSPoint)point {
    [color setFill];
    [[color blendedColorWithFraction:0.5f ofColor:[NSColor blackColor]] setStroke];

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
    [path stroke];//Why wont it work?
}

- (void) drawPlusOfSize:(CGFloat)size
                  color:(NSColor *)color
                atPoint:(NSPoint)point {
    static const CGFloat innerDist = 1.0f/6.0f;
    static const CGFloat outerDist = 0.5f;
    [color setFill];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(-innerDist, outerDist)];//TL
    [path lineToPoint:NSMakePoint(innerDist, outerDist)];//TR
    [path lineToPoint:NSMakePoint(innerDist, innerDist)];//TRC
    
    [path lineToPoint:NSMakePoint(outerDist, innerDist)];//RT
    [path lineToPoint:NSMakePoint(outerDist, -innerDist)];//RB
    [path lineToPoint:NSMakePoint(innerDist, -innerDist)];//BRC
    
    [path lineToPoint:NSMakePoint(innerDist, -outerDist)];//BR
    [path lineToPoint:NSMakePoint(-innerDist, -outerDist)];//BL
    [path lineToPoint:NSMakePoint(-innerDist, -innerDist)];//BLC
    
    [path lineToPoint:NSMakePoint(-outerDist, -innerDist)];//LB
    [path lineToPoint:NSMakePoint(-outerDist, innerDist)];//LT
    [path lineToPoint:NSMakePoint(-innerDist, innerDist)];//TLC
    [path closePath];

    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:point.x yBy:point.y];
    [transform scaleBy:size/scale];
    [path transformUsingAffineTransform:transform];
    [path fill];
}

- (void) drawTriangleOfSize:(CGFloat)size
                      color:(NSColor *)color
                    atPoint:(NSPoint)point {
    [color setFill];
    const CGFloat lengthAcross = sin(M_PI/3.0f);
    const CGFloat offset = tan(M_PI/6.0f)*0.5f;
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(-0.5f, offset)];
    [path lineToPoint:NSMakePoint(0.5f, offset)];
    [path lineToPoint:NSMakePoint(0.0f, -lengthAcross+offset)];
    [path closePath];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:point.x yBy:point.y];
    [transform scaleBy:size/scale];
    [path transformUsingAffineTransform:transform];
    [path fill];
}

- (void) drawDiamondOfSize:(CGFloat)size
                     color:(NSColor *)color
                   atPoint:(NSPoint)point {
    [color setFill];
    static const CGFloat scaleVl = 0.5f;

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0.0f, scaleVl)];//Top
    [path lineToPoint:NSMakePoint(scaleVl, 0.0f)];//Right
    [path lineToPoint:NSMakePoint(0.0f, -scaleVl)];//Bottom
    [path lineToPoint:NSMakePoint(-scaleVl, 0.0f)];//Left
    [path closePath];

    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:point.x yBy:point.y];
    [transform scaleBy:size/scale];
    [path transformUsingAffineTransform:transform];
    [path fill];
}
- (void) dealloc {
    [initialObjects release];
    [super dealloc];
}
@end
