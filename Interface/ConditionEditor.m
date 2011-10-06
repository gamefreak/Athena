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

@implementation ConditionEditor
@synthesize conditions;
@dynamic currentCondition, currentIndex;
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

- (void)conditionParametersDidChange:(NSNotification *)note {
    int  row = [conditionsTable selectedRow];

    NSString *nib;
    if (row >= 0) {
        nib = [[conditions objectAtIndex:row] nibName];
    } else {
        nib = @"NoParameter";
    }

    ConditionViewController *controller;
    controller = [editorControllers objectForKey:nib];
    if (controller == nil) {
        NSLog(@"Loading new nib %@", nib);
        controller = [[ConditionViewController alloc] initWithNibName:nib bundle:nil];
        [editorControllers setObject:controller forKey:nib];
        [controller autorelease];
    }

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
}

- (Condition *)currentCondition {
    return currentCondition;
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
@end
