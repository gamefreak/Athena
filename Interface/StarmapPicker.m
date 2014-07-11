//
//  StarmapPicker.m
//  Athena
//
//  Created by Scott McClaugherty on 2/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "StarmapPicker.h"

@interface StarmapPicker (Private)
- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value;
@end

@implementation StarmapPicker
@synthesize scenario;

- (id) initWithScenario:(Scenario *)_scenario {
    self = [super initWithWindowNibName:@"StarmapPicker"];
    if (self) {
        scenario = _scenario;
        [scenario retain];

        [scenario addObserver:self
                   forKeyPath:@"starmap.x"
                      options:NSKeyValueObservingOptionOld
                      context:NULL];
        [scenario addObserver:self
                   forKeyPath:@"starmap.y"
                      options:NSKeyValueObservingOptionOld
                      context:NULL];
    }
    return self;
}

- (void)awakeFromNib {
	
}

- (NSString*) windowTitleForDocumentDisplayName:(NSString*)name {
    return [NSString stringWithFormat:@"%@—Starmap", name];
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value {
    [object setValue:value forKeyPath:keyPath];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    [[[[self document] undoManager] prepareWithInvocationTarget:self]
     changeKeyPath:keyPath
     ofObject:object
     toValue:[change objectForKey:NSKeyValueChangeOldKey]];
}

- (void) dealloc {
    [scenario removeObserver:self forKeyPath:@"starmap.x"];
    [scenario removeObserver:self forKeyPath:@"starmap.y"];
    [scenario release];
    [super dealloc];
}
@end
