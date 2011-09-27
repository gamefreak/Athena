//
//  LuaUnarchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "LuaUnarchiver.h"
#import "MainData.h"
#import "XSPoint.h"
#import "lualib.h"
#import "lauxlib.h"
#import "NSStringExtensions.h"
#import "IndexedObject.h"
#import "XSKeyValuePair.h"


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
    if (lua_gettop(L) == 0) {
        lua_getglobal(L, [key UTF8String]);
    } else {
        lua_pushstring(L, [key UTF8String]);
        lua_gettable(L, -2);
    }
    return 1;
}

- (NSUInteger) getKeyPath:(NSString *)keyPath {
    NSArray *components = [keyPath componentsSeparatedByString:@"."];
    for (id subKey in components) {
        if (lua_gettop(L) == 0) {
            lua_getglobal(L, [subKey UTF8String]);
        } else {
            lua_pushstring(L, [subKey UTF8String]);
            lua_gettable(L, -2);
        }
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
@synthesize baseDir;
- (id) init {
    self = [super init];
    if (self) {
        baseDir = nil;
        L = luaL_newstate();
        if (L == NULL) @throw @"Failed to open lua state.";
    }
    return self;
}

- (void) loadData:(NSData *)data {
    int err;

    err = luaL_loadbuffer(L, [data bytes], [data length], "mainData");
    if (err != 0) @throw [NSString stringWithFormat:@"Lua Error: %s", lua_tostring(L, -1)];
    
    err = lua_pcall(L, 0, 0, 0);
    if (err != 0) @throw [NSString stringWithFormat:@"Lua Error: %s", lua_tostring(L, -1)];

    assert(lua_gettop(L) == 0);
}

- (void) dealloc {
    [refTable release];
    [baseDir release];
    lua_close(L);
    [super dealloc];
}

- (NSData *)fileNamed:(NSString *)name inDirectory:(NSString *)directory {
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@":"];
    NSFileWrapper *cursor = baseDir;
    NSArray *path = [directory pathComponents];
    for (NSString *component in path) {
        cursor = [[cursor fileWrappers] objectForKey:component];
    }
    return [[[cursor fileWrappers] objectForKey:name] regularFileContents];
}

- (BOOL) hasKey:(NSString *)key {
    [self getKey:key];
    BOOL result = !lua_isnil(L, -1);
    [self pop];
    return result;
}

 - (BOOL) hasKeyPath:(NSString *)keyPath {
     int n = [self getKeyPath:keyPath];
     BOOL result = !lua_isnil(L, -1);
     [self popN:n];
     return result;
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

    BOOL useIndexRefs = [[[[_class alloc] init] autorelease] isKindOfClass:[IndexedObject class]];

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
            if (useIndexRefs) {
                [object setIndexRef:[self getIndexRefWithIndex:0 forClass:_class]];
            }
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
        if (useIndexRefs) {
            [object setIndexRef:[self getIndexRefWithIndex:idx forClass:_class]];
        }
        [array addObject:object];
        [object release];
        lua_pop(L, 1); //pops value
    }
    [self pop]; //pop the array's table
    return array;
}

- (NSMutableArray *) decodePairArrayOfClass:(Class<Alloc, LuaCoding>)_class forKey:(NSString *)key {
    [self getKey:key];
    assert(lua_istable(L, -1));
    NSMutableArray *array = [NSMutableArray array];
    lua_pushnil(L);
    while (lua_next(L, -2) != 0) {
        lua_pushvalue(L, -2);
        NSString *key = [NSString stringWithUTF8String:lua_tostring(L, -1)];
        lua_pop(L, 1);
        Class class = [_class classForLuaCoder:self];
        id value = [[[class alloc] initWithLuaCoder:self] autorelease];
        [array addObject:[XSKeyValuePair pairWithKey:key value:value]];
        lua_pop(L, 1);
    }
    [self pop];
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

//    NSMutableString *str = [NSMutableString stringWithCString:lua_tostring(L, -1) encoding:NSMacOSRomanStringEncoding];
    NSMutableString *str = [NSMutableString stringWithCString:lua_tostring(L, -1) encoding:NSUTF8StringEncoding];
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

- (Index *) getIndexRefWithIndex:(NSUInteger)index forClass:(Class<LuaCoding>)class {
    NSMutableDictionary *table = [refTable objectForKey:class];
    if (table == nil) {
        table = [NSMutableDictionary dictionary];
        [refTable setObject:table forKey:class];
    }
    NSString *key = [[NSNumber numberWithUnsignedInteger:index] stringValue];
    Index *indexRef = [table objectForKey:key];
    if (indexRef == nil) {
        indexRef = [[Index alloc] initWithIndex:index];
        [table setObject:indexRef forKey:key];
        [indexRef autorelease];
    }
    return indexRef;
}

- (NSString *)topKey {
    lua_pushvalue(L, -2);
    NSString *str = [NSString stringWithCString:lua_tostring(L, -1) encoding:NSUTF8StringEncoding];
    lua_pop(L, 1);
    return str;
}
@end
