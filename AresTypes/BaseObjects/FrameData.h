//
//  FrameData.h
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Color.h"
#import "FlagBlob.h"
#import "LuaCoding.h"
#import "ResCoding.h"

@interface FrameData : NSObject <LuaCoding, ResCoding> {
}
- (void) addObserver:(NSObject *)observer;
- (void) removeObserver:(NSObject *)observer;
@end

@interface RotationData : FrameData {
    NSInteger offset;
    NSInteger resolution;
    float turnRate;
    float turnAcceleration;
}
@property (readwrite, assign) NSInteger offset;
@property (readwrite, assign) NSInteger resolution;
@property (readwrite, assign) float turnRate;
@property (readwrite, assign) float turnAcceleration;
@end

@interface AnimationData : FrameData {
    NSInteger firstShape, lastShape;
    NSInteger direction, directionRange;
    NSInteger speed, speedRange;
    NSInteger shape, shapeRange;
}
@property (readwrite, assign) NSInteger firstShape;
@property (readwrite, assign) NSInteger lastShape;
@property (readwrite, assign) NSInteger direction;
@property (readwrite, assign) NSInteger directionRange;
@property (readwrite, assign) NSInteger speed;
@property (readwrite, assign) NSInteger speedRange;
@property (readwrite, assign) NSInteger shape;
@property (readwrite, assign) NSInteger shapeRange;
@end

typedef enum _ {
    BeamTypeKinetic = 0x0,
    BeamTypeDirectStatic = 0x2,
    BeamTypeRelativeStatic = 0x3,
    BeamTypeDirectBolt = 0x4,
    BeamTypeRelativeBolt = 0x5
} BeamType;

@interface BeamData : FrameData {
    BeamType type;
    ClutColor color;
    NSInteger accuracy;
    float range;
}
@property (readwrite, assign) BeamType type;
@property (readwrite, assign) ClutColor color;
@property (readwrite, assign) NSInteger accuracy;
@property (readwrite, assign) float range;
@end

@interface DeviceUses : FlagBlob {
    BOOL transportation;
    BOOL attacking;
    BOOL defence;
}
@property (readwrite) BOOL transportation;
@property (readwrite) BOOL attacking;
@property (readwrite) BOOL defence;
@end

@interface DeviceData : FrameData {
    DeviceUses *uses;
    NSInteger energyCost;
    NSInteger reload;
    NSInteger ammo;
    NSInteger range;
    NSInteger inverseSpeed;
    NSInteger restockCost;
}
@property (readwrite, retain) DeviceUses *uses;
@property (readwrite, assign) NSInteger energyCost;
@property (readwrite, assign) NSInteger reload;
@property (readwrite, assign) NSInteger ammo;
@property (readwrite, assign) NSInteger range;
@property (readwrite, assign) NSInteger inverseSpeed;
@property (readwrite, assign) NSInteger restockCost;
@end