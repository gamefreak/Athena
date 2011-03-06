//
//  ObjectEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 2/16/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData;
@class WeaponViewController;

@interface ObjectEditor : NSWindowController {
    MainData *data;
    NSMutableArray *objects;
    IBOutlet NSArrayController *objectsController;

    IBOutlet WeaponViewController *pulseViewController;
    IBOutlet WeaponViewController *beamViewController;
    IBOutlet WeaponViewController *specialViewController;
}
- (id)initWithMainData:(MainData *)data;
@end
