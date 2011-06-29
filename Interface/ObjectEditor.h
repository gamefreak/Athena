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
@class ActionEditor;

typedef enum {
    ActivateTab = 0,
    ArriveTab = 1,
    CollideTab = 2,
    CreateTab = 3,
    ExpireTab = 4,
    DestroyTab = 5,
} ActionTab;


//The border size around the subviews
static const NSSize borderSize = {.width = 261+50, .height = 25};
static const NSSize standardSize = {.width = 725, .height = 394};
//static const NSSize actionsSize = {.width = 761, .height = 419+31};//the plus 31 if for the switcher
static const NSSize actionsSize = {.width = 761, .height = 419};

static const float actionsVerticalBuffer = 56+31;

@interface ObjectEditor : NSWindowController <NSTabViewDelegate> {
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

    ActionTab currentActionTab;
    IBOutlet ActionEditor *actionEditor;
    
    BOOL isEditor;
    //YES=show only devices
    //NO =inverse
    //Only applies if isEditor == YES
    BOOL showDevices;
    BaseObject *selection;
}
@property (readwrite, retain) BaseObject *selection;
@property (readwrite, assign) NSUInteger selectionIndex;
@property (readwrite, assign) ActionTab currentActionTab;
@property (readonly) NSString *actionTypeKey;
@property (readonly) NSMutableArray *currentActionsArray;

- (id) initWithMainData:(MainData *)data;
- (id) initAsPickerWithData:(MainData *)data forDevices:(BOOL)forDevices;

- (IBAction) calculateWarpOutDistance:(id)sender;
@end
