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
@dynamic selection;
@dynamic selectionIndex;

- (id)initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"ObjectEditor"];
    if (self) {
        data = [_data retain];
        objects = [[data mutableArrayValueForKey:@"objects"] retain];
        isEditor = YES;
    }
    return self;
}

- (id) initAsPickerWithData:(MainData *)_data
                 forDevices:(BOOL)forDevices {
    self = [self initWithMainData:_data];
    if (self) {
        isEditor = NO;
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

    assert(objectsController != nil);
    [self bind:@"selectionIndex" toObject:objectsController withKeyPath:@"selectionIndex" options:nil];
}

- (void)dealloc {
    [data release];
    [objects release];
    [selection release];
    [self unbind:@"selectionIndex"];
    [super dealloc];
}

- (BaseObject *) selection {
    return selection;
}

- (void) setSelection:(BaseObject *)newSelection {
    [selection release];
    selection = newSelection;
    [selection retain];
    [objectsController setSelectionIndex:selection.objectIndex];
    [objectsTable scrollRowToVisible:selection.objectIndex];
}

- (NSUInteger) selectionIndex {
    return [objects indexOfObjectIdenticalTo:selection];
}

- (void) setSelectionIndex:(NSUInteger)index {
    self.selection = [[data objects] objectAtIndex:index];
}

+ (NSSet *) keyPathsForValuesAffectingSelectionIndex {
    return [NSSet setWithObject:@"selection"];
}

+ (NSSet *) keyPathsForValuesAffectingSelection {
    return [NSSet setWithObject:@"selectionIndex"];
}

@end
