//
//  ActionEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 5/3/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ActionEditor.h"
#import "ObjectEditor.h"
#import "ActionViewController.h"
#import "Action.h"
#import "AlterActions.h"

const int regularActionOffset = 2;
const int regularActionCount = 24;
const int alterActionOffset = 28;//regularActionOffset + regularActionCount + 2
const int alterActionCount = 23;

NSString *XSActionParametersChanged = @"ActionParametersChanged";


@interface ActionEditor (Private)
- (void)insertObject:(Action *)object inActionsAtIndex:(NSUInteger)index;
- (void)replaceObjectInActionsAtIndex:(NSUInteger)index withObject:(Action *)object;
- (void)removeObjectFromActionsAtIndex:(NSUInteger)index;
@end

@implementation ActionEditor
@synthesize actions;
@dynamic rowForDropDown;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [editorControllers release];
    [super dealloc];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    editorControllers = [[NSMutableDictionary alloc] init];
    [[[self view] superview] setFrameSize:actionsSize];
    [[self view] setFrameSize:actionsSize];
//    [[[self view] superview] setFrameSize:actionsSize];
    [[[self view] superview] setFrameOrigin:NSZeroPoint];
    [targetView addSubview:[self view]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionParametersDidChange:)
                                                 name:XSActionParametersChanged
                                               object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:XSActionParametersChanged object:nil];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    //Action selection changed
    [[NSNotificationCenter defaultCenter] postNotificationName:XSActionParametersChanged object:nil];
}

- (void) actionParametersDidChange:(NSNotification *)notification {
    [self willChangeValueForKey:@"hasSelection"];
    [self willChangeValueForKey:@"rowForDropDown"];
    int row = [actionTable selectedRow];
    
    NSString *nib;
    if (row >= 0) {
        nib = [[actions objectAtIndex:row] nibName];
    } else {
        nib = @"NoAction";
    }

    ActionViewController *controller;
    controller = [editorControllers objectForKey:nib];
    if (controller == nil) {
        NSLog(@"Loading new nib %@", nib);
        controller = [[ActionViewController alloc] initWithNibName:nib bundle:nil];

        [editorControllers setObject:controller forKey:nib];
        [controller autorelease];
    }

    [controller setActionObj:[actionsArrayController selection]];

    NSView *newInnerView = [controller view];
    //Resize and embed the view
    [newInnerView setFrame:[innerEditorView frame]];
    //This is split up because the initial replacement involves nil (and that doesn't work)
    if (lastInnerView == nil) {
        [innerEditorView addSubview:newInnerView];
    } else {
        [innerEditorView replaceSubview:lastInnerView with:newInnerView];
    }
//    [[innerEditorView superview] replaceSubview:innerEditorView with:[controller view]];
    [newInnerView retain];
    [lastInnerView release];
    lastInnerView = newInnerView;
    [self didChangeValueForKey:@"rowForDropDown"];
    [self didChangeValueForKey:@"hasSelection"];
}

- (IBAction)addAction:(id)sender {
    NSMenuItem *choice = [sender selectedItem];
    Action *newAction = [[[ActionEditor classForMenuItem:choice] alloc] init];
    int count = [actions count];
    [actionsArrayController addObject:newAction];
    NSAssert(count != [actions count], @"Length of actions array unchanged %ul == %ul", count, [actions count]);
    [newAction release];
}

- (void)insertObject:(Action *)object inActionsAtIndex:(NSUInteger)index {
    NSUndoManager *undo = [[[[[self view] window] windowController] document] undoManager];
    [undo setActionName:@"Add Action"];
    [[undo prepareWithInvocationTarget:self] removeObjectFromActionsAtIndex:index];
    [actions insertObject:object atIndex:index];
}

- (void)replaceObjectInActionsAtIndex:(NSUInteger)index withObject:(Action *)action {
    //This should only be called when changing action types.
    Action *old = [actions objectAtIndex:index];
    NSUndoManager *undo = [[[[[self view] window] windowController] document] undoManager];
    [undo setActionName:@"Change Action Type"];
    [[undo prepareWithInvocationTarget:self] replaceObjectInActionsAtIndex:index withObject:old];
    [actions replaceObjectAtIndex:index withObject:action];
}

- (void)removeObjectFromActionsAtIndex:(NSUInteger)index {
    NSUndoManager *undo = [[[[[self view] window] windowController] document] undoManager];
    [undo setActionName:@"Remove Action"];
    [[undo prepareWithInvocationTarget:self] insertObject:[actions objectAtIndex:index] inActionsAtIndex:index];
    [actions removeObjectAtIndex:index];
}

+ (Class)classForMenuItem:(NSMenuItem *)menuItem {
    Class class;
    if ([[menuItem title] hasPrefix:@"Alter"]) {
        class = [AlterAction classForAlterType:[menuItem tag]];
    } else {
        class = [Action classForType:[menuItem tag]];
    }
    return class;
}

- (NSInteger)rowForDropDown {
    if (![self hasSelection]) {
        return regularActionOffset + NoActionType;
    }

    NSUInteger index = [actionsArrayController selectionIndex];
    Class currentActionClass = [[actions objectAtIndex:index] class];

    BOOL isAlterType = [currentActionClass isSubclassOfClass:[AlterAction class]];

    if (isAlterType) {
        return alterActionOffset + [AlterAction alterTypeForClass:currentActionClass];
    } else {
        return regularActionOffset + [Action typeForClass:currentActionClass];
    }
}

- (void)setRowForDropDown:(NSInteger)rowForDropDown {
    Class class;
    if (alterActionOffset <= rowForDropDown) {
        class = [AlterAction classForAlterType:rowForDropDown - alterActionOffset];
    } else {
        class = [Action classForType:rowForDropDown - regularActionOffset];
    }
    Action *newAction = [[[class alloc] init] autorelease];
    [[actions objectAtIndex:[actionsArrayController selectionIndex]] copyValuesTo:newAction];
    [self replaceObjectInActionsAtIndex:[actionsArrayController selectionIndex] withObject:newAction];
    [[NSNotificationCenter defaultCenter] postNotificationName:XSActionParametersChanged object:nil];
}

- (BOOL)hasSelection {
    return [[actionsArrayController selectedObjects] count] > 0;
}
@end