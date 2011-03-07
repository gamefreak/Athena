//
//  WeaponViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 3/6/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "WeaponViewController.h"
#import "AthenaDocument.h"
#import "ObjectEditor.h"
#import "BaseObject.h"

@implementation WeaponViewController
@synthesize weaponTitle;

- (void) awakeFromNib {
    [super awakeFromNib];
    [[self view] setFrame:[targetView bounds]];
    [targetView addSubview:[self view]];
}

- (void) dealloc {
    [weaponTitle release];
    [super dealloc];
}

- (IBAction) openObjectPicker:(id)sender {
    ObjectEditor *editor = [[ObjectEditor alloc]
                            initAsPickerWithData:[[[[self view] window] document] data]
                            forDevices:YES];
    [[[[self view] window] document] addWindowController:editor];
    [editor showWindow:sender];

    [editor setSelection:weapon.device];//So we don't lose the current selection
    [weapon bind:@"device" toObject:editor withKeyPath:@"selection" options:nil];
    [editor release];
}

- (IBAction) removeWeapon:(id)sender {
    weapon.device = nil;
}

+ (NSSet *) keyPathsForValuesAffectingWeaponTitle {
    return [NSSet setWithObject:@"weapon.device"];
}
@end
