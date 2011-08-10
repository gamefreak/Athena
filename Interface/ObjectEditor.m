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
#import "BaseObjectFlags.h"
#import "FlagBlob.h"

#import "FlagMenuPopulator.h"
#import "WeaponViewController.h"
#import "ActionEditor.h"
#import "SpecialViewController.h"

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
        for (BaseObject *object in objects) {
            [self startObservingObject:object];
        }
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
    specialControllers = [[NSMutableDictionary alloc] initWithCapacity:4];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(specialParametersChanged:)
               name:@"SpecialParametersChanged"
             object:nil];
    [nc postNotificationName:@"SpecialParametersChanged"
                      object:nil];

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
    for (BaseObject *object in objects) {
        [self stopObservingObject:object];
    }
    [objects release];
    [selection release];
    [specialControllers release];
    [self unbind:@"selectionIndex"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ActionParametersChanged" object:nil];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    //Action selection changed
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"ActionParametersChanged" object:nil];
    [nc postNotificationName:@"SpecialParametersChanged" object:nil];
}

- (void)specialParametersChanged:(NSNotification *)note {
    NSString *nibName = [objectsController valueForKeyPath:@"selection.specialPanelNib"];
    if (nibName == nil) {return;}//TEMP!
    SpecialViewController *controller = [specialControllers objectForKey:nibName];
    if (controller == nil) {
        controller = [[SpecialViewController alloc] initWithNibName:nibName bundle:nil];
        [specialControllers setObject:controller forKey:nibName];
        [controller autorelease];
    }

    NSView *newSpecialView = [controller view];
    [newSpecialView setFrame:[specialViewTarget frame]];
    
    if (lastSpecialView == nil) {
        [specialViewTarget addSubview:newSpecialView];
    } else {
        [specialViewTarget replaceSubview:lastSpecialView with:newSpecialView];
    }
    [lastSpecialView release];
    lastSpecialView = [newSpecialView retain];

    [controller setObject:[objectsController selection]];
}

- (void) insertObject:(BaseObject *)newObject inObjectsAtIndex:(NSUInteger)index {
    [self startObservingObject:newObject];
    NSUndoManager *undo = [[self document] undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromObjectsAtIndex:index];
    [objects insertObject:newObject atIndex:index];
}

- (void) removeObjectFromObjectsAtIndex:(NSUInteger)index {
    BaseObject *old = [objects objectAtIndex:index];
    [self stopObservingObject:old];
    NSUndoManager *undo = [[self document] undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:old
                                         inObjectsAtIndex:index];
    [objects removeObjectAtIndex:index];
}

