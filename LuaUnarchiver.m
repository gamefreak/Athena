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
#import "NSString+LuaCoding.h"

static void stackDump (lua_State *L) {
    int i=lua_gettop(L);
    printf(" ----------------  Stack Dump ----------------\n" );
    while(  i   ) {
        int t = lua_type(L, i);
        switch (t) {
            case LUA_TSTRING:
                printf("%d:`%s'\n", i, lua_tostring(L, i));
                break;
            case LUA_TBOOLEAN:
                printf("%d: %s\n",i,lua_toboolean(L, i) ? "true" : "false");
                break;
            case LUA_TNUMBER:
                printf("%d: %g\n",  i, lua_tonumber(L, i));
                break;
            default: printf("%d: %s\n", i, lua_typename(L, t)); break;
        }
        i--;
    }
    printf("--------------- Stack Dump Finished ---------------\n");
}

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
    MainData *decodedObject = [[MainData alloc] initWithLuaCoder:uarch];
    [uarch release];
    return [decodedObject autorelease];
}


- (id) decodeObjectOfClass:(Class<Alloc, NSObject, LuaCoding>)_class forKey:(NSString *)key {
    [self getKey:key];
    Class class = [_class classForLuaCoder:self];
    if ([class isComposite]) {
        assert(lua_istable(L, -1));
    }
    id obj = [[class alloc] initWithLuaCoder:self];
    [self pop];
    return [obj autorelease];
}

- (id) decodeObjectOfClass:(Class<Alloc, LuaCoding>)_class forKeyPath:(NSString *)keyPath {
    NSInteger popCount = [self getKeyPath:keyPath];
    Class class = [_class classForLuaCoder:self];
    if ([class isComposite]) {
        assert(lua_istable(L, -1));
    }
    id obj = [[class alloc] initWithLuaCoder:self];
    [self popN:popCount];
    return [obj autorelease];
}

- (NSMutableArray *) decodeArrayOfClass:(Class<Alloc, LuaCoding>)_class forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed {
    [self getKey:key];
    assert(lua_istable(L, -1));

    /*
     Between the behaviour of lua and NSArray there must be no holes
     in the arrays otherwise I predict that bad things may happen.
     Like not being able to load all of the data.
     */
    //lua_objlen returns the highest index so allocate +1
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:lua_objlen(L, -1) + (isZeroIndexed?1:0)];
    if (isZeroIndexed) {
        lua_pushinteger(L, 0);
        lua_gettable(L, -2);
        if(!lua_isnil(L, -1)) {
            Class class = [_class classForLuaCoder:self];
            id object = [[class alloc] initWithLuaCoder:self];
            [array addObject:object];
            [object release];
        }
        lua_pop(L, 1);
    }
    for (int idx = 1; idx <= lua_objlen(L, -1); idx++) {
        lua_pushinteger(L, idx); //pushes key
        lua_gettable(L, -2); //pops key, pushes value

        Class class = [_class classForLuaCoder:self];
        id object = [[class alloc] initWithLuaCoder:self];
        [array addObject:object];
        [object release];
        lua_pop(L, 1); //pops value
    }
    [self pop]; //pop the array's table
    return array;
}

- (NSMutableDictionary *) decodeDictionaryOfClass:(Class<Alloc, LuaCoding>)_class forKey:(NSString *)key {
    [self getKey:key];
    assert(lua_istable(L, -1));
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    lua_pushnil(L);
    while (lua_next(L, -2) != 0) {
        lua_pushvalue(L, -2);//Make a copy of the key
        NSString *key = [NSString stringWithUTF8String:lua_tostring(L, -1)];//Read the copy
        lua_pop(L, 1);//Pop the copy
        Class class = [_class classForLuaCoder:self];
        id value = [[class alloc] initWithLuaCoder:self];
        [dict setObject:value forKey:key];
        [value release];
        lua_pop(L, 1);
    }
    [self pop];
    return dict;
}

- (BOOL) decodeBool {
    return lua_toboolean(L, -1);
}

- (BOOL) decodeBoolForKey:(NSString *)key {
    [self getKey:key];
    BOOL ret = lua_toboolean(L, -1);
    [self pop];
    return ret;
}

- (BOOL) decodeBoolForKeyPath:(NSString *)keyPath {
    NSUInteger popCount = [self getKeyPath:keyPath];
    assert(lua_isboolean(L, -1));
    BOOL ret = lua_toboolean(L, -1);
    [self popN:popCount];
    return ret;
}

- (NSMutableString *) decodeString {
    //    \\ -> \\\\
    //    \r -> \\r
    //    ]  -> \\]
    if (lua_isnil(L, -1)) {
        return [NSMutableString string];
    }

    NSMutableString *str = [NSMutableString stringWithCString:lua_tostring(L, -1) encoding:NSMacOSRomanStringEncoding];
    return str;
}

- (NSMutableString *) decodeStringForKey:(NSString *)key {
    [self getKey:key];
    NSMutableString *str = [self decodeString];
    [self pop];
    return str;
}

- (NSMutableString *) decodeStringForKeyPath:(NSString *)keyPath {
    NSInteger popCount = [self getKey:keyPath];
    NSMutableString *str = [self decodeString];
    [self popN:popCount];
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
    XSPoint *point = [[XSPoint alloc] initWithLuaCoder: self];
    [self pop];
    return [point autorelease];
}

- (NSInteger) decodeInteger {
    return lua_tointeger(L, -1);
}

- (NSInteger) decodeIntegerForKey:(NSString *)key {
    [self getKey:key];
    NSInteger val = lua_tointeger(L, -1);
    [self pop];
    return val;
}

- (NSInteger) decodeIntegerForKeyPath:(NSString *)keyPath {
    NSInteger popCount = [self getKeyPath:keyPath];
    NSInteger val = lua_tointeger(L, -1);
    [self popN:popCount];
    return val;
}
@end
