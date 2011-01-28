//
//  ActionRefs.m
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ActionRefs.h"
#import "Archivers.h"
#import "Action.h"

@implementation ActionRef
- (id) init {
    self = [super init];
    actions = [[NSMutableArray alloc] init];
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    [actions setArray:[coder decodeArrayOfClass:[Action class] forKey:@"seq" zeroIndexed:YES]];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [coder encodeArray:actions forKey:@"seq" zeroIndexed:YES];
}

+ (id) ref {
    return [[[self alloc] init] autorelease];
}

+ (BOOL) isComposite {
    return YES;
}

+ (Class) classForLuaCoder:(LuaUnarchiver *)coder {
    return self;
}

- (void) dealloc {
    [actions release];
    [super dealloc];
}
@end

@implementation DestroyActionRef
- (id) init {
    self = [super init];
    dontDestroyOnDeath = NO;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    dontDestroyOnDeath = [coder decodeBoolForKey:@"dontDieOnDeath"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
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

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    interval = [coder decodeIntegerForKey:@"interval"];
    intervalRange = [coder decodeIntegerForKey:@"intervalRange"];
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:interval forKey:@"interval"];
    [coder encodeInteger:intervalRange forKey:@"intervalRange"];
}
@end