- (void) startObservingObject:(BaseObject *)object {
    [object addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"shortName" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"notes" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"staticName" options:NSKeyValueObservingOptionOld context:NULL];
    
    for (NSString *key in [[[object attributes] class] keys]) {
        [object addObserver:self
                 forKeyPath:[NSString stringWithFormat:@"attributes.%@", key]
                    options:NSKeyValueObservingOptionOld
                    context:NULL];
    }
    
    for (NSString *key in [[[object buildFlags] class ]keys]) {
        [object addObserver:self
                 forKeyPath:[NSString stringWithFormat:@"buildFlags.%@", key]
                    options:NSKeyValueObservingOptionOld
                    context:NULL];
    }
    
    for (NSString *key in [[[object orderFlags] class ]keys]) {
        [object addObserver:self
                 forKeyPath:[NSString stringWithFormat:@"orderFlags.%@", key]
                    options:NSKeyValueObservingOptionOld
                    context:NULL];
    }

    [object addObserver:self forKeyPath:@"classNumber" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"race" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"price" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"buildTime" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"buildRatio" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"offence" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"escortRank" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"maxVelocity" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"warpSpeed" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"warpOutDistance" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"initialVelocity" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"initialVelocityRange" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"mass" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"thrust" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"health" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"energy" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"damage" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"initialAge" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"initialAgeRange" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"scale" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"layer" options:NSKeyValueObservingOptionOld context:NULL];
//    NSInteger spriteId;
    [object addObserver:self forKeyPath:@"iconShape" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"iconSize" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"shieldColor" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"initialDirection" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"initialDirectionRange" options:NSKeyValueObservingOptionOld context:NULL];
//    NSMutableDictionary *weapons;//Later
    [object addObserver:self forKeyPath:@"friendDefecit" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"dangerThreshold" options:NSKeyValueObservingOptionOld context:NULL];
//    n) NSInteger specialDirection
    [object addObserver:self forKeyPath:@"arriveActionDistance" options:NSKeyValueObservingOptionOld context:NULL];
//    NSMutableDictionary *actions; //Don't observe here
//    FrameData *frame;
    [object addObserver:self forKeyPath:@"skillNum" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"skillDen" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"skillNumAdj" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"skillDenAdj" options:NSKeyValueObservingOptionOld context:NULL];
    [object addObserver:self forKeyPath:@"portraitId" options:NSKeyValueObservingOptionOld context:NULL];

    [object addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void) stopObservingObject:(BaseObject *)object {
    [object removeObserver:self forKeyPath:@"name"];
    [object removeObserver:self forKeyPath:@"shortName"];
    [object removeObserver:self forKeyPath:@"notes"];
    [object removeObserver:self forKeyPath:@"staticName"];

    for (NSString *key in [[[object attributes] class] keys]) {
        [object removeObserver:self
                    forKeyPath:[NSString stringWithFormat:@"attributes.%@", key]];
    }
    
    for (NSString *key in [[[object buildFlags] class ]keys]) {
        [object removeObserver:self
                    forKeyPath:[NSString stringWithFormat:@"buildFlags.%@", key]];
    }
    
    for (NSString *key in [[[object orderFlags] class ]keys]) {
        [object removeObserver:self
                    forKeyPath:[NSString stringWithFormat:@"orderFlags.%@", key]];

    }

    [object removeObserver:self forKeyPath:@"classNumber"];
    [object removeObserver:self forKeyPath:@"race"];
    [object removeObserver:self forKeyPath:@"price"];
    [object removeObserver:self forKeyPath:@"buildTime"];
    [object removeObserver:self forKeyPath:@"buildRatio"];
    [object removeObserver:self forKeyPath:@"offence"];
    [object removeObserver:self forKeyPath:@"escortRank"];
    [object removeObserver:self forKeyPath:@"maxVelocity"];
    [object removeObserver:self forKeyPath:@"warpSpeed"];
    [object removeObserver:self forKeyPath:@"warpOutDistance"];
    [object removeObserver:self forKeyPath:@"initialVelocity"];
    [object removeObserver:self forKeyPath:@"initialVelocityRange"];
    [object removeObserver:self forKeyPath:@"mass"];
    [object removeObserver:self forKeyPath:@"thrust"];
    [object removeObserver:self forKeyPath:@"health"];
    [object removeObserver:self forKeyPath:@"energy"];
    [object removeObserver:self forKeyPath:@"damage"];
    [object removeObserver:self forKeyPath:@"initialAge"];
    [object removeObserver:self forKeyPath:@"initialAgeRange"];
    [object removeObserver:self forKeyPath:@"scale"];
    [object removeObserver:self forKeyPath:@"layer"];
//    [object removeObserver:self forKeyPath:@"spriteId"];
    [object removeObserver:self forKeyPath:@"iconShape"];
    [object removeObserver:self forKeyPath:@"iconSize"];
    [object removeObserver:self forKeyPath:@"shieldColor"];
    [object removeObserver:self forKeyPath:@"initialDirection"];
    [object removeObserver:self forKeyPath:@"initialDirectionRange"];
//    NSMutableDictionary *weapons;
    [object removeObserver:self forKeyPath:@"friendDefecit"];
    [object removeObserver:self forKeyPath:@"dangerThreshold"];
//   NSInteger specialDirection; //Disabled
    [object removeObserver:self forKeyPath:@"arriveActionDistance"];
//    NSMutableDictionary *actions;
//    FrameData *frame;
    [object removeObserver:self forKeyPath:@"skillNum"];
    [object removeObserver:self forKeyPath:@"skillDen"];
    [object removeObserver:self forKeyPath:@"skillNumAdj"];
    [object removeObserver:self forKeyPath:@"skillDenAdj"];
    [object removeObserver:self forKeyPath:@"portraitId"];

    [object removeObserver:self forKeyPath:@"frame"];
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value {
    [object setValue:value forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    NSUndoManager *undo = [[self document] undoManager];
    id old = [change objectForKey:NSKeyValueChangeOldKey];
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                  ofObject:object
                                                   toValue:old];
}
@end
