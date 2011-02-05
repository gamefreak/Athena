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

NSRect SquareRectWithCenterAndSize(NSPoint center, CGFloat size) {
    return NSMakeRect(center.x - size * 0.5f, center.y - size * 0.5f, size, size);
}

const CGFloat selectionBorderThickness = 4.0f;
const CGFloat iconSizeScale = 2.0f;

@implementation ScenarioInitialView
@synthesize isDragging;

- (id)initWithFrame:(NSRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        initialObjects = [[NSMutableArray alloc] init];
        scale = 1.0f;
        center = NSMakePoint(0.0f, 0.0f);
        destinations = [[NSMutableSet alloc] init];
        shouldDrawLabels = YES;
        clickedObject = nil;
        isDragging = NO;
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
}

- (IBAction) zoomIn:(id)sender {
    scale *= 1.5;
    [self updateTransform];
}

- (IBAction) zoomOut:(id)sender {
    scale /= 1.5;
    [self updateTransform];
}

- (IBAction) redraw:(id)sender {
    [self setNeedsDisplay:YES];
}

- (void) updateTransform {
    NSRect frame = [self frame];
    NSSize viewSize = NSMakeSize(frame.size.width/scale, frame.size.height/scale);
    [self setBoundsSize:viewSize];
    
    NSPoint origin;
    origin.x = center.x - viewSize.width * 0.5f;
    origin.y = center.y - viewSize.height * 0.5f;
    [self setBoundsOrigin:origin];
    [self setNeedsDisplay:YES];
}

- (void) setInitials:(NSMutableArray *)initials {
    NSLog(@"Setting Initials");
    [initialObjects release];
    initialObjects = initials;
    [initialObjects retain];

    for (ScenarioInitial *initial in initialObjects) {
        [self addInitialObject:initial];
    }

    [self autoScale:nil];
}

- (void) drawRect:(NSRect)dirtyRect {
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    if (shouldDrawLabels) {
        [self drawLabels];
    }
    [self drawGrid];
    [self drawDestinationConnectors];
    [self drawScenarioObjects];
}

- (void) drawLabels {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[NSFont fontWithName:@"Courier" size:10.0f/scale] forKey:NSFontAttributeName];

    for (ScenarioInitial *obj in initialObjects) {
        NSColor *color;
        switch (obj.owner) {
            case 0:
                color = [NSColor greenColor];
                break;
            case -1:
                color = [NSColor blueColor];
                break;
            default:
                color = [NSColor redColor];
                break;
        }
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
        
        NSPoint point = obj.position.point;
        point.y -= (obj.base.iconSize + 2.0f) / scale;
        point.x += (obj.base.iconSize + 2.0f) / scale;
        
        [obj.realName drawAtPoint:point withAttributes:attributes];
    }
}

- (void) drawGrid {
    static const CGFloat bigGridDistance = 32768.0f;
    static const CGFloat smallGridDistance = 4096.0f;
    static const CGFloat blueLineLimit = 1.0f/128.0f;

    NSRect rect = NSIntegralRect([self bounds]);
    CGFloat left = NSMinX(rect);
    CGFloat right = NSMaxX(rect);
    CGFloat top = NSMinY(rect);
    CGFloat bottom = NSMaxY(rect);

    left -= fmod(left, bigGridDistance) + bigGridDistance;
    right -= fmod(right, bigGridDistance) - bigGridDistance;
    top -= fmod(top, bigGridDistance) + bigGridDistance;
    bottom -= fmod(bottom, bigGridDistance) - bigGridDistance;

    NSBezierPath *greenPath = [NSBezierPath bezierPath];
    NSBezierPath *bluePath = [NSBezierPath bezierPath];
    [greenPath setLineWidth:2.0f/scale];
    [bluePath setLineWidth:1.0f/scale];

    for (CGFloat x = left; x <= right; x += smallGridDistance) {
        if (fabs(fmod(x, bigGridDistance)) <= 1.0f) {
            [greenPath moveToPoint:NSMakePoint(x, top)];
            [greenPath lineToPoint:NSMakePoint(x, bottom)];
        } else if (scale > blueLineLimit) {
            [bluePath moveToPoint:NSMakePoint(x, top)];
            [bluePath lineToPoint:NSMakePoint(x, bottom)];
        }
    }
    
    for (CGFloat y = top; y <= bottom; y += smallGridDistance) {
        if (fabs(fmod(y, bigGridDistance)) <= 1.0f) {
            [greenPath moveToPoint:NSMakePoint(left, y)];
            [greenPath lineToPoint:NSMakePoint(right, y)];
        } else if (scale > blueLineLimit) {
            [bluePath moveToPoint:NSMakePoint(left, y)];
            [bluePath lineToPoint:NSMakePoint(right, y)];
        }
    }

    [[NSColor blueColor] setStroke];
    [bluePath stroke];
    [[NSColor greenColor] setStroke];
    [greenPath stroke];
}

