//
//  ObjectEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 2/16/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ObjectEditor.h"
#import "MainData.h"
#import "BaseObject.h"

#import "WeaponViewController.h"

@implementation ObjectEditor
- (id)initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"ObjectEditor"];
    if (self) {
        data = [_data retain];
        objects = [[data mutableArrayValueForKey:@"objects"] retain];
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [pulseViewController setWeaponTitle:@"Pulse"];
    [pulseViewController bind:@"weapon" toObject:objectsController withKeyPath:@"selection.weapons.pulse" options:nil];
    [beamViewController setWeaponTitle:@"Beam"];
    [beamViewController bind:@"weapon" toObject:objectsController withKeyPath:@"selection.weapons.beam" options:nil];
    [specialViewController setWeaponTitle:@"Special"];
    [specialViewController bind:@"weapon" toObject:objectsController withKeyPath:@"selection.weapons.special" options:nil];
}

- (void)dealloc {
    [data release];
    [objects release];
    [super dealloc];
}
@end
