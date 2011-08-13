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
#import "MainData.h"

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

    scale = 1.0;//DIV by 4096
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

    frame = [[DeviceData alloc] init];

    skillNum = 1;
    skillDen = 1;
    skillNumAdj = 0;//???
    skillDenAdj = 0;//???

    portraitId = -1;

    [self addObserver:self forKeyPath:@"objectType" options:NSKeyValueObservingOptionOld context:NULL];
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
    
    [self removeObserver:self forKeyPath:@"objectType"];
    [frame release];
    [super dealloc];
}


- (int) calculateWarpOutDistance {
    double warpTime = warpSpeed * 3.0;
    double temp = warpSpeed * warpTime - (warpTime * warpTime * thrust / 2.0);
    self.warpOutDistance = (int)(temp * temp);
    return warpOutDistance;
}


- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        name = [[coder decodeStringForKey:@"name"] retain];
        shortName = [[coder decodeStringForKey:@"shortName"] retain];
        notes = [[coder decodeStringForKey:@"notes"] retain];
        staticName = [[coder decodeStringForKey:@"staticName"] retain];

        //disable the observation
        [self removeObserver:self forKeyPath:@"objectType"];
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

        scale = [coder decodeFloatForKey:@"scale"];
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
        switch ([self objectType]) {
            case RotationalObject:
                frame = [coder decodeObjectOfClass:[RotationData class] forKey:@"rotation"];
                break;
            case AnimatedObject:
                frame = [coder decodeObjectOfClass:[AnimationData class] forKey:@"animation"];
                break;
            case BeamObject:
                frame = [coder decodeObjectOfClass:[BeamData class] forKey:@"beam"];
                break;
            case DeviceObject:
                frame = [coder decodeObjectOfClass:[DeviceData class] forKey:@"device"];
                break;
        }
        [frame retain];
        //and re-enable
        [self addObserver:self forKeyPath:@"objectType" options:NSKeyValueObservingOptionOld context:NULL];

        skillNum = [coder decodeIntegerForKey:@"skillNum"];
        skillDen = [coder decodeIntegerForKey:@"skillDen"];
        skillNumAdj = [coder decodeIntegerForKey:@"skillNumAdj"];
        skillNumAdj = [coder decodeIntegerForKey:@"skillDenAdj"];

        portraitId = [coder decodeIntegerForKey:@"portraitId"];
    }
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

    [coder encodeFloat:scale forKey:@"scale"];
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

    NSString *encodeKey;
    switch ([self objectType]) {
        case RotationalObject:
            encodeKey = @"rotation";
            break;
        case AnimatedObject:
            encodeKey = @"animation";
            break;
        case BeamObject:
            encodeKey = @"beam";
            break;
        case DeviceObject:
            encodeKey = @"device";
            break;
    }
    [coder encodeObject:frame forKey:encodeKey];

    [coder encodeInteger:portraitId forKey:@"portraitId"];
}

