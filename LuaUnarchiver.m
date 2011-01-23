//
//  LuaUnarchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LuaUnarchiver.h"
#import "MainData.h"
#import "XSPoint.h"
#import "lualib.h"
#import "lauxlib.h"

@interface LuaUnarchiver (Private)
- (NSUInteger) getKey:(NSString *)key;
- (NSUInteger) getKeyPath:(NSString *)keyPath;
- (void) pop;
- (void) popN:(NSUInteger)n;
@end

@implementation LuaUnarchiver (Private)
- (NSUInteger) getKey:(NSString *)key {
    lua_pushstring(L, [key UTF8String]);
    lua_gettable(L, -2);
    return 1;
}

- (NSUInteger) getKeyPath:(NSString *)keyPath {
    NSArray *components = [keyPath componentsSeparatedByString:@"."];
    for (id subKey in components) {
        lua_pushstring(L, [subKey UTF8String]);
        lua_gettable(L, -2);
    }
    return [components count];
}

- (void) pop {
    lua_pop(L, 1);
}

- (void) popN:(NSUInteger)n {
    lua_pop(L, n);
}
@end



@implementation LuaUnarchiver
- (id) init {
    [super init];
    L = luaL_newstate();
    if (L == NULL) @throw @"Failed to open lua state.";
    return self;
}

- (void) loadData:(NSData *)data {
    int err;

    err = luaL_loadbuffer(L, [data bytes], [data length], "mainData");
    if (err != 0) @throw [NSString stringWithFormat:@"Lua Error: %s", lua_tostring(L, -1)];
    
    err = lua_pcall(L, 0, 0, 0);
    if (err != 0) @throw [NSString stringWithFormat:@"Lua Error: %s", lua_tostring(L, -1)];
    
    lua_getglobal(L, "data");
    
    assert(lua_gettop(L) == 1);
    assert(lua_istable(L, -1));
}

- (void) dealloc {
    [super dealloc];
    lua_close(L);
}

+ (id)unarchiveObjectWithData:(NSData *)data {
    LuaUnarchiver *uarch = [[LuaUnarchiver alloc] init];
    [uarch loadData:data];
    
    //Remember: MainData is hardcoded here
    MainData *decodedObject = [[MainData alloc] initWithCoder:uarch];
    [uarch release];
    return [decodedObject autorelease];
}


- (id) decodeObjectOfClass:(Class<NSCoding>)class forKey:(NSString *)key {
    [self getKey:key];
    assert(lua_istable(L, -1));
    id obj = [[class alloc] initWithCoder:self];
    [self pop];
    return [obj autorelease];
}

- (NSMutableArray *) decodeArrayOfClass:(Class<NSCoding>)class forKey:(NSString *)key {
    [self getKey:key];
    assert(lua_istable(L, -1));

    /*
     Between the behaviour of lua and NSArray there must be no holes
     in the arrays otherwise I predict that bad things may happen.
     Like not being able to load all of the data.
     */
    //lua_objlen returns the highest index so allocate +1
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:lua_objlen(L, -1) + 1];
    for (int idx = 0; idx <= lua_objlen(L, -1); idx++) {
        lua_pushinteger(L, idx); //pushes key
        lua_gettable(L, -2); //pops key, pushes value
        //I would like to make this warning go away \/
        id object = [[class alloc] initWithCoder:self];
        [array addObject:object];
        [object release];
        lua_pop(L, 1); //pops value
    }
    [self pop]; //pop the array's table
    return array;
}


- (BOOL) decodeBoolForKey:(NSString *)key {
    [self getKey:key];
    assert(lua_isboolean(L, -1));
    BOOL ret = lua_toboolean(L, -1);
    [self pop];
    return ret;
}

- (NSString *) decodeStringForKey:(NSString *)key {
    [self getKey:key];
    assert(lua_isstring(L, -1));
    //    \\ -> \\\\
    //    \r -> \\r
    //    ]  -> \\]
    NSMutableString *str = [NSMutableString stringWithUTF8String:lua_tostring(L, -1)];
    [str replaceOccurrencesOfString:@"\\"
                         withString:@"\\\\"
                            options:NSLiteralSearch
                              range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"\r"
                         withString:@"\\r"
                            options:NSLiteralSearch
                              range:NSMakeRange(0, [str length])];
    [self pop];
    return str;
}

- (float) decodeFloatForKey:(NSString *)key {
    [self getKey:key];
    float value = lua_tonumber(L, -1);
    [self pop];
    return value;
}

- (XSPoint *) decodePointForKey:(NSString *)key {
    [self getKey:key];
    XSPoint *point = [[XSPoint alloc] initWithCoder: self];
    [self pop];
    return [point autorelease];
}

- (NSInteger) decodeIntegerForKey:(NSString *)key {
    [self getKey:key];
    NSInteger val = lua_tointeger(L, -1);
    [self pop];
    return val;
}

@end
