//
//  XSBool.m
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSBool.h"
#import "Archivers.h"

@implementation XSBool
@synthesize value;

- (id) initWithBool:(BOOL)_value {
    self = [super init];
    value = _value;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super init];
    value = [coder decodeBool];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeBool:value];
}

+ (id) yes {
    return [[[XSBool alloc] initWithBool:YES] autorelease];
}
+ (id) no {
    return [[[XSBool alloc] initWithBool:NO] autorelease];
}

- (NSString *) description {
    return (value?@"YES":@"NO");
}

+ (BOOL) isComposite {
    return NO;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

+ (id) boolWithBool:(BOOL)_bool {
    return [[[XSBool alloc] initWithBool:_bool] autorelease];
}
@end
