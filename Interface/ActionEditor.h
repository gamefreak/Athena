//
//  ActionEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 5/3/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ActionEditor : NSViewController <NSTableViewDelegate> {
    IBOutlet NSView *targetView;
    IBOutlet NSTableView *actionTable;
    IBOutlet NSArrayController *actionsArrayController;
    
    IBOutlet NSView *innerEditorView;
    NSView *lastInnerView;
    
    NSMutableArray *actions;
    NSMutableDictionary *editorControllers;
}
@property (readwrite, retain) NSMutableArray *actions;
- (void) actionParametersDidChange:(NSNotification *)notification;
@end
