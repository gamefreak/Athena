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

- (id) string {
    return self;
}

- (NSComparisonResult) numericCompare:(NSString *)string {
    return [self compare:string options:NSNumericSearch];
}
@end
