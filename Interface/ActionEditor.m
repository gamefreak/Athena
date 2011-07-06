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

@implementation ActionEditor
@synthesize actions;

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
                                                 name:@"ActionParametersChanged"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActionParametersChanged" object:nil];
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
    [lastInnerView release];
    lastInnerView = [newInnerView retain];
}
@end
