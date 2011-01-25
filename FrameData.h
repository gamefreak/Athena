//
//  FrameData.h
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Color.h"
#import "LuaCoding.h"

@interface FrameData : NSObject <LuaCoding> {} @end

@interface RotationData : FrameData {
    NSInteger offset;
    NSInteger resolution;
    float turnRate;
    float turnAcceleration;
}
@end

@interface AnimationData : FrameData {
    NSInteger firstShape, lastShape;
    NSInteger direction, directionRange;
    NSInteger speed, speedRange;
    NSInteger shape, shapeRange;
}
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
@end

@interface DeviceData : FrameData {
    NSMutableDictionary *uses;
    NSInteger energyCost;
    NSInteger reload;
    NSInteger ammo;
    NSInteger range;
    NSInteger inverseSpeed;
    NSInteger restockCost;
}
@end