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
- (id) init {
    self = [super init];
    name = @"Untitled";
    shortName = @"UNTITLED";
    notes = @"";
    staticName = @"Untitled";

    attributes = [[BaseObjectAttributes alloc] init];
    buildFlags = [[BaseObjectBuildFlags alloc] init];
    orderFlags = [[BaseObjectOrderFlags alloc] init];

    class = -1;
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

    class = [coder decodeIntegerForKey:@"class"];
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

    [coder encodeInteger:class forKey:@"class"];
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

    [coder encodeFloat:mass forKey:@"mass"];
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

    [coder encodeDictionary:weapons forKey:@"weapons"];

    [coder encodeFloat:friendDefecit forKey:@"friendDefecit"];
    [coder encodeFloat:dangerThreshold forKey:@"dangerThreshold"];

//    [coder encodeInteger:specialDirection forKey:@"specialDirection"];

    [coder encodeInteger:arriveActionDistance forKey:@"arriveActionDistance"];

    [coder encodeDictionary:actions forKey:@"actions"];

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

+ (BOOL) isComposite {
    return YES;
}
@end

@implementation Weapon
- (id) init {
    self = [super init];
    ID = -1;
    positionCount = 0;
    positions = [[NSMutableArray alloc] initWithObjects:[XSPoint point], [XSPoint point], [XSPoint point], nil];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    ID = [coder decodeIntegerForKey:@"id"];
    positionCount = [coder decodeIntegerForKey:@"count"];
    [positions setArray:[coder decodeArrayOfClass:[XSPoint class] forKey:@"positions" zeroIndexed:NO]];
    NSInteger arrayShortfall = 3 - [positions count];
    for (NSInteger i = 0; i < arrayShortfall; i++) {
        [positions addObject:[XSPoint point]];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:ID forKey:@"id"];
    [coder encodeInteger:positionCount forKey:@"count"];
    [coder encodeArray:positions forKey:@"positions" zeroIndexed:NO];
}

- (void) dealloc {
    [positions release];
    [super dealloc];
}

+ (id) weapon {
    return [[[Weapon alloc] init] autorelease];
}

+ (BOOL) isComposite {
    return YES;
}
@end
