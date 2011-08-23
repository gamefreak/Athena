//
//  ConditionEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 8/23/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ConditionEditor.h"
#import "ActionEditor.h"

#import "MainData.h"
#import "Scenario.h"
#import "Condition.h"

@implementation ConditionEditor
@synthesize conditions;
@dynamic currentCondition, currentIndex;
- (id)initWithMainData:(MainData *)data_ scenario:(NSUInteger)scenario_ {
    self = [super initWithWindowNibName:@"ConditionEditor"];
    if (self) {
        data = [data_ retain];
        scenario = [[[data scenarios] objectAtIndex:scenario_] retain];
        conditions = [[scenario conditions] retain];
    }
    return self;
}

- (void)dealloc {
    [data release];
    [scenario release];
    [conditions release];
    [actionEditor unbind:@"actions"];
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [actionEditor bind:@"actions" toObject:self withKeyPath:@"currentActionsArray" options:nil];
    [self bind:@"currentIndex" toObject:conditionsController withKeyPath:@"selectionIndex" options:nil];
}

- (Condition *)currentCondition {
    return currentCondition;
}

- (void)setCurrentCondition:(Condition *)currentCondition_ {
    [currentCondition release];
    currentCondition = currentCondition_;
    [currentCondition retain];
    [[NSNotificationCenter defaultCenter] postNotificationName:XSActionParametersChanged object:nil];
}

- (NSUInteger)currentIndex {
    return [conditions indexOfObject:currentCondition];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    [self setCurrentCondition:[conditions objectAtIndex:currentIndex]];
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
