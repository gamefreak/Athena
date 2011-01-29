//
//  FrameData.m
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "FrameData.h"
#import "Archivers.h"
#import "XSBool.h"

@implementation FrameData
- (id) initWithLuaCoder:(LuaUnarchiver *)aDecoder {
    self = [self init];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)aCoder {}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}
@end

@implementation RotationData
@synthesize offset, resolution, turnRate, turnAcceleration;

- (id) init {
    self = [super init];
    offset = 0;
    resolution = 15;//24 frames
    turnRate = 1.0f;
    turnAcceleration = 1.0f;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    offset = [coder decodeIntegerForKey:@"offset"];
    resolution = [coder decodeIntegerForKey:@"resolution"];
    turnRate = [coder decodeFloatForKey:@"turnRate"];
    turnAcceleration = [coder decodeFloatForKey:@"turnAcceleration"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:offset forKey:@"offset"];
    [coder encodeInteger:resolution forKey:@"resolution"];
    [coder encodeFloat:turnRate forKey:@"turnRate"];
    [coder encodeFloat:turnAcceleration forKey:@"turnAcceleration"];
}
@end

@implementation AnimationData
@synthesize firstShape, lastShape, direction, directionRange;
@synthesize speed, speedRange, shape, shapeRange;

- (id) init {
    self = [super init];
    firstShape = 0;
    lastShape = 24;
    direction = 1;
    directionRange = 0;
    speed = 30; //NEED BETTER DEFAULT
    speedRange = 0;
    shape = 0;
    shapeRange = 0;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    firstShape = [coder decodeIntegerForKey:@"firstShape"];
    lastShape = [coder decodeIntegerForKey:@"lastShape"];
    direction = [coder decodeIntegerForKey:@"direction"];
    directionRange = [coder decodeIntegerForKey:@"directionRange"];
    speed = [coder decodeIntegerForKey:@"speed"];
    speedRange = [coder decodeIntegerForKey:@"speedRange"];
    shape = [coder decodeIntegerForKey:@"shape"];
    shapeRange = [coder decodeIntegerForKey:@"shapeRange"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:firstShape forKey:@"firstShape"];
    [coder encodeInteger:lastShape forKey:@"lastShape"];
    [coder encodeInteger:direction forKey:@"direction"];
    [coder encodeInteger:directionRange forKey:@"directionRange"];
    [coder encodeInteger:speed forKey:@"speed"];
    [coder encodeInteger:speedRange forKey:@"speedRange"];
    [coder encodeInteger:shape forKey:@"shape"];
    [coder encodeInteger:shapeRange forKey:@"shapeRange"];
}
@end

@implementation BeamData
@synthesize type, color, accuracy, range;

- (id) init {
    self = [super init];
    type = BeamTypeKinetic;
    color = ClutGray;
    accuracy = 131072;//??
    range = 256.0;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    type = [coder decodeIntegerForKey:@"hex"];
    color = [coder decodeIntegerForKey:@"color"];
    accuracy = [coder decodeIntegerForKey:@"accuracy"];
    range = [coder decodeFloatForKey:@"range"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:type forKey:@"hex"];
    switch (type) {
        case BeamTypeKinetic:
            [coder encodeString:@"kinetic" forKey:@"type"];
            break;
        case BeamTypeDirectStatic:
        case BeamTypeRelativeStatic:
            [coder encodeString:@"static" forKey:@"type"];
            break;
        case BeamTypeDirectBolt:
        case BeamTypeRelativeBolt:
            [coder encodeString:@"bolt" forKey:@"type"];
            break;
        default:
            @throw @"Invalid Beam Type";
            break;
    }
    switch (type) {
        case BeamTypeKinetic:
            [coder encodeNilForKey:@"mode"];
            break;
        case BeamTypeDirectStatic:
        case BeamTypeDirectBolt:
            [coder encodeString:@"direct" forKey:@"mode"];
            break;
        case BeamTypeRelativeStatic:
        case BeamTypeRelativeBolt:
            [coder encodeString:@"relative" forKey:@"mode"];
            break;
        default:
            @throw @"Invalid Beam Type";
            break;
    }
    
    [coder encodeInteger:accuracy forKey:@"accuracy"];
    [coder encodeFloat:range forKey:@"range"];
}
@end

@implementation DeviceData
@synthesize uses, energyCost, reload, ammo;
@synthesize range, inverseSpeed, restockCost;

- (id) init {
    self = [super init];
    uses = [[NSMutableDictionary alloc] initWithCapacity:3];
    [uses setObject:[XSBool no] forKey:@"transportation"];
    [uses setObject:[XSBool no] forKey:@"attacking"];
    [uses setObject:[XSBool no] forKey:@"defence"];

    energyCost = 0;
    reload = 1;//Need better default
    ammo = -1;
    range = 1;//Need better default
    inverseSpeed = 1;//Need better default
    restockCost = 0;//Need better default
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    [uses setObject:[XSBool boolWithBool:[coder decodeBoolForKeyPath:@"uses.transportation"]]
             forKey:@"transportation"];

    [uses setObject:[XSBool boolWithBool:[coder decodeBoolForKeyPath:@"uses.attacking"]]
             forKey:@"attacking"];

    [uses setObject:[XSBool boolWithBool:[coder decodeBoolForKeyPath:@"uses.defence"]]
             forKey:@"defence"];
    
    energyCost = [coder decodeIntegerForKey:@"energyCost"];
    reload = [coder decodeIntegerForKey:@"reload"];
    ammo = [coder decodeIntegerForKey:@"ammo"];
    range = [coder decodeIntegerForKey:@"range"];
    inverseSpeed = [coder decodeIntegerForKey:@"inverseSpeed"];
    restockCost = [coder decodeIntegerForKey:@"restockCost"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeDictionary:uses forKey:@"uses"];
    [coder encodeInteger:energyCost forKey:@"energyCost"];
    [coder encodeInteger:reload forKey:@"reload"];
    [coder encodeInteger:ammo forKey:@"ammo"];
    [coder encodeInteger:range forKey:@"range"];
    [coder encodeInteger:inverseSpeed forKey:@"inverseSpeed"];
    [coder encodeInteger:restockCost forKey:@"restockCost"];
} 

- (void) dealloc {
    [uses release];
    [super dealloc];
}
@end

