//
//  FlagBlob.m
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "FlagBlob.h"
#import "Archivers.h"

static NSArray *attributeBlobKeys;
@implementation FlagBlob
@dynamic hex;

- (NSUInteger) hex {
    NSUInteger hex = 0x00000000;
    NSArray *keys = [[self class] keys];
    NSInteger position = 0;
    for (id key in keys) {
        if (key != [NSNull null]) {
            hex |= [[self valueForKey:key] boolValue] << position;
        }
        position++;
    }
    return hex;
}

- (void) setHex:(NSUInteger)hex {
    NSArray *keys = [[self class] keys];
    NSInteger position = 0;
    for (id key in keys) {
        if (key == [NSNull null]) {
            continue;
        }
        if (hex & 1 << position) {
            [self setValue:[NSNumber numberWithBool:YES] forKey:key];
        } else {
            [self setValue:[NSNumber numberWithBool:NO] forKey:key];
        }
        position++;
    }
}

+ (NSArray *) keys {
    if (attributeBlobKeys == nil) {
        attributeBlobKeys = [[NSArray alloc] init];
    }
    return attributeBlobKeys;
    
}

+ (NSArray *)names {
    //To be separeately overridden in a subclass
    return [self keys];
}

- (id) init {
    self = [super init];
    NSArray *keys = [[self class] keys];
    for (id key in keys) {
        if (key == [NSNull null]) {
            continue;
        }
        [self setValue:[NSNumber numberWithBool:NO] forKey:key];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    FlagBlob *new = [[[self class] allocWithZone:zone] init];
    [new setHex:[self hex]];
    return new;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    NSArray *keys = [[self class] keys];
    for (id key in keys) {
        if (key == [NSNull null]) {
            continue;
        }
        [self setValue:[NSNumber numberWithBool:[coder decodeBoolForKey:key]]
                forKey:key];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    NSUInteger hex = 0x00000000;
    NSArray *keys = [[self class] keys];
    NSInteger position = 0;
    for (id key in keys) {
        if (key == [NSNull null]) {
            continue;
        }
        [coder encodeBool:[[self valueForKey:key] boolValue] forKey:key];
        hex |= 1 << position;
        position++;
    }
    [coder encodeInteger:hex forKey:@"hex"];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

- (id) initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        NSArray *keys = [[self class] keys];
        UInt32 hex = [coder decodeUInt32];
        int position = 0;
        for (id key in keys) {
            if (key != [NSNull null]) {
                [self setValue:[NSNumber numberWithBool:((hex & 1 << position)?YES:NO)] forKey:key];
            }
            position++;
        }
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    [coder encodeUInt32:self.hex];
}
@end
