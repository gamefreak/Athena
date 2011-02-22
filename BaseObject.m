//
//  BaseObject.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "BaseObject.h"
#import "Archivers.h"
#import "XSPoint.h"

@implementation BaseObject
@synthesize name, shortName, notes, staticName;
@synthesize attributes, buildFlags, orderFlags;
@synthesize classNumber, race;
@synthesize price, buildTime, buildRatio;
@synthesize offence, escortRank, friendDefecit, dangerThreshold;
@synthesize maxVelocity, warpSpeed, warpOutDistance;
@synthesize initialVelocity, initialVelocityRange;
@synthesize mass, thrust, health, energy, damage;
@synthesize initialAge, initialAgeRange;
@synthesize scale, layer, spriteId, iconShape, iconSize, shieldColor;
@synthesize initialDirection, initialDirectionRange;
@synthesize weapons, actions, arriveActionDistance, frame;
@synthesize skillNum, skillDen, skillNumAdj, skillDenAdj;
@synthesize portraitId;
//@synthesize specialDirection; //Disabled

- (id) init {
    self = [super init];
    name = @"Untitled";
    shortName = @"UNTITLED";
    notes = @"";
    staticName = @"Untitled";

    attributes = [[BaseObjectAttributes alloc] init];
    buildFlags = [[BaseObjectBuildFlags alloc] init];
    orderFlags = [[BaseObjectOrderFlags alloc] init];

    classNumber = -1;
    race = -1;

    price = 1000;
    buildTime = 1000;
    buildRatio = 1.0f;

    offence = 1.0f;
    escortRank = 1;

    maxVelocity = 1.0f;
    warpSpeed = 1.0f;//Need better default
    warpOutDistance = 1;//Needs better too
    initialVelocity = 1.0f;
    initialVelocityRange = 1.0f;

    mass = 1.0f;
    thrust = 1.0f;

    health = 1000;
    energy = 1000;
    damage = 0;

    initialAge = -1;
    initialAgeRange = 0;

    scale = 4096;//DIV by 4096
    layer = 0;//TODO make this an enum.
    spriteId = -1;

    iconShape = IconShapeTriangle;
    iconSize = 4;//Size of cruiser

    shieldColor = ClutGray;

    initialDirection = 0;
    initialDirectionRange = 0;

    weapons = [[NSMutableDictionary alloc] initWithCapacity:3];
    [weapons setObject:[Weapon weapon] forKey:@"pulse"];
    [weapons setObject:[Weapon weapon] forKey:@"beam"];
    [weapons setObject:[Weapon weapon] forKey:@"special"];

    friendDefecit = 0.0f;
    dangerThreshold = 0.0f;

    arriveActionDistance = 0;
    
    actions = [[NSMutableDictionary alloc] initWithCapacity:6];
    [actions setObject:[DestroyActionRef ref] forKey:@"destroy"];
    [actions setObject:[ActionRef ref] forKey:@"expire"];
    [actions setObject:[ActionRef ref] forKey:@"create"];
    [actions setObject:[ActionRef ref] forKey:@"collide"];
    [actions setObject:[ActivateActionRef ref] forKey:@"activate"];
    [actions setObject:[ActionRef ref] forKey:@"arrive"];

    frame = [[RotationData alloc] init];

    skillNum = 1;
    skillDen = 1;
    skillNumAdj = 0;//???
    skillDenAdj = 0;//???

    portraitId = -1;
    return self;
}

- (void) dealloc {
    [name release];
    [shortName release];
    [notes release];
    [staticName release];
    
    [attributes release];
    [buildFlags release];
    [orderFlags release];
    
    [weapons release];
    [actions release];
    
    [frame release];
    [super dealloc];
}


- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    name = [[coder decodeStringForKey:@"name"] retain];
    shortName = [[coder decodeStringForKey:@"shortName"] retain];
    notes = [[coder decodeStringForKey:@"notes"] retain];
    staticName = [[coder decodeStringForKey:@"staticName"] retain];

    [attributes release];
    attributes = [[coder decodeObjectOfClass:[BaseObjectAttributes class] forKey:@"attributes"] retain];
    [buildFlags release];
    buildFlags = [[coder decodeObjectOfClass:[BaseObjectBuildFlags class] forKey:@"buildFlags"] retain];
    [orderFlags release];
    orderFlags = [[coder decodeObjectOfClass:[BaseObjectOrderFlags class] forKey:@"orderFlags"] retain];

    classNumber = [coder decodeIntegerForKey:@"class"];
    race = [coder decodeIntegerForKey:@"race"];

    price = [coder decodeIntegerForKey:@"price"];
    buildTime = [coder decodeIntegerForKey:@"buildTime"];
    buildRatio = [coder decodeFloatForKey:@"buildRatio"];

    offence = [coder decodeFloatForKey:@"offence"];
    escortRank = [coder decodeIntegerForKey:@"escortRank"];

    maxVelocity = [coder decodeFloatForKey:@"maxVelocity"];
    warpSpeed = [coder decodeFloatForKey:@"warpSpeed"];
    warpOutDistance = [coder decodeIntegerForKey:@"warpOutDistance"];
    initialVelocity = [coder decodeFloatForKey:@"initialVelocity"];
    initialVelocityRange = [coder decodeFloatForKey:@"initialVelocityRange"];

    mass = [coder decodeFloatForKey:@"mass"];
    thrust = [coder decodeFloatForKey:@"thrust"];

    health = [coder decodeIntegerForKey:@"health"];
    energy = [coder decodeIntegerForKey:@"energy"];
    damage = [coder decodeIntegerForKey:@"damage"];

    initialAge = [coder decodeIntegerForKey:@"initialAge"];
    initialAgeRange = [coder decodeIntegerForKey:@"initialAgeRange"];

    scale = [coder decodeIntegerForKey:@"scale"];
    layer = [coder decodeIntegerForKey:@"layer"];
    spriteId = [coder decodeIntegerForKey:@"spriteId"];

    NSString *iconShapeStr = [coder decodeStringForKey:@"iconShape"];
    if ([iconShapeStr isEqual:@"square"]){
        iconShape = IconShapeSquare;
    } else if ([iconShapeStr isEqual:@"triangle"]) {
        iconShape = IconShapeTriangle;
    } else if ([iconShapeStr isEqual:@"diamond"]) {
        iconShape = IconShapeDiamond;
    } else if ([iconShapeStr isEqual:@"plus"]) {
        iconShape = IconShapePlus;
    } else if ([iconShapeStr isEqual:@"framed square"]) {
        iconShape = IconShapeFramedSquare;
    } else if ([iconShapeStr isEqual:@"none"]){
        //This case should only happen as a result of a fallback condition for the last case
        iconShape = IconShapeNone;
    } else {
        iconShape = IconShapeNone;
    }

    iconSize = [coder decodeIntegerForKey:@"iconSize"];

    shieldColor = [coder decodeIntegerForKey:@"shieldColor"];

    initialDirection = [coder decodeIntegerForKey:@"initialDirection"];
    initialDirectionRange = [coder decodeIntegerForKey:@"initialDirectionRange"];

    [weapons release];
    weapons = [coder decodeDictionaryOfClass:[Weapon class] forKey:@"weapons"];
    [weapons retain];

    friendDefecit = [coder decodeFloatForKey:@"friendDefecit"];
    dangerThreshold = [coder decodeFloatForKey:@"dangerThreshold"];

