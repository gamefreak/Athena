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
#import "BaseObjectFlags.h"
#import "FlagMenuPopulator.h"

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
@synthesize lastInnerView, lastNib, lastViewController;

- (void) dealloc {
    [lastNib release];
    [lastViewController release];
    [lastInnerView release];
    [actions release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    if (!runInit) {
        runInit = YES;
        [targetView addSubview:[self view]];
        //[[self view] setFrameSize:[targetView bounds].size];
        [[self view] setFrame:[targetView bounds]];

        [inclusiveFilterPopulator setRepresentedClass:[BaseObjectAttributes class] andPathComponent:@"inclusiveFilter"];
        [exclusiveFilterPopulator setRepresentedClass:[BaseObjectAttributes class] andPathComponent:@"exclusiveFilter"];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(actionParametersDidChange:)
                   name:XSActionParametersChanged
                 object:nil];
        [nc postNotificationName:XSActionParametersChanged object:nil];

    }
}

- (NSString*) windowTitleForDocumentDisplayName:(NSString*)name {
    return [NSString stringWithFormat:@"%@—Actions", name];
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
    if ([nib isEqualToString:lastNib]) {
        [lastViewController setActionObj:[actionsArrayController selection]];
        goto skip;
    }
    ActionViewController *controller = [[[ActionViewController alloc] initWithNibName:nib bundle:nil] autorelease];
    [controller setActionObj:[actionsArrayController selection]];

    NSView *newInnerView = [controller view];
    //Embed and resize the view
    //This is split up because the initial replacement involves nil (and that doesn't work)
    if (lastInnerView == nil) {
        [innerEditorView addSubview:newInnerView];
    } else {
        [innerEditorView replaceSubview:lastInnerView with:newInnerView];
    }

    [newInnerView setFrame:[innerEditorView bounds]];
    [self setLastInnerView:newInnerView];
    [self setLastViewController:controller];
    [self setLastNib:nib];
skip:
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
    if (tagForDropDown >= 100) {
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