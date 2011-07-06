//
//  ActionViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 7/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ActionViewController.h"
#import "Action.h"
#import "BaseObject.h"
#import "ObjectEditor.h"
@implementation ActionViewController
@synthesize action;
@dynamic type;
- (void)dealloc {
    [action release];
    [super dealloc];
}

- (IBAction)openObjectPicker:(id)sender {
    MainData *data = [[[[self view] window] document] data];
    ObjectEditor *editor = [[ObjectEditor alloc]
                            initAsPickerWithData:data
                            forDevices:NO];
    [[[[self view] window] document] addWindowController:editor];
    [editor showWindow:sender];
    [editor setSelection:[action valueForKeyPath:@"baseType.object"]];
    [self bind:@"type" toObject:editor withKeyPath:@"objectsController.selection" options:nil];
    [editor release];
}


- (BaseObject *)type {
    return [action valueForKeyPath:@"baseType.object"];
}

-  (void)setType:(BaseObject *)type {
    [action setValue:[type valueForKey:@"index"] forKeyPath:@"baseType"];
}
@end
