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

@implementation ScenarioInitial
- (id) init {
    self = [super init];
    type = -1;
    owner = 0;

    position = [[XSPoint alloc] init];

    earning = 1.0f;
    distanceRange = 0;

    rotation = [[XSRange alloc] init];

    spriteIdOverride = -1;

    builds = [[NSMutableArray alloc] initWithCapacity:10];
    for (int k = 0; k < 10; k++) {
        [builds addObject:[XSInteger xsIntegerWithValue:-1]];
    }

    initialDestination = -1;
    nameOverride = @"";

    attributes = [[ScenarioInitialAttributes alloc] init];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    type = [coder decodeIntegerForKey:@"type"];
    owner = [coder decodeIntegerForKey:@"owner"];

    [position release];
    position = [coder decodePointForKey:@"position"];
    [position retain];

    earning = [coder decodeFloatForKey:@"earning"];
    distanceRange = [coder decodeIntegerForKey:@"distanceRange"];

    rotation.first = [coder decodeIntegerForKey:@"minimum"];
    rotation.count = [coder decodeIntegerForKey:@"range"];

    spriteIdOverride = [coder decodeIntegerForKey:@"spriteIdOverride"];

    [builds setArray:[coder decodeArrayOfClass:[XSInteger class]
                                        forKey:@"builds"
                                   zeroIndexed:YES]];

    initialDestination = [coder decodeIntegerForKey:@"initialDestination"];

    [nameOverride release];
    nameOverride = [coder decodeStringForKey:@"nameOverride"];
    [nameOverride retain];

//    [attributes release];
//    attributes = [coder decodeObjectOfClass:[ScenarioInitialAttributes class]
//                                     forKey:@"attributes"];
//    [attributes retain];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:type forKey:@"type"];
    [coder encodeInteger:owner forKey:@"owner"];

    [coder encodeObject:position forKey:@"position"];

    [coder encodeFloat:earning forKey:@"earning"];
    [coder encodeInteger:distanceRange forKey:@"distanceRange"];

    [coder encodeDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
        [XSInteger xsIntegerWithValue:rotation.first], @"minimum",
        [XSInteger xsIntegerWithValue:rotation.count], @"range", nil
                             ] forKey:@"rotation"];

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

- (void) dealloc {
    [position release];
    [builds release];
    [nameOverride release];
    [attributes release];
    [super dealloc];
}

+ (BOOL) isComposite {
    return YES;
}
@end

static NSArray *snitAttrKeys;
@implementation ScenarioInitialAttributes
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

