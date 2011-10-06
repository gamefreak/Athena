//
//  ConditionEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 8/23/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *XSConditionParametersChanged;

@class MainData, Scenario, Condition;
@class ActionEditor;

@interface ConditionEditor : NSWindowController {
    MainData *data;
    Scenario *scenario;
    NSMutableArray *conditions;
    Condition *currentCondition;

    IBOutlet ActionEditor *actionEditor;
    IBOutlet NSArrayController *conditionsController;
    IBOutlet NSView *subeditorView;
    NSView *lastSubeditor;
    IBOutlet NSTableView *conditionsTable;
    NSMutableDictionary *editorControllers;
    
    IBOutlet NSMenu *conditionTypeMenu;
}
@property (readwrite, retain) NSMutableArray *conditions;
@property (readwrite, retain) Condition *currentCondition;
@property (readwrite, assign) NSUInteger currentIndex;
- (id)initWithMainData:(MainData *)data scenario:(NSUInteger)scenario;
- (NSMutableArray *)currentActionsArray;
- (void)conditionParametersDidChange:(NSNotification *)note;
- (IBAction)addCondition:(id)sender;
+ (Class)classForMenuItem:(NSMenuItem *)menuItem;
@end
