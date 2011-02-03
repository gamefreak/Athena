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

    CGFloat scale;
    NSPoint center;

    ScenarioInitial *clickedObject;
}
- (IBAction) autoScale:(id)sender;
- (IBAction) zoomIn:(id)sender;
- (IBAction) zoomOut:(id)sender;
- (void) updateTransform;

- (void) setInitials:(NSMutableArray *)initials;

- (void) drawGrid;
- (void) drawDestinationConnectors;
- (void) drawScenarioObjects;

- (void) drawSquareOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;
- (void) drawFramedSquareOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;
- (void) drawPlusOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;
- (void) drawTriangleOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;
- (void) drawDiamondOfSize:(CGFloat)size color:(NSColor *)color atPoint:(NSPoint)point highlighted:(BOOL)isHighlighted;

- (NSRect) calculateScenariosBounds;

- (void) addInitialObject:(ScenarioInitial *)object;
- (void) removeInitialObject:(ScenarioInitial *)object;
@end
