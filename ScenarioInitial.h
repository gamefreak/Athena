//
//  ScenarioInitial.h
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"
#import "ResCoding.h"
#import "FlagBlob.h"

@class XSPoint, XSRange;
@class BaseObject;

@interface ScenarioInitialAttributes : FlagBlob {
    BOOL fixedRace;
    BOOL initiallyHidden;
    BOOL isPlayerShip;
    BOOL staticDestination;
}
@property (readwrite, assign) BOOL fixedRace;
@property (readwrite, assign) BOOL initiallyHidden;
@property (readwrite, assign) BOOL isPlayerShip;
@property (readwrite, assign) BOOL staticDestination;
@end


@interface ScenarioInitial : NSObject <LuaCoding, ResCoding> {
    NSInteger type;
    NSInteger owner;
    XSPoint *position;

    float earning;
    NSInteger distanceRange;

    NSInteger rotation;
    NSInteger rotationRange;

    NSInteger spriteIdOverride;

    NSMutableArray *builds;

    NSInteger initialDestination;
    NSString *nameOverride;

    ScenarioInitialAttributes *attributes;

    BaseObject *base;
}
@property (readonly) NSString *realName;
@property (readwrite, assign) NSInteger type;
@property (readwrite, assign) NSInteger owner;
@property (readwrite, retain) XSPoint *position;
@property (readwrite, assign) float earning;
@property (readwrite, assign) NSInteger distanceRange;
@property (readwrite, assign) NSInteger rotation;
@property (readwrite, assign) NSInteger rotationRange;
@property (readwrite, assign) NSInteger spriteIdOverride;
@property (readwrite, retain) NSMutableArray *builds;
@property (readwrite, assign) NSInteger initialDestination;
@property (readwrite, retain) NSString *nameOverride;
@property (readwrite, retain) ScenarioInitialAttributes *attributes;
@property (readwrite, retain) BaseObject *base;

- (void) findBaseFromArray:(NSArray *)array;
@end