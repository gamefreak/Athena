//
//  ObjectEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 2/16/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData;
@class BaseObject;
@class FlagMenuPopulator;
@class WeaponViewController;

@interface ObjectEditor : NSWindowController {
    MainData *data;
    NSMutableArray *objects;
    IBOutlet NSArrayController *objectsController;
    IBOutlet NSTableView *objectsTable;

    IBOutlet FlagMenuPopulator *attributesPopulator;
    IBOutlet FlagMenuPopulator *buildFlagsPopulator;
    IBOutlet FlagMenuPopulator *orderFlagsPopulator;

    IBOutlet WeaponViewController *pulseViewController;
    IBOutlet WeaponViewController *beamViewController;
    IBOutlet WeaponViewController *specialViewController;

    BOOL isEditor;
    //YES=show only devices
    //NO =inverse
    //Only applies if isEditor == YES
    BOOL showDevices;
    BaseObject *selection;
}
@property (readwrite, retain) BaseObject *selection;
@property (readwrite, assign) NSUInteger selectionIndex;

- (id) initWithMainData:(MainData *)data;
- (id) initAsPickerWithData:(MainData *)data forDevices:(BOOL)forDevices;

- (IBAction) calculateWarpOutDistance:(id)sender;
@end
