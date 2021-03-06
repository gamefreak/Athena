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
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)aCoder {}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        [coder skip:32u];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder skip:32u];
}

//Do nothing here, this will be handled by subclasses.
- (void) addObserver:(NSObject *)observer {}
- (void) removeObserver:(NSObject *)observer {}
@end

@implementation RotationData
@synthesize offset, resolution, turnRate, turnAcceleration;

- (id) init {
    self = [super init];
    if (self) {
        offset = 0;
        resolution = 15;//24 frames
        turnRate = 1.0f;
        turnAcceleration = 1.0f;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        offset = [coder decodeIntegerForKey:@"offset"];
        resolution = [coder decodeIntegerForKey:@"resolution"];
        turnRate = [coder decodeFloatForKey:@"turnRate"];
        turnAcceleration = [coder decodeFloatForKey:@"turnAcceleration"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:offset forKey:@"offset"];
    [coder encodeInteger:resolution forKey:@"resolution"];
    [coder encodeFloat:turnRate forKey:@"turnRate"];
    [coder encodeFloat:turnAcceleration forKey:@"turnAcceleration"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        offset = [coder decodeSInt32];
        resolution = [coder decodeSInt32];
        turnRate = [coder decodeFixed];
        turnAcceleration = [coder decodeFixed];
        [coder skip:16u];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt32:offset];
    [coder encodeSInt32:resolution];
    [coder encodeFixed:turnRate];
    [coder encodeFixed:turnAcceleration];
    [coder skip:16];
}

- (void)addObserver:(NSObject *)observer {
    [self addObserver:observer forKeyPath:@"offset" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"resolution" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"turnRate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"turnAcceleration" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [self removeObserver:observer forKeyPath:@"offset"];
    [self removeObserver:observer forKeyPath:@"resolution"];
    [self removeObserver:observer forKeyPath:@"turnRate"];
    [self removeObserver:observer forKeyPath:@"turnAcceleration"];
}
@end

@implementation AnimationData
@synthesize firstShape, lastShape, direction, directionRange;
@synthesize speed, speedRange, shape, shapeRange;

- (id) init {
    self = [super init];
    if (self) {
        firstShape = 0;
        lastShape = 24;
        direction = 1;
        directionRange = 0;
        speed = 30; //NEED BETTER DEFAULT
        speedRange = 0;
        shape = 0;
        shapeRange = 0;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        firstShape = [coder decodeIntegerForKey:@"firstShape"];
        lastShape = [coder decodeIntegerForKey:@"lastShape"];
        direction = [coder decodeIntegerForKey:@"direction"];
        directionRange = [coder decodeIntegerForKey:@"directionRange"];
        speed = [coder decodeIntegerForKey:@"speed"];
        speedRange = [coder decodeIntegerForKey:@"speedRange"];
        shape = [coder decodeIntegerForKey:@"shape"];
        shapeRange = [coder decodeIntegerForKey:@"shapeRange"];
    }
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

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        firstShape = [coder decodeSInt32];
        lastShape = [coder decodeSInt32];
        direction = [coder decodeSInt32];
        directionRange = [coder decodeSInt32];
        speed = [coder decodeSInt32];
        speedRange = [coder decodeSInt32];
        shape = [coder decodeSInt32];
        shapeRange = [coder decodeSInt32];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt32:firstShape];
    [coder encodeSInt32:lastShape];
    [coder encodeSInt32:direction];
    [coder encodeSInt32:directionRange];
    [coder encodeSInt32:speed];
    [coder encodeSInt32:speedRange];
    [coder encodeSInt32:shape];
    [coder encodeSInt32:shapeRange];
}

 - (void)addObserver:(NSObject *)observer {
     [self addObserver:observer forKeyPath:@"firstShape" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
     [self addObserver:observer forKeyPath:@"lastShape" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
     [self addObserver:observer forKeyPath:@"direction" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
     [self addObserver:observer forKeyPath:@"directionRange" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
     [self addObserver:observer forKeyPath:@"speed" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
     [self addObserver:observer forKeyPath:@"speedRange" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
     [self addObserver:observer forKeyPath:@"shape" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
     [self addObserver:observer forKeyPath:@"shapeRange" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
 }
 
 - (void)removeObserver:(NSObject *)observer {
     [self removeObserver:observer forKeyPath:@"firstShape"];
     [self removeObserver:observer forKeyPath:@"lastShape"];
     [self removeObserver:observer forKeyPath:@"direction"];
     [self removeObserver:observer forKeyPath:@"directionRange"];
     [self removeObserver:observer forKeyPath:@"speed"];
     [self removeObserver:observer forKeyPath:@"speedRange"];
     [self removeObserver:observer forKeyPath:@"shape"];
     [self removeObserver:observer forKeyPath:@"shapeRange"];
 }
@end

@implementation BeamData
@synthesize type, color, accuracy, range;

- (id) init {
    self = [super init];
    if (self) {
        type = BeamTypeKinetic;
        color = ClutGray;
        accuracy = 131072;//??
        range = 256.0;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        type = [coder decodeIntegerForKey:@"hex"];
        color = [coder decodeIntegerForKey:@"color"] - 1;
        accuracy = [coder decodeIntegerForKey:@"accuracy"];
        range = [coder decodeFloatForKey:@"range"];
    }
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
    [coder encodeInteger:color + 1 forKey:@"color"];
    [coder encodeInteger:accuracy forKey:@"accuracy"];
    [coder encodeFloat:range forKey:@"range"];
}

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        color = [coder decodeUInt8] >> 4;
        char bt = [coder decodeUInt8];
        switch (bt) {
            case 0:
                type = BeamTypeKinetic;
                break;
            case 1:
                type = BeamTypeDirectStatic;
                break;
            case 2:
                type = BeamTypeRelativeStatic;
                break;
            case 3:
                type = BeamTypeDirectBolt;
                break;
            case 4:
                type = BeamTypeRelativeBolt;
                break;
            default:
                @throw [NSString stringWithFormat:@"Invalid beam type (%hhx)", bt];
                break;
        }
        accuracy = [coder decodeSInt32];
        range = sqrt([coder decodeSInt32]);
        [coder skip:22u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeUInt8:color << 4 | 0x01 ];
    char encType;
    switch (type) {
        case BeamTypeKinetic:
            encType = 0;
            break;
        case BeamTypeDirectStatic:
            encType = 1;
            break;
        case BeamTypeRelativeStatic:
            encType = 2;
            break;
        case BeamTypeDirectBolt:
            encType = 3;
            break;
        case BeamTypeRelativeBolt:
            encType = 4;
            break;
        default:
            @throw [NSString stringWithFormat:@"Invalid beam type (%x)", (int)type];
            break;
    }
    [coder encodeUInt8:encType];
    [coder encodeSInt32:accuracy];
    [coder encodeSInt32:range*range];
    [coder skip:22u];
}

- (void)addObserver:(NSObject *)observer {
    [self addObserver:observer forKeyPath:@"color" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"type" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"accuracy" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"range" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [self removeObserver:observer forKeyPath:@"color"];
    [self removeObserver:observer forKeyPath:@"type"];
    [self removeObserver:observer forKeyPath:@"accuracy"];
    [self removeObserver:observer forKeyPath:@"range"];
}
@end

@implementation DeviceData
@synthesize uses, energyCost, reload, ammo;
@synthesize range, inverseSpeed, restockCost;

- (id) init {
    self = [super init];
    if (self) {
        uses = [[DeviceUses alloc] init];
        uses.transportation = YES;
        uses.attacking = YES;
        uses.defence = YES;

        energyCost = 0;
        reload = 1;//Need better default
        ammo = -1;
        range = 1;//Need better default
        inverseSpeed = 1;//Need better default
        restockCost = 0;//Need better default
    }
    return self;
}

- (void) dealloc {
    [uses release];
    [super dealloc];
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        [uses release];
        uses = [[coder decodeObjectOfClass:[DeviceUses class] forKey:@"uses"] retain];

        energyCost = [coder decodeIntegerForKey:@"energyCost"];
        reload = [coder decodeIntegerForKey:@"reload"];
        ammo = [coder decodeIntegerForKey:@"ammo"];
        range = [coder decodeIntegerForKey:@"range"];
        inverseSpeed = [coder decodeIntegerForKey:@"inverseSpeed"];
        restockCost = [coder decodeIntegerForKey:@"restockCost"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeObject:uses forKey:@"uses"];
    [coder encodeInteger:energyCost forKey:@"energyCost"];
    [coder encodeInteger:reload forKey:@"reload"];
    [coder encodeInteger:ammo forKey:@"ammo"];
    [coder encodeInteger:range forKey:@"range"];
    [coder encodeInteger:inverseSpeed forKey:@"inverseSpeed"];
    [coder encodeInteger:restockCost forKey:@"restockCost"];
} 

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        [uses initWithResArchiver:coder];
        energyCost = [coder decodeSInt32];
        reload = [coder decodeSInt32];
        ammo = [coder decodeSInt32];
        range = [coder decodeSInt32];
        inverseSpeed = [coder decodeSInt32];
        restockCost = [coder decodeSInt32];
        [coder skip:4u];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    [uses encodeResWithCoder:coder];
    [coder encodeSInt32:energyCost];
    [coder encodeSInt32:reload];
    [coder encodeSInt32:ammo];
    [coder encodeSInt32:range];
    [coder encodeSInt32:inverseSpeed];
    [coder encodeSInt32:restockCost];
    [coder skip:4u];
}

- (void)addObserver:(NSObject *)observer {
    [self addObserver:observer forKeyPath:@"energyCost" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"reload" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"ammo" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"range" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"inverseSpeed" options:NSKeyValueObservingOptionOld context:NULL];
    [self addObserver:observer forKeyPath:@"restockCost" options:NSKeyValueObservingOptionOld context:NULL];

    [uses addObserver:observer forKeyPath:@"attacking" options:NSKeyValueObservingOptionOld context:NULL];
    [uses addObserver:observer forKeyPath:@"defence" options:NSKeyValueObservingOptionOld context:NULL];
    [uses addObserver:observer forKeyPath:@"transportation" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver:(NSObject *)observer {
    [self removeObserver:observer forKeyPath:@"energyCost"];
    [self removeObserver:observer forKeyPath:@"reload"];
    [self removeObserver:observer forKeyPath:@"ammo"];
    [self removeObserver:observer forKeyPath:@"range"];
    [self removeObserver:observer forKeyPath:@"inverseSpeed"];
    [self removeObserver:observer forKeyPath:@"restockCost"];

    [uses removeObserver:observer forKeyPath:@"attacking"];
    [uses removeObserver:observer forKeyPath:@"defence"];
    [uses removeObserver:observer forKeyPath:@"transportation"];
}
@end

static NSArray *deviceUseKeys;
@implementation DeviceUses
@synthesize transportation, attacking, defence;

+ (NSArray *) keys {
    if (deviceUseKeys == nil) {
        deviceUseKeys = [[NSArray alloc] initWithObjects:@"transportation", @"attacking", @"defence", [NSNull null],
                         [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                         [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                         [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                         [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                         [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                         [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                         [NSNull null], [NSNull null], [NSNull null], [NSNull null], nil];
        
    }
    return deviceUseKeys;
}
@end