- (void) drawScenarioObjects {
    NSUInteger index = [initialsController selectionIndex];
    ScenarioInitial *selection = nil;
    if (index != NSNotFound) {
        selection = [initialObjects objectAtIndex:index];   
    }

    //Paint back to front
    for (ScenarioInitial *initial in [initialObjects reverseObjectEnumerator]) {
        BOOL shouldHighlight = (initial == selection);

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
        

        
        switch (initial.base.iconShape) {
            case IconShapeSquare:
                [self drawSquareOfSize:initial.base.iconSize * iconSizeScale
                                 color:iconColor
                               atPoint:initial.position.point
                           highlighted:shouldHighlight];
                break;
            case IconShapeFramedSquare:
                [self drawFramedSquareOfSize:initial.base.iconSize * iconSizeScale
                                       color:iconColor
                                     atPoint:initial.position.point
                                 highlighted:shouldHighlight];
                break;
            case IconShapeTriangle:
                [self drawTriangleOfSize:initial.base.iconSize * iconSizeScale
                                   color:iconColor
                                 atPoint:initial.position.point
                             highlighted:shouldHighlight];
                break;
            case IconShapePlus:
                [self drawPlusOfSize:initial.base.iconSize * iconSizeScale
                               color:iconColor
                             atPoint:initial.position.point
                         highlighted:shouldHighlight];
                break;
            case IconShapeDiamond:
                [self drawDiamondOfSize:initial.base.iconSize * iconSizeScale
                                  color:iconColor
                                atPoint:initial.position.point
                            highlighted:shouldHighlight];
                break;
            default:
                @throw @"Invalid icon shape.";
                break;
        }
    } 
}

- (void) drawDestinationConnectors {
    [[NSColor purpleColor] setStroke];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:2.0f/scale];
    
    for (ScenarioInitial *a in destinations) {
        for (ScenarioInitial *b in destinations) {
            if (a > b) {
                [path moveToPoint:a.position.point];
                [path lineToPoint:b.position.point];
            }
        }
    }
    [path stroke];
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
                  atPoint:(NSPoint)point
              highlighted:(BOOL)isHighlighted {
    [[NSColor yellowColor] setStroke];
    [color setFill];

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:selectionBorderThickness/scale];
    
    [path moveToPoint:NSMakePoint(0.5f, 0.5f)];
    [path lineToPoint:NSMakePoint(0.5f, -0.5f)];
    [path lineToPoint:NSMakePoint(-0.5f, -0.5f)];
    [path lineToPoint:NSMakePoint(-0.5f, 0.5f)];
    [path closePath];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:point.x yBy:point.y];
    [transform scaleBy:size/scale];
    [path transformUsingAffineTransform:transform];

    if (isHighlighted) {
        [path stroke];
    }
    [path fill];
}

