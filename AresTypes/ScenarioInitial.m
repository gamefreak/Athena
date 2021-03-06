//
//  ScenarioInitial.m
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ScenarioInitial.h"
#import "MainData.h"
#import "Archivers.h"
#import "XSPoint.h"
#import "XSInteger.h"
#import "XSRange.h"
#import "BaseObject.h"
#import "StringTable.h"

@implementation ScenarioInitial
@synthesize type, owner, position, earning;
@synthesize distanceRange, rotation, rotationRange, spriteIdOverride, builds;
@synthesize initialDestination, nameOverride, attributes;
@dynamic realName;

- (id) init {
    self = [super init];
    if (self) {
        type = nil;
        owner = 0;

        position = [[XSIPoint alloc] init];

        earning = 1.0f;
        distanceRange = 0;

        rotation = 0;
        rotationRange = 0;

        spriteIdOverride = -1;

        builds = [[NSMutableArray alloc] initWithCapacity:10];

        initialDestination = -1;
        nameOverride = @"";

        attributes = [[ScenarioInitialAttributes alloc] init];
    }
    return self;
}


- (void) dealloc {
    [type release];
    [position release];
    [builds release];
    [nameOverride release];
    [attributes release];
    [super dealloc];
}

//MARK: Lua Coding

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        typeId = [coder decodeIntegerForKey:@"type"];
        owner = [coder decodeIntegerForKey:@"owner"];

        position.point = [coder decodePointForKey:@"position"].point;

        earning = [coder decodeFloatForKey:@"earning"];
        distanceRange = [coder decodeIntegerForKey:@"distanceRange"];

        rotation = [coder decodeIntegerForKeyPath:@"rotation.minimum"];
        rotationRange = [coder decodeIntegerForKeyPath:@"rotation.range"];

        spriteIdOverride = [coder decodeIntegerForKey:@"spriteIdOverride"];

        self.builds = [coder decodeArrayOfClass:[XSInteger class] forKey:@"builds" zeroIndexed:YES];

        initialDestination = [coder decodeIntegerForKey:@"initialDestination"];

        self.nameOverride = [coder decodeStringForKey:@"nameOverride"];

        self.attributes = [coder decodeObjectOfClass:[ScenarioInitialAttributes class]
                                              forKey:@"attributes"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:(type != nil?type.indexRef.orNull:-1) forKey:@"type"];
    [coder encodeInteger:owner forKey:@"owner"];
    [coder encodeInteger:initialDestination forKey:@"initialDestination"];
    [coder encodeObject:position forKey:@"position"];

    [coder encodeFloat:earning forKey:@"earning"];
    [coder encodeInteger:distanceRange forKey:@"distanceRange"];

    [coder encodeDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
        [XSInteger xsIntegerWithValue:rotation], @"minimum",
        [XSInteger xsIntegerWithValue:rotationRange], @"range", nil
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

- (void) finishLoadingFromLuaWithRootData:(id)data {
    self.type = [[(MainData *)data objects] objectAtIndex:typeId];
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
        typeId = [coder decodeSInt32];
        if (typeId != -1) {
            self.type = [coder decodeObjectOfClass:[BaseObject class] atIndex:typeId];
        } else {
            self.type = nil;
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
                [builds addObject:[XSInteger xsIntegerWithValue:tmp]];
            }
        }
        initialDestination = [coder decodeSInt32];
        int nameTable = [coder decodeSInt32];
        int nameNumber = [coder decodeSInt32];
        if ([coder hasObjectOfClass:[StringTable class] atIndex:nameTable] && nameNumber > 0) {
            [nameOverride release];
            nameOverride = [[[coder decodeObjectOfClass:[StringTable class]
                                                atIndex:nameTable] stringAtIndex:nameNumber - 1] retain];
        }
        [attributes initWithResArchiver:coder];
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeSInt32:(type != nil?type.indexRef.orNull:-1)];
    [coder encodeSInt32:owner];
    [coder skip:8u];
    [coder encodeSInt32:position.x];
    [coder encodeSInt32:position.y];
    [coder encodeFixed:earning];
    [coder encodeSInt32:distanceRange];
    [coder encodeSInt32:rotation];
    [coder encodeSInt32:rotationRange];
    [coder encodeSInt32:spriteIdOverride];
    int k = 0;
    int builtCount = [builds count];
    for (; k < builtCount; k++) {
        [coder encodeSInt32:[(XSInteger *)[builds objectAtIndex:k] value]];
    }
    for (; k < 12; k++) {
        [coder encodeSInt32:-1];
    }
    [coder encodeSInt32:initialDestination];
    if ([nameOverride isNotEqualTo:@""]) {
        [coder encodeSInt32:STRPlanetBaseNames];
        [coder encodeSInt32:[coder addString:nameOverride toStringTable:STRPlanetBaseNames]+1];
    } else {
        [coder encodeSInt32:-1];
        [coder encodeSInt32:-1];
    }
    [attributes encodeResWithCoder:coder];
}

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

- (NSString *) realName {
    if ([nameOverride length] > 0) {
        return nameOverride;
    } else if (type != nil) {
        return [type valueForKey:@"name"];
    } else {
        return @"-";
    }

}

@end

static NSArray *snitAttrKeys;
@implementation ScenarioInitialAttributes
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

