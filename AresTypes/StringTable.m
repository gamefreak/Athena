//
//  StringTable.m
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "StringTable.h"
#import "Archivers.h"

@implementation StringTable

- (id)init {
    self = [super init];
    if (self) {
        strings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self= [super init];
    if (self) {
        SInt16 count = [coder decodeSInt16];
        strings = [[NSMutableArray alloc] initWithCapacity:count];
        for (SInt16 k = 0; k < count; k++) {
            [strings addObject:[coder decodePString]];
        }
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    short count = [strings count];
    [coder encodeSInt16:count];
    for (NSString *str in strings) {
        [coder encodePString:str];
    }
}

+ (ResType)resType {
    return 'STR#';
}

+ (NSString *)typeKey {
    return @"STR#";
}

+ (BOOL)isPacked {
    return NO;
}

- (NSString *)stringAtIndex:(NSUInteger)index {
    return [strings objectAtIndex:index];
}

- (NSUInteger)addString:(NSString *)string {
    [strings addObject:string];
    return [strings count] - 1;
}

- (NSUInteger)addUniqueString:(NSString *)string {
    NSUInteger found = [strings indexOfObject:string];
    if (found == NSNotFound) {
        return [self addString:string];
    } else {
        return found;
    }

}

- (NSMutableArray *) allStrings {
    return strings;
}

- (void)dealloc {
    [strings release];
    [super dealloc];
}

- (NSString *) description {
    return [NSString stringWithFormat:@"StringTable = %@", strings];
}

@end
