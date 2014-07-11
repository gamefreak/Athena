//
//  RaceEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData;
@class Race;

@interface RaceEditor : NSWindowController {
    MainData *data;
    NSMutableArray *races;
    IBOutlet NSArrayController *raceController;
}
@property (readwrite, retain) NSMutableArray *races;
- (id) initWithMainData:(MainData *)data;

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value;
- (void) startObservingRace:(Race *)race;
- (void) stopObservingRace:(Race *)race;

@end
