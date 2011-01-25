//
//  ActionRefs.m
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ActionRefs.h"
#import "Archivers.h"

@implementation ActionRef
- (id) init {
    self = [super init];
    first = 0;
    count = 0;
    return self;
}
- (id) initWithCoder:(LuaUnarchiver *)coder {
    self = [self init];
    first = [coder decodeIntegerForKey:@"first"];
    count = [coder decodeIntegerForKey:@"count"];
    return self;
}

- (void) encodeWithCoder:(LuaArchiver *)coder {
    [coder encodeInteger:first forKey:@"first"];
    [coder encodeInteger:count forKey:@"count"];
}

+ (id) ref {
    return [[[self alloc] init] autorelease];
}
@end

@implementation DestroyActionRef
- (id) init {
    self = [super init];
    dontDestroyOnDeath = NO;
    return self;
}

- (id) initWithCoder:(LuaUnarchiver *)coder {
    self = [super initWithCoder:coder];
    dontDestroyOnDeath = [coder decodeBoolForKey:@"dontDieOnDeath"];
    return self;
}

- (void) encodeWithCoder:(LuaArchiver *)coder {
    [super encodeWithCoder:coder];
    [coder encodeBool:dontDestroyOnDeath forKey:@"dontDieOnDeath"];
}
@end

@implementation ActivateActionRef
- (id) init {
    self = [super init];
    interval = 0;
    intervalRange = 0;
    return self;
}

- (id) initWithCoder:(LuaUnarchiver *)coder {
    self = [super initWithCoder:coder];
    interval = [coder decodeIntegerForKey:@"interval"];
    intervalRange = [coder decodeIntegerForKey:@"intervalRange"];
    return self;
}

- (void) encodeWithCoder:(LuaArchiver *)coder {
    [super encodeWithCoder:coder];
    [coder encodeInteger:interval forKey:@"interval"];
    [coder encodeInteger:intervalRange forKey:@"intervalRange"];
}
@end