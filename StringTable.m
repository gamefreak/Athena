//
//  StringTable.m
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "StringTable.h"


@implementation StringTable

- (id)init {
    self = [super init];
    if (self) {
        strings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithResArchiver:(ResUnarchiver *)unarchiver {
    self= [self init];
    if (self) {
        
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)archiver {
    
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

- (void)dealloc {
    [strings release];
    [super dealloc];
}

@end