//    specialDirection = [coder decodeIntegerForKey:@"specialDirection"];

    arriveActionDistance = [coder decodeIntegerForKey:@"arriveActionDistance"];

    [actions setObject:[coder decodeObjectOfClass:[DestroyActionRef class]
                                       forKeyPath:@"actions.destroy"]
                forKey:@"destroy"];

    [actions setObject:[coder decodeObjectOfClass:[ActionRef class]
                                       forKeyPath:@"actions.expire"]
                forKey:@"expire"];

    [actions setObject:[coder decodeObjectOfClass:[ActionRef class]
                                       forKeyPath:@"actions.create"]
                forKey:@"create"];

    [actions setObject:[coder decodeObjectOfClass:[ActionRef class]
                                       forKeyPath:@"actions.collide"]
                forKey:@"collide"];

    [actions setObject:[coder decodeObjectOfClass:[ActivateActionRef class]
                                       forKeyPath:@"actions.activate"]
                forKey:@"activate"];

    [actions setObject:[coder decodeObjectOfClass:[ActionRef class]
                                       forKeyPath:@"actions.arrive"]
                forKey:@"arrive"];

    [frame release];
    if ([[attributes valueForKey:@"shapeFromDirection"] boolValue] == YES) {
        frame = [coder decodeObjectOfClass:[RotationData class] forKey:@"rotation"];
    } else if ([[attributes valueForKey:@"isSelfAnimated"] boolValue] == YES) {
        frame = [coder decodeObjectOfClass:[AnimationData class] forKey:@"animation"];
    } else if ([[attributes valueForKey:@"isBeam"] boolValue] == YES) {
        frame = [coder decodeObjectOfClass:[BeamData class] forKey:@"beam"];
    } else {
        frame = [coder decodeObjectOfClass:[DeviceData class] forKey:@"device"];
    }
    [frame retain];

    skillNum = [coder decodeIntegerForKey:@"skillNum"];
    skillDen = [coder decodeIntegerForKey:@"skillDen"];
    skillNumAdj = [coder decodeIntegerForKey:@"skillNumAdj"];
    skillNumAdj = [coder decodeIntegerForKey:@"skillDenAdj"];

    portraitId = [coder decodeIntegerForKey:@"portraitId"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:name forKey:@"name"];
    [coder encodeString:shortName forKey:@"shortName"];
    [coder encodeString:notes forKey:@"notes"];
    [coder encodeString:staticName forKey:@"staticName"];

    [coder encodeObject:attributes forKey:@"attributes"];
    [coder encodeObject:buildFlags forKey:@"buildFlags"];
    [coder encodeObject:orderFlags forKey:@"orderFlags"];

    [coder encodeInteger:classNumber forKey:@"class"];
    [coder encodeInteger:race forKey:@"race"];

    [coder encodeInteger:price forKey:@"price"];
    [coder encodeInteger:buildTime forKey:@"buildTime"];
    [coder encodeFloat:buildRatio forKey:@"buildRatio"];

    [coder encodeFloat:offence forKey:@"offence"];
    [coder encodeInteger:escortRank forKey:@"escortRank"];

    [coder encodeFloat:maxVelocity forKey:@"maxVelocity"];
    [coder encodeFloat:warpSpeed forKey:@"warpSpeed"];
    [coder encodeInteger:warpOutDistance forKey:@"warpOutDistance"];
    [coder encodeFloat:initialVelocity forKey:@"initialVelocity"];
    [coder encodeFloat:initialVelocityRange forKey:@"initialVelocityRange"];

    if (mass == 0.0f) {
        [coder encodeFloat:1.0f forKey:@"mass"];
    } else {
        [coder encodeFloat:mass forKey:@"mass"];
    }
    [coder encodeFloat:thrust forKey:@"thrust"];

    [coder encodeInteger:health forKey:@"health"];
    [coder encodeInteger:energy forKey:@"energy"];
    [coder encodeInteger:damage forKey:@"damage"];

    [coder encodeInteger:initialAge forKey:@"initialAge"];
    [coder encodeInteger:initialAgeRange forKey:@"initialAgeRange"];

    [coder encodeInteger:scale forKey:@"scale"];
    [coder encodeInteger:layer forKey:@"layer"];
    [coder encodeInteger:spriteId forKey:@"spriteId"];

    switch (iconShape) {
        case IconShapeSquare:
            [coder encodeString:@"square" forKey:@"iconShape"];
            break;
        case IconShapeTriangle:
            [coder encodeString:@"triangle" forKey:@"iconShape"];
            break;
        case IconShapeDiamond:
            [coder encodeString:@"diamond" forKey:@"iconShape"];
            break;
        case IconShapePlus:
            [coder encodeString:@"plus" forKey:@"iconShape"];
            break;
        case IconShapeFramedSquare:
            [coder encodeString:@"framed square" forKey:@"iconShape"];
            break;
        default:
        case IconShapeNone:
            [coder encodeString:@"none" forKey:@"iconShape"];
            break;
    }

    [coder encodeInteger:iconSize forKey:@"iconSize"];

    [coder encodeInteger:shieldColor forKey:@"shieldColor"];

    [coder encodeInteger:initialDirection forKey:@"initialDirection"];
    [coder encodeInteger:initialDirectionRange forKey:@"initialDirectionRange"];

    [coder encodeDictionary:weapons forKey:@"weapons" asArray:NO];

    [coder encodeFloat:friendDefecit forKey:@"friendDefecit"];
    [coder encodeFloat:dangerThreshold forKey:@"dangerThreshold"];