- (void) finishLoadingFromLuaWithRootData:(id)data {
    [[weapons objectForKey:@"pulse"] finishLoadingFromLuaWithRootData:data];
    [[weapons objectForKey:@"beam"] finishLoadingFromLuaWithRootData:data];
    [[weapons objectForKey:@"special"] finishLoadingFromLuaWithRootData:data];
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
        //disable the observation
        [self removeObserver:self forKeyPath:@"objectType"];
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

        scale = (double)[coder decodeSInt32] / 4096.0;
        layer = [coder decodeSInt16];
        spriteId = [coder decodeSInt16];
        int iconData = [coder decodeUInt32];
        iconSize = 0x0f & iconData;
        iconShape = 0xf0 & iconData;
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
        [weapons setObject:[[[Weapon alloc] initWithResArchiver:coder
                                                             id:pulseId
                                                          count:pulseCount] autorelease]
                    forKey:@"pulse"];
        [weapons setObject:[[[Weapon alloc] initWithResArchiver:coder
                                                             id:beamId
                                                          count:beamCount] autorelease]
                    forKey:@"beam"];
        [weapons setObject:[[[Weapon alloc] initWithResArchiver:coder
                                                             id:specialId
                                                          count:specialCount] autorelease]
                    forKey:@"special"];

        friendDefecit = [coder decodeFixed];
        dangerThreshold = [coder decodeFixed];

        [coder skip:4u];

        arriveActionDistance = [coder decodeSInt32];


        [actions setObject:[[[DestroyActionRef alloc] initWithResArchiver:coder] autorelease]
                    forKey:@"destroy"];
        [actions setObject:[[[ActionRef alloc] initWithResArchiver:coder] autorelease]
                    forKey:@"expire"];
        [actions setObject:[[[ActionRef alloc] initWithResArchiver:coder] autorelease]
                    forKey:@"create"];
        [actions setObject:[[[ActionRef alloc] initWithResArchiver:coder] autorelease]
                    forKey:@"collide"];
        [actions setObject:[[[ActivateActionRef alloc] initWithResArchiver:coder] autorelease]
                    forKey:@"activate"];
        [actions setObject:[[[ActionRef alloc] initWithResArchiver:coder] autorelease]
                    forKey:@"arrive"];

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
        //And re-enable
        [self addObserver:self forKeyPath:@"objectType" options:NSKeyValueObservingOptionOld context:NULL];
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

    [coder encodeSInt32:scale * 4096];
    [coder encodeSInt16:layer];
    [coder encodeSInt16:spriteId];
    [coder encodeUInt32:((0xf0 & iconShape) | (0x0f & iconSize))];
    [coder encodeUInt8:shieldColor];
    [coder skip:1u];

    [coder encodeSInt32:initialDirection];
    [coder encodeSInt32:initialDirectionRange];

    Weapon *pulse = [weapons objectForKey:@"pulse"];
    Weapon *beam = [weapons objectForKey:@"beam"];
    Weapon *special = [weapons objectForKey:@"special"];
    [coder encodeSInt32:pulse.safeID];
    [coder encodeSInt32:beam.safeID];
    [coder encodeSInt32:special.safeID];
    [coder encodeSInt32:MAX(pulse.positions.count, 3)];
    [coder encodeSInt32:MAX(beam.positions.count, 3)];
    [coder encodeSInt32:MAX(special.positions.count, 3)];
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

- (ObjectType)objectType {
    if ([[attributes valueForKey:@"shapeFromDirection"] boolValue] == YES) {
        return RotationalObject;
    } else if ([[attributes valueForKey:@"isSelfAnimated"] boolValue] == YES) {
        return AnimatedObject;
    } else if ([[attributes valueForKey:@"isBeam"] boolValue] == YES) {
        return BeamObject;
    } else {
        return DeviceObject;
    }
}

+ (NSSet *)keyPathsForValuesAffectingObjectType {
    return [NSSet setWithObjects:@"attributes.shapeFromDirection", @"attributes.isSelfAnimated", @"attributes.isBeam", nil];
}

- (NSString *)specialPanelNib {
    switch ([self objectType]) {
        case RotationalObject:
            return @"RotationEditor";
            break;
        case AnimatedObject:
            return @"AnimationEditor";
            break;
        case BeamObject:
            return @"BeamEditor";
            break;
        case DeviceObject:
            return @"DeviceEditor";
        default:
            return nil;
            break;
    }
}

+ (NSSet *)keyPathsForValuesAffectingSpecialPanelNib {
    return [NSSet setWithObjects:@"objectType", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    switch ([self objectType]) {
        case RotationalObject:
            [self setFrame:[[RotationData alloc] init]];
            break;
        case AnimatedObject:
            [self setFrame:[[AnimationData alloc] init]];
            break;
        case BeamObject:
            [self setFrame:[[BeamData alloc] init]];
            break;
        case DeviceObject:
            [self setFrame:[[DeviceData alloc] init]];
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SpecialParametersChanged" object:self];
}
@end

@implementation Weapon
@synthesize device, positions;
@dynamic safeID;

- (id) init {
    self = [super init];
    if (self) {
        device = nil;
        positions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc {
    [positions release];
    [device release];
    [super dealloc];
}

+ (id) weapon {
    return [[[Weapon alloc] init] autorelease];
}

- (NSInteger) safeID {
    if (device != nil) {
        return device.indexRef.orNull;
    } else {
        return -1;
    }
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        ID = [coder decodeIntegerForKey:@"id"];
        [positions setArray:[coder decodeArrayOfClass:[XSPoint class] forKey:@"positions" zeroIndexed:NO]];
        if ([coder hasKey:@"count"]) {
            int positionCount = [coder decodeIntegerForKey:@"count"];
            int count = positions.count;
            if (count > positionCount) {
                //Trim from the back
                [positions removeObjectsInRange:NSMakeRange(positionCount, count - positionCount)];
            } else if (count < positionCount) {
                //Pad the end
                for (; count < positionCount; count++) {
                    [positions addObject:[XSPoint point]];
                }
            }
        }
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    if (device != nil) {
        [coder encodeInteger:device.indexRef.orNull forKey:@"id"];
    } else {
        [coder encodeInteger:-1 forKey:@"id"];
    }
//    [coder encodeInteger:positionCount forKey:@"count"];//Unnecessary but keep anyway
    [coder encodeArray:positions forKey:@"positions" zeroIndexed:NO];
}

- (void) finishLoadingFromLuaWithRootData:(id)data {
    if (ID != -1) {
        self.device = [[(MainData *)data objects] objectAtIndex:ID];
    }
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
        if (_id != -1) {
            self.device = [coder decodeObjectOfClass:[BaseObject class] atIndex:_id];
        }
        for (int k = 0; k < count; k++) {
            XSPoint *point = [XSPoint point];
            point.y = [coder decodeFixed];
            point.x = [coder decodeFixed];
            [positions addObject:point];
        }
        [coder skip:8u * (3 - count)];
    }
    return self;
}

- (void) encodeResWithCoder:(ResArchiver *)coder {
    int max = MIN(3, positions.count);
    for (int k = 0; k < max; k++) {
        XSPoint *point = [positions objectAtIndex:k];
        [coder encodeFixed:point.y];
        [coder encodeFixed:point.x];
    }
    [coder skip:8u * (3 - max)];
}
@end
