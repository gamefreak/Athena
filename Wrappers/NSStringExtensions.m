//
//  NSStringExtensions.m
//  Athena
//
//  Created by Scott McClaugherty on 1/26/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "NSStringExtensions.h"
#import "Archivers.h"

@implementation NSString (NSStringExtensions)
- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self initWithString:[coder decodeString]];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeString:self];
}

+ (BOOL) isComposite {
    return NO;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

- (unsigned short)unsignedShortValue {
    return (unsigned short)[self intValue];
}

- (id) string {
    return self;
}

- (NSComparisonResult) numericCompare:(NSString *)string {
    return [self compare:string options:NSNumericSearch];
}

- (BOOL)isEqualToCaseInsensitiveString:(NSString *)string {
    return [self caseInsensitiveCompare:string] ==  NSOrderedSame;
}
@end
