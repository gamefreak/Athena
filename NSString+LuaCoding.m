//
//  NSString+LuaCoding.m
//  Athena
//
//  Created by Scott McClaugherty on 1/26/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "NSString+LuaCoding.h"
#import "Archivers.h"

@implementation NSString (LuaCoding)
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
@end
