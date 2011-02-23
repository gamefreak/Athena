//
//  ScenarioInitialView.h
//  Athena
//
//  Created by Scott McClaugherty on 1/30/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ScenarioInitial;

@interface ScenarioInitialView : NSView <NSTableViewDelegate>{
    NSMutableArray *initialObjects;
    NSMutableSet *destinations;
    IBOutlet NSArrayController *initialsController;
    BOOL shouldDrawLabels;

    CGFloat scale;
    NSPoint center;

    ScenarioInitial *clickedObject;
    BOOL isDragging;
}
@property (readonly) BOOL isDragging;

- (IBAction) autoScale:(id)sender;
- (IBAction) zoomIn:(id)sender;
- (IBAction) zoomOut:(id)sender;
- (IBAction) redraw:(id)sender;
- (void) updateTransform;

- (void) setInitials:(NSMutableArray *)initials;

- (void) drawLabels;
- (void) drawGrid;
- (void) drawDestinationConnectors;
- (void) drawScenarioObjects;

- (void) drawSquareOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;
- (void) drawFramedSquareOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;
- (void) drawPlusOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;
- (void) drawTriangleOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;
- (void) drawDiamondOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;

- (NSRect) calculateScenariosBounds;

- (void) startObservingInitial:(ScenarioInitial *)initial;
- (void) stopObservingInitial:(ScenarioInitial *)initial;
- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value;
- (void) addInitialObject:(ScenarioInitial *)object;
- (void) removeInitialObject:(ScenarioInitial *)object;

@end
