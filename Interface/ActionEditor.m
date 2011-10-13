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
@dynamic tagForDropDown;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void) awakeFromNib {
    [super awakeFromNib];
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
    [self willChangeValueForKey:@"tagForDropDown"];
    int row = [actionTable selectedRow];

    NSString *nib;
    if (row >= 0) {
        nib = [[actions objectAtIndex:row] nibName];
    } else {
        nib = @"NoAction";
    }

    ActionViewController *controller = [[[ActionViewController alloc] initWithNibName:nib bundle:nil] autorelease];
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
    [self didChangeValueForKey:@"tagForDropDown"];
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
        class = [AlterAction classForAlterType:[menuItem tag] - 100];
    } else {
        //I should explain this
        class = [Action classForType:[menuItem tag]];
    }
    return class;
}

- (NSInteger)tagForDropDown {
    if (![self hasSelection]) {
        return NoActionType;
    }
    NSUInteger index = [actionsArrayController selectionIndex];
    Class currentActionClass = [[actions objectAtIndex:index] class];
    BOOL isAlterType = [currentActionClass isSubclassOfClass:[AlterAction class]];
    if (isAlterType) {
        return [AlterAction alterTypeForClass:currentActionClass] + 100;
    } else {
        return [Action typeForClass:currentActionClass];
    }
}

- (void)setTagForDropDown:(NSInteger)tagForDropDown {
    Class class;
    if (tagForDropDown > 100) {
        class = [AlterAction classForAlterType:tagForDropDown - 100];
    } else {
        class = [Action classForType:tagForDropDown];
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