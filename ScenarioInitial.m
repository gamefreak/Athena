//
//  ScenarioInitial.m
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ScenarioInitial.h"
#import "Archivers.h"
#import "XSPoint.h"
#import "XSInteger.h"
#import "XSRange.h"
#import "BaseObject.h"
#import "StringTable.h"

@implementation ScenarioInitial
@synthesize type, owner, position, earning;
@synthesize distanceRange, rotation, rotationRange, spriteIdOverride, builds;
@synthesize initialDestination, nameOverride, attributes, base;
@dynamic realName;

- (id) init {
    self = [super init];
    type = [[Index alloc] init];
    owner = 0;

    position = [[XSPoint alloc] init];

    earning = 1.0f;
    distanceRange = 0;

    rotation = 0;
    rotationRange = 0;

    spriteIdOverride = -1;

    builds = [[NSMutableArray alloc] initWithCapacity:10];

    initialDestination = -1;
    nameOverride = @"";

    attributes = [[ScenarioInitialAttributes alloc] init];
    return self;
}


- (void) dealloc {
    [type release];
    [position release];
    [builds release];
    [nameOverride release];
    [attributes release];
    [base release];
    [super dealloc];
}

//MARK: Lua Coding

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    [type release];
    type = [[coder getIndexRefWithIndex:[coder decodeIntegerForKey:@"type"] forClass:[BaseObject class]] retain];
    owner = [coder decodeIntegerForKey:@"owner"];

    [position release];
    position = [coder decodePointForKey:@"position"];
    [position retain];

    earning = [coder decodeFloatForKey:@"earning"];
    distanceRange = [coder decodeIntegerForKey:@"distanceRange"];

    rotation = [coder decodeIntegerForKeyPath:@"rotation.minimum"];
    rotationRange = [coder decodeIntegerForKeyPath:@"rotation.range"];
    
    rotation = [coder decodeIntegerForKeyPath:@"rotation.minimum"];
    rotationRange = [coder decodeIntegerForKeyPath:@"rotation.range"];

    spriteIdOverride = [coder decodeIntegerForKey:@"spriteIdOverride"];

    [builds release];
    builds = [coder decodeArrayOfClass:[XSInteger class] forKey:@"builds" zeroIndexed:YES];
    [builds retain];

    initialDestination = [coder decodeIntegerForKey:@"initialDestination"];

    [nameOverride release];
    nameOverride = [coder decodeStringForKey:@"nameOverride"];
    [nameOverride retain];

    [attributes release];
    attributes = [coder decodeObjectOfClass:[ScenarioInitialAttributes class]
                                     forKey:@"attributes"];
    [attributes retain];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:type.index forKey:@"type"];
    [coder encodeInteger:owner forKey:@"owner"];
    [coder encodeInteger:initialDestination forKey:@"initialDestination"];
    [coder encodeObject:position forKey:@"position"];

    [coder encodeFloat:earning forKey:@"earning"];
    [coder encodeInteger:distanceRange forKey:@"distanceRange"];

    [coder encodeDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
        [XSInteger xsIntegerWithValue:rotation], @"minimum",
        [XSInteger xsIntegerWithValue:rotation], @"range", nil
                             ] forKey:@"rotation" asArray:NO];

    [coder encodeInteger:spriteIdOverride forKey:@"spriteIdOverride"];

    [coder encodeArray:builds
                forKey:@"builds"
           zeroIndexed:YES];
    
    if ([nameOverride isEqual:@""]) {
        [coder encodeNilForKey:@"nameOverride"];
    } else {
        [coder encodeString:nameOverride forKey:@"nameOverride"];
    }

    [coder encodeObject:attributes forKey:@"attributes"];
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
        int typeId = [coder decodeSInt32];
        if (typeId != -1) {
            type = [[coder getIndexRefWithIndex:typeId forClass:[BaseObject class]] retain];
        } else {
            type = [[Index alloc] init];
        }
        owner = [coder decodeSInt32];
        [coder skip:8u];
        position.x = [coder decodeSInt32];
        position.y = [coder decodeSInt32];
        earning = [coder decodeFixed];
        distanceRange = [coder decodeSInt32];
        rotation = [coder decodeSInt32];
        rotationRange = [coder decodeSInt32];
        spriteIdOverride = [coder decodeSInt32];
        for (NSUInteger i = 0; i < 12; i++) {
            NSInteger tmp = [coder decodeSInt32];
            if (tmp >= 1) {
                [builds addObject:[NSNumber numberWithInteger:tmp]];
            }
        }
        initialDestination = [coder decodeSInt32];
        int nameTable = [coder decodeSInt32];
        int nameNumber = [coder decodeSInt32];
        if ([coder hasObjectOfClass:[StringTable class] atIndex:nameTable] && nameNumber != -1) {
            [nameOverride release];
            nameOverride = [[[coder decodeObjectOfClass:[StringTable class]
                                                atIndex:nameTable] stringAtIndex:nameNumber - 1] retain];
        }
        [attributes initWithResArchiver:coder];
    }
    return self;
}

//- (void)encodeResWithCoder:(ResArchiver *)coder {}

+ (ResType)resType {
    return 'snit';
}

+ (NSString *)typeKey {
    return @"snit";
}

+ (BOOL)isPacked {
    return YES;
}

+ (size_t)sizeOfResourceItem {
    return 108;
}

- (void) findBaseFromArray:(NSArray *)array {
    if (base == nil) {
        base = [[array objectAtIndex:type.index] retain];
    }
}

- (NSString *) realName {
    if ([nameOverride length] > 0) {
        return nameOverride;
    } else if (base != nil) {
        return [base valueForKey:@"name"];
    } else {
        return @"-";
    }

}

static NSSet *nameKeys;
+ (NSSet *) keyPathsForValuesAffectingType {
    if (nameKeys == nil) {
        NSLog(@"+keyPathsForValuesAffectingType");
        nameKeys = [[NSSet alloc] initWithObjects:@"realName", nil];
    }
    return nameKeys;
}

+ (NSSet *) keyPathsForValuesAffectingNameOverride {
    if (nameKeys == nil) {
        NSLog(@"+keyPathsForValuesAffectingNameOverride");
        nameKeys = [[NSSet alloc] initWithObjects:@"realName", nil];
    }
    return nameKeys;
}
@end

static NSArray *snitAttrKeys;
@implementation ScenarioInitialAttributes;
@synthesize fixedRace, initiallyHidden, isPlayerShip, staticDestination;

+ (NSArray *) keys {
    if (snitAttrKeys == nil) {
        snitAttrKeys = [[NSArray alloc]
                        initWithObjects:[NSNull null], [NSNull null], [NSNull null], [NSNull null],
                        @"fixedRace", @"initiallyHidden", [NSNull null], [NSNull null],
                        [NSNull null], @"isPlayerShip", [NSNull null], [NSNull null],
                        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                        [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                        [NSNull null], @"staticDestination", [NSNull null], [NSNull null],
                        [NSNull null], [NSNull null], [NSNull null], [NSNull null], nil];
                        
    }
    return snitAttrKeys;
}
@end

