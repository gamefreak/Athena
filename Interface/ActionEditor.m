//
//  ActionEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 5/3/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ActionEditor.h"
#import "ObjectEditor.h"

@implementation ActionEditor
@synthesize actions;
- (id)init {
    self = [super init];
    if (self) {
        editorControllers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

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
                                                 name:@"ActionParametersChanged"
                                               object:nil];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    //Action selection changed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActionParametersChanged" object:nil];
}

- (void) actionParametersDidChange:(NSNotification *)notification {
    int row = [actionTable selectedRow];
    NSString *nib;
    if (row >= 0) {
        nib = [[actions objectAtIndex:row] nibName];
    } else {
        nib = @"NoAction";
    }
//[[actionTable selection] nibName];
    
    NSViewController *controller;
    controller = [editorControllers objectForKey:nib];
    if (controller == nil) {
        NSLog(@"Loading new nib %@", nib);
        controller = [[NSViewController alloc] initWithNibName:nib bundle:nil];
        [editorControllers setObject:controller forKey:nib];
        [editorControllers autorelease];
    }
//    [[controller view] setFrame:[innerEditorView frame]];
    NSView *newInnerView = [controller view];
    [newInnerView setFrame:[innerEditorView frame]];
    [innerEditorView replaceSubview:lastInnerView with:newInnerView];
//    [[innerEditorView superview] replaceSubview:innerEditorView with:[controller view]];
    [lastInnerView release];
    lastInnerView = [newInnerView retain];
}
@end
