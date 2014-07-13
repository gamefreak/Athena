//
//  ConditionEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 8/23/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ConditionEditor.h"
#import "ActionEditor.h"
#import "ConditionViewController.h"

#import "MainData.h"
#import "Scenario.h"
#import "Condition.h"

NSString *XSConditionParametersChanged = @"ConditionParametersChanged";

@interface ConditionEditor (Private)
- (void)insertObject:(Condition *)object inConditionsAtIndex:(NSUInteger)index;
- (void)replaceObjectInConditionsAtIndex:(NSUInteger)index withObject:(Condition *)object;
- (void)removeObjectFromConditionsAtIndex:(NSUInteger)index;
@end

@implementation ConditionEditor
@synthesize conditions;
@dynamic currentCondition, currentIndex, rowForDropDown;
- (id)initWithMainData:(MainData *)data_ scenario:(NSUInteger)scenario_ {
    self = [super initWithWindowNibName:@"ConditionEditor"];
    if (self) {
        data = [data_ retain];
        scenario = [[[data scenarios] objectAtIndex:scenario_] retain];
        conditions = [[scenario conditions] retain];
        editorControllers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unbind:@"currentIndex"];
    [data release];
    [scenario release];
    [conditions release];
    [editorControllers release];
    [lastSubeditor release];
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self bind:@"currentIndex" toObject:conditionsController withKeyPath:@"selectionIndex" options:nil];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(conditionParametersDidChange:) name:XSConditionParametersChanged object:nil];
    [nc postNotificationName:XSConditionParametersChanged object:nil];
}

- (NSString*) windowTitleForDocumentDisplayName:(NSString*)name {
    return [NSString stringWithFormat:@"%@—Conditions", name];
}

- (void)conditionParametersDidChange:(NSNotification *)note {
    [self willChangeValueForKey:@"hasSelection"];
    [self willChangeValueForKey:@"rowForDropDown"];
    int  row = [conditionsTable selectedRow];

    NSString *nib;
    if (row >= 0) {
        nib = [[conditions objectAtIndex:row] nibName];
    } else {
        nib = @"NoParameter";
    }

    ConditionViewController *controller = [[[ConditionViewController alloc] initWithNibName:nib bundle:nil] autorelease];
    [controller setConditionObj:[conditionsController selection]];

    NSView *newInnerView = [controller view];
    [newInnerView setFrame:[subeditorView frame]];
    if (lastSubeditor == nil) {
        [subeditorView addSubview:newInnerView];
    } else {
        [subeditorView replaceSubview:lastSubeditor with:newInnerView];
    }
    [lastSubeditor release];
    lastSubeditor = [newInnerView retain];
    [actionEditor setActions:[self currentActionsArray]];
    [[NSNotificationCenter defaultCenter] postNotificationName:XSActionParametersChanged object:nil];
    [self didChangeValueForKey:@"rowForDropDown"];
    [self didChangeValueForKey:@"hasSelection"];
}

- (Condition *)currentCondition {
    return currentCondition;
}

- (IBAction)addCondition:(id)sender {
    NSMenuItem *choice = [sender selectedItem];
    Condition *newCondition = [[[ConditionEditor classForMenuItem:choice] alloc] init];
    int count = [conditions count];
    [conditionsController addObject:newCondition];
    NSAssert(count != [conditions count], @"Length of conditions array unchanged %ul == %lul", count, [conditions count]);
    [newCondition release];
}

+ (Class)classForMenuItem:(NSMenuItem *)menuItem {
    return [Condition classForType:[menuItem tag]];
}

- (void)setRowForDropDown:(NSInteger)rowForDropDown {
    Class class = [Condition classForType:rowForDropDown];
    Condition *newCondition = [[[class alloc] init] autorelease];
    [[conditions objectAtIndex:[conditionsController selectionIndex]] copyValuesTo:newCondition];
    [self replaceObjectInConditionsAtIndex:[conditionsController selectionIndex] withObject:newCondition];
    [[NSNotificationCenter defaultCenter] postNotificationName:XSConditionParametersChanged object:nil];
}

- (NSInteger)rowForDropDown {
    if (![self hasSelection]) {
        return 0;
    }
    NSUInteger index = [conditionsController selectionIndex];
    Class currentClass = [[conditions objectAtIndex:index] class];
    return [Condition typeForClass:currentClass];
}

- (void)setCurrentCondition:(Condition *)currentCondition_ {
    [currentCondition release];
    currentCondition = currentCondition_;
    [currentCondition retain];
    [[NSNotificationCenter defaultCenter] postNotificationName:XSConditionParametersChanged object:nil];
}

- (NSUInteger)currentIndex {
    return [conditions indexOfObject:currentCondition];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    if (currentIndex != NSNotFound) {
        [self setCurrentCondition:[conditions objectAtIndex:currentIndex]];
    } else {
        [self setCurrentCondition:nil];
    }
}

- (NSMutableArray *)currentActionsArray {
    return [currentCondition actions];
}

+ (NSSet *)keyPathsForValuesAffectingCurrentIndex {
    return [NSSet setWithObjects:@"currentCondition", nil];
}

+ (NSSet *)keyPathsForValuesAffectingCurrentCondition {
    return [NSSet setWithObjects:@"currentIndex", nil];
}

+ (NSSet *)keyPathsForValuesAffectingCurrentActionsArray {
    return [NSSet setWithObjects:@"currentCondition", nil];
}

- (BOOL)hasSelection {
    return [[conditionsController selectedObjects] count] > 0;
}

- (void)insertObject:(Condition *)object inConditionsAtIndex:(NSUInteger)index {
    NSUndoManager *undo = [[[[self window] windowController] document] undoManager];
    [undo setActionName:@"Add Condition"];
    [[undo prepareWithInvocationTarget:self] removeObjectFromConditionsAtIndex:index];
    [conditions insertObject:object atIndex:index];
}

- (void)replaceObjectInConditionsAtIndex:(NSUInteger)index withObject:(Condition *)object {
    Condition *old = [conditions objectAtIndex:index];
    NSUndoManager *undo = [[[[self window] windowController] document] undoManager];
    [undo setActionName:@"Change Condition Type"];
    [[undo prepareWithInvocationTarget:self] replaceObjectInConditionsAtIndex:index withObject:old];
    [conditions replaceObjectAtIndex:index withObject:object];
}

- (void)removeObjectFromConditionsAtIndex:(NSUInteger)index {
     NSUndoManager *undo = [[[[self window] windowController] document] undoManager];
    [undo setActionName:@"Remove Condition"];
    [[undo prepareWithInvocationTarget:self] insertObject:[conditions objectAtIndex:index] atIndex:index];
    [conditions removeObjectAtIndex:index];
}
@end
