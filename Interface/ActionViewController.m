//
//  ActionViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 7/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ActionViewController.h"
#import "Action.h"
#import "AlterActions.h"
#import "BaseObject.h"
#import "ObjectEditor.h"
#import "AthenaDocument.h"

@implementation ActionViewController
@synthesize actionObj;
@dynamic type, ref;
- (void)dealloc {
    [actionObj release];
    [super dealloc];
}

//For CreateObjectAction
- (IBAction)openObjectPicker:(id)sender {
    AthenaDocument *document = [[[[self view] window] windowController] document];
    MainData *data = [document data];
    ObjectEditor *editor = [[ObjectEditor alloc]
                            initAsPickerWithData:data
                            forDevices:NO];
    [document addWindowController:editor];
    [editor showWindow:sender];
    [editor setSelection:[actionObj valueForKeyPath:@"baseType.object"]];
    [self bind:@"type" toObject:editor withKeyPath:@"objectsController.selection" options:nil];
    [editor release];
}

- (BaseObject *)type {
    return [actionObj valueForKeyPath:@"baseType.object"];
}

-  (void)setType:(BaseObject *)type {
    [actionObj setValue:[type valueForKey:@"index"] forKeyPath:@"baseType"];
}

//For alter actions
- (IBAction)openObjectPicker2:(id)sender {
    AthenaDocument *document = [[[[self view] window] windowController] document];
    MainData *data = [document data];
    BOOL forDevices = [[actionObj class] isSubclassOfClass:[AlterActionIDRefClass class]];
    ObjectEditor *editor = [[ObjectEditor alloc] initAsPickerWithData:data forDevices:forDevices];
    [document addWindowController:editor];
    [editor showWindow:sender];
    [editor setSelection:[actionObj valueForKeyPath:@"IDRef.object"]];
    [self bind:@"ref" toObject:editor withKeyPath:@"objectsController.selection" options:nil];
    [editor release];
}

- (BaseObject *)ref {
    return [actionObj valueForKeyPath:@"IDRef.object"];
}

- (void)setRef:(BaseObject *)ref {
    [actionObj setValue:[ref valueForKey:@"index"] forKey:@"IDRef"];
}
@end
