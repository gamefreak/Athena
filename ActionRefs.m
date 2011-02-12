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
@synthesize actions;

- (id) init {
    self = [super init];
    actions = [[NSMutableArray alloc] init];
    return self;
}

- (void) dealloc {
    [actions release];
    [super dealloc];
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

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [self init];
    if (self) {
        first  = [coder decodeSInt32];
        count = [coder decodeSInt32];
        for (int k = 0; k < count; k++) {
            [actions addObject:[coder decodeObjectOfClass:[Action class] atIndex:first + k]];
        }
    }
    return self;
}

//- (void)encodeResWithCoder:(ResArchiver *)coder {}
@end

@implementation DestroyActionRef
@synthesize dontDestroyOnDeath;

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

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        dontDestroyOnDeath = (0x80000000&count?YES:NO);
        count &= 0x7fffffff;
    }
    return self;
}

//- (void)encodeResWithCoder:(ResArchiver *)coder {}
@end

@implementation ActivateActionRef
@synthesize interval, intervalRange;

- (id) init {
    self = [super init];
    interval = 0;
    intervalRange = 0;
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        interval = [coder decodeIntegerForKey:@"interval"];
        intervalRange = [coder decodeIntegerForKey:@"intervalRange"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeInteger:interval forKey:@"interval"];
    [coder encodeInteger:intervalRange forKey:@"intervalRange"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super initWithResArchiver:coder];
    if (self) {
        interval = (0xff000000 & count) >> 24;
        intervalRange = (0x00ff0000 & count) >> 16;
        count &= 0x0000ffff;
    }
    return self;
}

//- (void)encodeResWithCoder:(ResArchiver *)coder {}
@end