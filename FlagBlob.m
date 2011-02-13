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
+ (NSArray *) keys {
    if (attributeBlobKeys == nil) {
        attributeBlobKeys = [[NSArray alloc] init];
    }
    return attributeBlobKeys;
    
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
                [self setValue:[NSNumber numberWithBool:hex & 1 << position++] forKey:key];
            }
        }
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
//    UInt32 hex = 0x00000000;
//    int ctr = 0;
//    NSArray *keys = [[self class] keys];
//    for (id key in keys) {
//        if (key == [NSNull null]) {
//            continue;
//        }
//        hex |= 1 << ctr++;
//    }
//    [coder encodeUInt32:hex];
}
@end
