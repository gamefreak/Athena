//
//  ActionEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 5/3/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *XSActionParametersChanged;

@class ActionViewController;

@interface ActionEditor : NSViewController <NSTableViewDelegate> {
    IBOutlet NSView *targetView;
    IBOutlet NSTableView *actionTable;
    IBOutlet NSArrayController *actionsArrayController;

    IBOutlet NSView *innerEditorView;
    NSView *lastInnerView;
    NSString *lastNib;
    ActionViewController *lastViewController;

    NSMutableArray *actions;

    IBOutlet NSMenu *actionTypeMenu;
    BOOL runInit;
}
@property (readwrite, retain) NSMutableArray *actions;
@property (readwrite, assign) NSInteger tagForDropDown;
@property (readwrite, retain) NSView *lastInnerView;
@property (readwrite, retain) NSString *lastNib;
@property (readwrite, retain) ActionViewController *lastViewController;
- (void) actionParametersDidChange:(NSNotification *)notification;
- (IBAction)addAction:(id)sender;
+ (Class)classForMenuItem:(NSMenuItem *)menuItem;
- (BOOL)hasSelection;
@end