- (void) drawFramedSquareOfSize:(CGFloat)size
                    color:(NSColor *)color
                  atPoint:(NSPoint)point
              highlighted:(BOOL)isHighlighted {
    CGFloat inverseScale = size/scale;
    NSRect rect = NSMakeRect(point.x - 0.5f * inverseScale, point.y - 0.5f * inverseScale, inverseScale, inverseScale);

    if (isHighlighted) {
        [[NSColor yellowColor] setFill];
        NSFrameRectWithWidth(NSInsetRect(rect, -selectionBorderThickness/scale/2.0f, -selectionBorderThickness/scale/2.0f), selectionBorderThickness/scale);
    }
    [color setFill];
    NSRectFill(rect);
    [[color blendedColorWithFraction:0.2f
                             ofColor:[NSColor blackColor]] setFill];
    NSFrameRectWithWidth(rect, 2.0f/scale);
}

- (void) drawPlusOfSize:(CGFloat)size
                  color:(NSColor *)color
                atPoint:(NSPoint)point
            highlighted:(BOOL)isHighlighted {
    static const CGFloat innerDist = 1.0f/6.0f;
    static const CGFloat outerDist = 0.5f;

    [[NSColor yellowColor] setStroke];
    [color setFill];

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:selectionBorderThickness/scale];

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

    if (isHighlighted) {
        [path stroke];
    }
    [path fill];
}

- (void) drawTriangleOfSize:(CGFloat)size
                      color:(NSColor *)color
                    atPoint:(NSPoint)point
                highlighted:(BOOL)isHighlighted {
    const CGFloat lengthAcross = sin(M_PI/3.0f);
    const CGFloat offset = tan(M_PI/6.0f)*0.5f;

    [[NSColor yellowColor] setStroke];
    [color setFill];

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:4.0f/scale];

    [path moveToPoint:NSMakePoint(-0.5f, offset)];
    [path lineToPoint:NSMakePoint(0.5f, offset)];
    [path lineToPoint:NSMakePoint(0.0f, -lengthAcross+offset)];
    [path closePath];
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:point.x yBy:point.y];
    [transform scaleBy:size/scale];
    [path transformUsingAffineTransform:transform];
    
    if (isHighlighted) {
        [path stroke];
    }
    [path fill];
}

- (void) drawDiamondOfSize:(CGFloat)size
                     color:(NSColor *)color
                   atPoint:(NSPoint)point
               highlighted:(BOOL)isHighlighted {
    static const CGFloat scaleVl = 0.5f;
    [[NSColor yellowColor] setStroke];
    [color setFill];

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineWidth:4.0f / scale];

    [path moveToPoint:NSMakePoint(0.0f, scaleVl)];//Top
    [path lineToPoint:NSMakePoint(scaleVl, 0.0f)];//Right
    [path lineToPoint:NSMakePoint(0.0f, -scaleVl)];//Bottom
    [path lineToPoint:NSMakePoint(-scaleVl, 0.0f)];//Left
    [path closePath];

    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:point.x yBy:point.y];
    [transform scaleBy:size/scale];
    [path transformUsingAffineTransform:transform];

    if (isHighlighted) {
        [path stroke];
    }
    [path fill];
}