//    [coder encodeInteger:specialDirection forKey:@"specialDirection"];

    [coder encodeInteger:arriveActionDistance forKey:@"arriveActionDistance"];

    [coder encodeDictionary:actions forKey:@"actions" asArray:NO];

    if ([[attributes valueForKey:@"shapeFromDirection"] boolValue] == YES) {
        [coder encodeObject:frame forKey:@"rotation"];
    } else if ([[attributes valueForKey:@"isSelfAnimated"] boolValue] == YES) {
        [coder encodeObject:frame forKey:@"animation"];
    } else if ([[attributes valueForKey:@"isBeam"] boolValue] == YES) {
        [coder encodeObject:frame forKey:@"beam"];
    } else {
        [coder encodeObject:frame forKey:@"device"];
    }

    [coder encodeInteger:portraitId forKey:@"portraitId"];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

//MARK: Res Coding

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        [attributes initWithResArchiver:coder];
        classNumber = [coder decodeSInt32];
        race = [coder decodeSInt32];
        price = [coder decodeSInt32];

        offence = [coder decodeFixed];
        escortRank = [coder decodeSInt32];

        maxVelocity = [coder decodeFixed];
        warpSpeed = [coder decodeFixed];
        warpOutDistance = [coder decodeUInt32];

        initialVelocity = [coder decodeFixed];
        initialVelocityRange = [coder decodeFixed];

        mass = [coder decodeFixed];
        thrust = [coder decodeFixed];

        health = [coder decodeSInt32];
        damage = [coder decodeSInt32];
        energy = [coder decodeSInt32];
        
        initialAge = [coder decodeSInt32];
        initialAgeRange = [coder decodeSInt32];

        scale = [coder decodeSInt32];
        layer = [coder decodeSInt16];
        spriteId = [coder decodeSInt16];
        int iconData = [coder decodeUInt32];
        iconSize = 0x0f & iconData;
        iconShape = (0xf0 & iconData) >> 8;
        shieldColor = [coder decodeUInt8];
        [coder skip:1u];

        initialDirection = [coder decodeSInt32];
        initialDirectionRange = [coder decodeSInt32];

        int pulseId = [coder decodeSInt32];
        int beamId = [coder decodeSInt32];
        int specialId = [coder decodeSInt32];
        int pulseCount = [coder decodeSInt32];
        int beamCount = [coder decodeSInt32];
        int specialCount = [coder decodeSInt32];
        [[weapons objectForKey:@"pulse"]
         initWithResArchiver:coder id:pulseId count:pulseCount];
        [[weapons objectForKey:@"beam"]
         initWithResArchiver:coder id:beamId count:beamCount];
        [[weapons objectForKey:@"special"]
         initWithResArchiver:coder id:specialId count:specialCount];

        friendDefecit = [coder decodeFixed];
        dangerThreshold = [coder decodeFixed];

        [coder skip:4u];

        arriveActionDistance = [coder decodeSInt32];

        [[actions objectForKey:@"destroy"] initWithResArchiver:coder];
        [[actions objectForKey:@"expire"] initWithResArchiver:coder];
        [[actions objectForKey:@"create"] initWithResArchiver:coder];
        [[actions objectForKey:@"collide"] initWithResArchiver:coder];
        [[actions objectForKey:@"activate"] initWithResArchiver:coder];
        [[actions objectForKey:@"arrive"] initWithResArchiver:coder];

        [frame release];
        if (attributes.shapeFromDirection) {
            frame = [[RotationData alloc] initWithResArchiver:coder];
        } else if (attributes.isSelfAnimated) {
            frame = [[AnimationData alloc] initWithResArchiver:coder];
        } else if (attributes.isBeam) {
            frame = [[BeamData alloc] initWithResArchiver:coder];
        } else {
            frame = [[DeviceData alloc] initWithResArchiver:coder];
        }
        [buildFlags initWithResArchiver:coder];
        [orderFlags initWithResArchiver:coder];

        buildRatio = [coder decodeFixed];
        buildTime = [coder decodeUInt32];

        skillNum = [coder decodeUInt8];
        skillDen = [coder decodeUInt8];
        skillNumAdj = [coder decodeUInt8];
        skillDenAdj = [coder decodeUInt8];

        portraitId = [coder decodeSInt16];
        [coder skip:10u];

        [name release];
        name = [[[coder decodeObjectOfClass:[StringTable class]
                                    atIndex:STRBaseObjectNames]
                 stringAtIndex:[coder currentIndex]] retain];
        [shortName release];
        shortName = [[[coder decodeObjectOfClass:[StringTable class]
                                         atIndex:STRBaseObjectShortNames]
                      stringAtIndex:[coder currentIndex]] retain];
        [notes release];
        notes = [[[coder decodeObjectOfClass:[StringTable class]
                                     atIndex:STRBaseObjectNotes]
                  stringAtIndex:[coder currentIndex]] retain];
        [staticName release];
        staticName = [[[coder decodeObjectOfClass:[StringTable class]
                                          atIndex:STRBaseObjectStaticNames]
                       stringAtIndex:[coder currentIndex]] retain];
        
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [attributes encodeResWithCoder:coder];
    [coder encodeSInt32:classNumber];
    [coder encodeSInt32:race];
    [coder encodeSInt32:price];

    [coder encodeFixed:offence];
    [coder encodeSInt32:escortRank];

    [coder encodeFixed:maxVelocity];
    [coder encodeFixed:warpSpeed];
    [coder encodeFixed:warpOutDistance];

    [coder encodeFixed:initialVelocity];
    [coder encodeFixed:initialVelocityRange];

    [coder encodeFixed:mass];
    [coder encodeFixed:thrust];

    [coder encodeSInt32:health];
    [coder encodeSInt32:damage];
    [coder encodeSInt32:energy];

    [coder encodeSInt32:initialAge];
    [coder encodeSInt32:initialAgeRange];

    [coder encodeSInt32:scale];
    [coder encodeSInt16:layer];
    [coder encodeSInt16:spriteId];
    [coder encodeUInt32:((0xf0 & (iconShape << 8)) | (0x0f & iconSize))];
    [coder encodeUInt8:shieldColor];
    [coder skip:1u];

    [coder encodeSInt32:initialDirection];
    [coder encodeSInt32:initialDirectionRange];

    Weapon *pulse = [weapons objectForKey:@"pulse"];
    Weapon *beam = [weapons objectForKey:@"beam"];
    Weapon *special = [weapons objectForKey:@"special"];
    [coder encodeSInt32:pulse.ID.orNull];
    [coder encodeSInt32:beam.ID.orNull];
    [coder encodeSInt32:special.ID.orNull];
    [coder encodeSInt32:pulse.positionCount];
    [coder encodeSInt32:beam.positionCount];
    [coder encodeSInt32:special.positionCount];
    [pulse encodeResWithCoder:coder];
    [beam encodeResWithCoder:coder];
    [special encodeResWithCoder:coder];

    [coder encodeFixed:friendDefecit];
    [coder encodeFixed:dangerThreshold];

    [coder skip:4u];

    [coder encodeSInt32:arriveActionDistance];
    [[actions objectForKey:@"destroy"] encodeResWithCoder:coder];
    [[actions objectForKey:@"expire"] encodeResWithCoder:coder];
    [[actions objectForKey:@"create"] encodeResWithCoder:coder];
    [[actions objectForKey:@"collide"] encodeResWithCoder:coder];
    [[actions objectForKey:@"activate"] encodeResWithCoder:coder];
    [[actions objectForKey:@"arrive"] encodeResWithCoder:coder];

    [frame encodeResWithCoder:coder];

    [buildFlags encodeResWithCoder:coder];
    [orderFlags encodeResWithCoder:coder];

    [coder encodeFixed:buildRatio];
    [coder encodeUInt32:buildTime];

    [coder encodeUInt8:skillNum];
    [coder encodeUInt8:skillDen];
    [coder encodeUInt8:skillNumAdj];
    [coder encodeUInt8:skillDenAdj];

    [coder encodeSInt16:portraitId];
    [coder skip:10u];

    [coder addString:name toStringTable:STRBaseObjectNames];
    [coder addString:shortName toStringTable:STRBaseObjectShortNames];
    [coder addString:notes toStringTable:STRBaseObjectNotes];
    [coder addString:staticName toStringTable:STRBaseObjectStaticNames];
}

