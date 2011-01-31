//
//  ScenarioInitialView.h
//  Athena
//
//  Created by Scott McClaugherty on 1/30/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ScenarioInitialView : NSView {
    NSMutableArray *initialObjects;
    CGFloat scale;
    NSPoint center;
    NSAffineTransform *viewTransform;
}
- (IBAction) autoScale:(id)sender;
- (IBAction) zoomIn:(id)sender;
- (IBAction) zoomOut:(id)sender;
- (void) updateTransform;
- (void) setInitials:(NSMutableArray *)initials;
- (void) drawSquareOfSize:(NSInteger)size ofColor:(NSColor *)color atPoint:(NSPoint)point;
- (NSRect) calculateScenariosBounds;
@end
