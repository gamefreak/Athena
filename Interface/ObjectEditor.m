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

#import "FlagMenuPopulator.h"
#import "WeaponViewController.h"
#import "ActionEditor.h"

@implementation ObjectEditor
@dynamic selection;
@dynamic selectionIndex;
@dynamic actionTypeKey;
@dynamic currentActionTab;

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
        showDevices = forDevices;
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];

    [attributesPopulator setRepresentedClass:[BaseObjectAttributes class] andPathComponent:@"attributes"];
    [buildFlagsPopulator setRepresentedClass:[BaseObjectBuildFlags class] andPathComponent:@"buildFlags"];
    [orderFlagsPopulator setRepresentedClass:[BaseObjectOrderFlags class] andPathComponent:@"orderFlags"];
    
    [pulseViewController setWeaponTitle:@"Pulse"];
    [pulseViewController bind:@"weapon" toObject:objectsController withKeyPath:@"selection.weapons.pulse" options:nil];

    [beamViewController setWeaponTitle:@"Beam"];
    [beamViewController bind:@"weapon" toObject:objectsController withKeyPath:@"selection.weapons.beam" options:nil];

    [specialViewController setWeaponTitle:@"Special"];
    [specialViewController bind:@"weapon" toObject:objectsController withKeyPath:@"selection.weapons.special" options:nil];
    
    [actionEditor bind:@"actions" toObject:self withKeyPath:@"currentActionsArray" options:nil];
    
    assert(objectsController != nil);
    
    [self bind:@"selectionIndex" toObject:objectsController withKeyPath:@"selectionIndex" options:nil];
    if (!isEditor) {
        if (showDevices) {
            [objectsController setFilterPredicate:[NSPredicate predicateWithFormat:@"((attributes.isBeam = NO) AND (attributes.shapeFromDirection = NO) AND (attributes.isSelfAnimated = NO))"]];
        } else {
            [objectsController setFilterPredicate:[NSPredicate predicateWithFormat:@"NOT ((attributes.isBeam = NO) AND (attributes.shapeFromDirection = NO) AND (attributes.isSelfAnimated = NO))"]];
        }
    }
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

    [objectsController setSelectedObjects:[NSArray arrayWithObject:selection]];
    [objectsTable scrollRowToVisible:[objectsController selectionIndex]];
}

- (NSUInteger) selectionIndex {
    return [objects indexOfObjectIdenticalTo:selection];
}

- (void) setSelectionIndex:(NSUInteger)index {
    if (index != NSNotFound) {
        id proxiedObject = [[objectsController arrangedObjects] objectAtIndex:index];
        self.selection = [[data objects] objectAtIndex:[proxiedObject objectIndex]];
    } else {
        self.selection = nil;
    }
}

- (NSString *) actionTypeKey {
    switch (currentActionTab) {
        case ActivateTab:
            return @"activate";
            break;
        case ArriveTab:
            return @"arrive";
            break;
        case CollideTab:
            return @"collide";
            break;
        case CreateTab:
            return @"create";
            break;
        case ExpireTab:
            return @"expire";
            break;
        case DestroyTab:
            return @"destroy";            
            break;
        default:
            break;
    }
}

- (NSMutableArray *) currentActionsArray {
    return [[[[objectsController selection] valueForKey:@"actions"] valueForKey:[self actionTypeKey]] valueForKey:@"actions"];
}

+ (NSSet *) keyPathsForValuesAffectingSelectionIndex {
    return [NSSet setWithObject:@"selection"];
}

+ (NSSet *) keyPathsForValuesAffectingSelection {
    return [NSSet setWithObject:@"selectionIndex"];
}

+ (NSSet *) keyPathsForValuesAffectingActionTypeKey {
    return [NSSet setWithObject:@"currentActionTab"];
}

+ (NSSet *) keyPathsForValuesAffectingCurrentActionsArray {
    return [NSSet setWithObjects: @"selection", @"currentActionTab", nil];
}

- (IBAction) calculateWarpOutDistance:(id)sender {
    [selection calculateWarpOutDistance];
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    NSString *identifier = [tabViewItem identifier];
    NSWindow *window = [self window];
    NSRect frame = [window frame];
    NSLog(@"Resizing From: %@", NSStringFromRect(frame));
    if ([identifier isEqualTo:@"actions"]) {
        frame.size = actionsSize;
        frame.size.height += actionsVerticalBuffer;
    } else {
        frame.size = standardSize;
    }
    frame.size.width += borderSize.width;
    frame.size.height += borderSize.height;
    [window setFrame:frame display:YES animate:YES];
}

- (IBAction) changeActionType:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActionParametersChanged" object:nil];
    [NSApp postNotificationName:@"ActionParametersChanged" object:nil];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    //Action selection changed
    [NSApp postNotificationName:@"ActionParametersChanged" object:nil];
}
@end
