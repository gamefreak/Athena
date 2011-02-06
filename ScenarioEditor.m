//
//  ScenarioEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ScenarioEditor.h"
#import "MainData.h"
#import "InitialEditor.h"
#import "TextEditor.h"

@implementation ScenarioEditor
- (id) initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"ScenarioEditor"];
    if (self) {
        data = _data;
        [data retain];
    }
    return self;
}

- (void) awakeFromNib {
    [scoreStringTable setTarget:self];
    [scoreStringTable setDoubleAction:@selector(scoreStringTableClick:)];
}

- (IBAction) openInitialEditor:(id)sender {
    InitialEditor *editor = [[InitialEditor alloc] initWithMainData:data scenario:[scenarioArray selectionIndex]];
    [[self document] addWindowController:editor];
    [editor showWindow:self];
    [editor release];
}

- (IBAction) openPrologueEditor:(id)sender {
    NSString *text = [[scenarioArray selection] valueForKey:@"prologue"];
    TextEditor *editor = [[TextEditor alloc] initWithTitle:@"Prologue" text:text];
    [[self document] addWindowController:editor];
    [editor showWindow:self];
    [editor release];
}

- (IBAction) openEpilogueEditor:(id)sender {
    NSString *text = [[scenarioArray selection] valueForKey:@"epilogue"];
    TextEditor *editor = [[TextEditor alloc] initWithTitle:@"Epilogue" text:text];
    [[self document] addWindowController:editor];
    [editor showWindow:self];
    [editor release];
}

- (IBAction) scoreStringTableClick:(id)sender {
    NSUInteger row = [scoreStringTable clickedRow];
    if (row == -1) {
        NSMutableString *newEntry = [scoreStringController newObject];
        [scoreStringController addObject:newEntry];
        row = [[scoreStringController arrangedObjects] indexOfObjectIdenticalTo:newEntry];
        [newEntry release];
    }
    [scoreStringTable editColumn:0 row:row withEvent:nil select:NO];
}

- (void) dealloc {
    [data release];
    [super dealloc];
}
@end
