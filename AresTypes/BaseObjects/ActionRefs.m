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
    if (self) {
        actions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc {
    [actions release];
    [super dealloc];
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [self init];
    if (self) {
        [actions setArray:[coder decodeArrayOfClass:[Action class] forKey:@"seq" zeroIndexed:YES]];
    }
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

- (void) encodeResWithCoder:(ResArchiver *)coder {
    NSEnumerator *enumerator = [actions objectEnumerator];
    first = -1;
    if ([actions count] > 0) {
        first = [coder encodeObject:[enumerator nextObject]];
    }
    for (Action *action in enumerator) {
        [coder encodeObject:action];
    }
    [coder encodeSInt32:first];
    [coder encodeSInt32:[actions count]];
}
@end

@implementation DestroyActionRef
@synthesize dontDestroyOnDeath;

- (id) init {
    self = [super init];
    if (self) {
        dontDestroyOnDeath = NO;
    }
    return self;
}

- (id) initWithLuaCoder:(LuaUnarchiver *)coder {
    self = [super initWithLuaCoder:coder];
    if (self) {
        dontDestroyOnDeath = [coder decodeBoolForKey:@"dontDieOnDeath"];
    }
    return self;
}

- (void) encodeLuaWithCoder:(LuaArchiver *)coder {
    [super encodeLuaWithCoder:coder];
    [coder encodeBool:dontDestroyOnDeath forKey:@"dontDieOnDeath"];
}

- (id)initWithResArchiver:(ResUnarchiver *)coder {
    self = [super init];
    if (self) {
        first  = [coder decodeSInt32];
        count = [coder decodeSInt32];
        dontDestroyOnDeath = (0x80000000&count?YES:NO);
        count &= 0x7fffffff;
        for (int k = 0; k < count; k++) {
            [actions addObject:[coder decodeObjectOfClass:[Action class] atIndex:first + k]];
        }
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    NSEnumerator *enumerator = [actions objectEnumerator];
    first = -1;
    if ([actions count] > 0) {
        first = [coder encodeObject:[enumerator nextObject]];
    }
    for (Action *action in enumerator) {
        [coder encodeObject:action];
    }
    [coder encodeSInt32:first];
    [coder encodeSInt32:([actions count] & 0x7fffffff) | (dontDestroyOnDeath << 31)];
}
@end

@implementation ActivateActionRef
@synthesize interval, intervalRange;

- (id) init {
    self = [super init];
    if (self) {
        interval = 0;
        intervalRange = 0;
    }
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
    self = [super init];
    if (self) {
        first  = [coder decodeSInt32];
        count = [coder decodeSInt32];
        interval = (0xff000000 & count) >> 24;
        intervalRange = (0x00ff0000 & count) >> 16;
        count &= 0x0000ffff;
        for (int k = 0; k < count; k++) {
            [actions addObject:[coder decodeObjectOfClass:[Action class] atIndex:first + k]];
        }
    }
    return self;
}

- (void)encodeResWithCoder:(ResArchiver *)coder {
    NSEnumerator *enumerator = [actions objectEnumerator];
    first = -1;
    if ([actions count] > 0) {
        first = [coder encodeObject:[enumerator nextObject]];
    }
    for (Action *action in enumerator) {
        [coder encodeObject:action];
    }
    count = [actions count];
    count &= 0x0000ffff;
    count |= (0xff & interval) << 24;
    count |= (0xff & intervalRange) << 16;
    [coder encodeSInt32:first];
    [coder encodeSInt32:[actions count]];
}
@end