+ (ResType)resType {
    return 'bsob';
}

+ (NSString *)typeKey {
    return @"bsob";
}

+ (BOOL)isPacked {
    return YES;
}

+ (size_t)sizeOfResourceItem {
    return 318;
}
@end

@implementation Weapon
@synthesize ID, positionCount, positions;

- (id) init {
    self = [super init];
    if (self) {
        ID = [[Index alloc] init];
        positionCount = 0;
        positions = [[NSMutableArray alloc] initWithObjects:[XSPoint point], [XSPoint point], [XSPoint point], nil];
    }
    return self;
}

- (void) dealloc {
    [positions release];
    [ID release];
    [super dealloc];
}


- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        self.ID = [coder getIndexRefWithIndex:[coder decodeIntegerForKey:@"id"] forClass:[BaseObject class]];
        positionCount = [coder decodeIntegerForKey:@"count"];
        [positions setArray:[coder decodeArrayOfClass:[XSPoint class] forKey:@"positions" zeroIndexed:NO]];
        NSInteger arrayShortfall = 3 - [positions count];
        for (NSInteger i = 0; i < arrayShortfall; i++) {
            [positions addObject:[XSPoint point]];
        }
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:ID.index forKey:@"id"];
    [coder encodeInteger:positionCount forKey:@"count"];
    [coder encodeArray:positions forKey:@"positions" zeroIndexed:NO];
}

+ (id) weapon {
    return [[[Weapon alloc] init] autorelease];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

- (id) initWithResArchiver:(ResUnarchiver *)coder id:(NSInteger)_id count:(NSInteger)count {
    self = [self init];
    if (self) {
        if (_id == -1) {
            self.ID = [[Index alloc] init];
        } else {
            self.ID = [coder getIndexRefWithIndex:_id forClass:[BaseObject class]];
        }
        positionCount = count;
        for (int k = 0; k < 3; k++) {
            XSPoint *point = [positions objectAtIndex:k];
            point.y = [coder decodeFixed];
            point.x = [coder decodeFixed];
        }
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    int max = MIN(3, positionCount);
    for (int k = 0; k < max; k++) {
        XSPoint *point = [positions objectAtIndex:k];
        [coder encodeFixed:point.y];
        [coder encodeFixed:point.x];
    }
    [coder skip:8u * (3 - max)];
}
@end