- (void) dealloc {
    for (ScenarioInitial *initial in initialObjects) {
        [self stopObservingInitial:initial];
    }
    [initialObjects release];
    [destinations release];
    [clickedObject release];
    [super dealloc];
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification {
    ScenarioInitial *obj = [initialsController selection];
    if (obj != NSNoSelectionMarker) {
        NSRect bounds = [self bounds];
        XSPoint *position = [obj valueForKey:@"position"];
        if (!NSPointInRect(position.point, bounds)) {
            //Move the cursor if out of view
            center = position.point;
            [self updateTransform];
        }
    }
    [self setNeedsDisplay:YES];
}

- (void) addInitialObject:(ScenarioInitial *)object {
    if (object.base.attributes.isDestination) {
        [destinations addObject:object];
    }
    [self startObservingInitial:object];
    [self setNeedsDisplay:YES];
}

- (void) removeInitialObject:(ScenarioInitial *)object {
    [destinations removeObject:object];
    [self stopObservingInitial:object];
    [self setNeedsDisplay:YES];
}

- (void) magnifyWithEvent:(NSEvent *)event {
    scale *= [event magnification] + 1.0f;
    [self updateTransform];
}

- (void) scrollWheel:(NSEvent *)event {
    /*
     NSEvent.h defines
     enum {
         NSMouseEventSubtype             = 0,
         NSTabletPointEventSubtype       = 1,
         NSTabletProximityEventSubtype   = 2,
         NSTouchEventSubtype             = 3
     }
     From my observations scroll wheel events that originate from
     a mouse return 0 (NSMouseEventSubtype) as expected but if the event
     originates from a trackpad it returns 1 (NSTabletPointEventSubtype)
     this seems to be inconsistent
     */
    const short NSTrackpadEventSubtype = 1;

    short subtype = event.subtype;
    if (subtype == NSMouseEventSubtype) {
        //Mouse, so zoom
        float delta = event.deltaY + 1.0f;
        delta = MAX(delta, 0.75f);
        delta = MIN(delta, 1.33f);
        scale *= delta;
    } else if (subtype == NSTrackpadEventSubtype) {
        //Trackpad, so scroll
        center.x -= event.deltaX / scale;
        center.y += event.deltaY / scale;
    }
    [self updateTransform];
}

- (void) mouseDown:(NSEvent *)event {
    
    NSAssert(clickedObject == nil, @"clickedObject != nil");
    NSPoint clickPoint = [self convertPoint: event.locationInWindow fromView:nil];
    
    id selection = [initialsController selection];
    BOOL willChangeSelection = YES;
    if (selection != NSNoSelectionMarker) {
        XSPoint *point = [selection valueForKey:@"position"];
        NSRect selectedObjectRect = SquareRectWithCenterAndSize(point.point, [[selection valueForKeyPath:@"base.iconSize"] floatValue] * iconSizeScale);
        if (NSPointInRect(clickPoint, selectedObjectRect)) {
            clickedObject = selection;
            [clickedObject retain];
            willChangeSelection = NO;
        }
    }

    //Search for new selection
    if (willChangeSelection) {
        NSUInteger index = 0;
        for (ScenarioInitial *init in initialObjects) {
            NSPoint point = init.position.point;
            NSRect testRect = SquareRectWithCenterAndSize(point, init.base.iconSize * iconSizeScale / scale);
            if (NSPointInRect(clickPoint, testRect)) {
                clickedObject = init;
                [clickedObject retain];
                [initialsController setSelectionIndex:index];
                break;
            }
            index++;
        }
    }
}

- (void) mouseDragged:(NSEvent *)event {
    if (clickedObject != nil) {
        XSPoint *position = [clickedObject valueForKey:@"position"];
        if (!isDragging) {
            NSLog(@"Starting Drag.");
            NSLog(@"Pushing: %@", NSStringFromPoint(position.point));
            id undoTarget = [[[self window] undoManager] prepareWithInvocationTarget:self];
            [undoTarget changeKeyPath:@"position.point" ofObject:clickedObject toValue:[NSValue valueWithPoint:position.point]];
            isDragging = YES;
        }
        position.x += event.deltaX / scale;
        position.y -= event.deltaY / scale;
    } else {
        center.x -= event.deltaX / scale;
        center.y += event.deltaY / scale;
        [self updateTransform];
    }
    [self setNeedsDisplay:YES];
}

- (void) mouseUp:(NSEvent *)event {
    isDragging = NO;
    [clickedObject release];
    clickedObject = nil;
}

- (void) startObservingInitial:(ScenarioInitial *)initial {
    //Only used for refreshing
    [initial.position addObserver:self forKeyPath:@"point" options:NSKeyValueObservingOptionOld context:NULL];
    [initial addObserver:self forKeyPath:@"owner" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void) stopObservingInitial:(ScenarioInitial *)initial {
    [initial.position removeObserver:self forKeyPath:@"point"];
    [initial removeObserver:self forKeyPath:@"owner"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    [self setNeedsDisplay:YES];
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value {
    [object setValue:value forKeyPath:keyPath];
    [self setNeedsDisplay:YES];
}

@end
