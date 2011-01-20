//
//  LuaUnarchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LuaUnarchiver.h"
#import "MainData.h"

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

- (NSMutableArray *) decodeArrayOfClass:(Class<NSCoding>)class forKey:(NSString *)key {
    lua_pushstring(L, [key UTF8String]);
    lua_gettable(L, -2);
    assert(lua_istable(L, -1));

    /*
     Between the behaviour of lua and NSArray there must be no holes
     in the arrays otherwise I predict that bad things may happen.
     Like not being able to load all of the data.
     */
    //lua_objlen returns the highest index so allocate +1
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:lua_objlen(L, -1) + 1];
    for (int idx = 0; idx < lua_objlen(L, -1); idx++) {
        lua_pushinteger(L, idx); //pushes key
        lua_gettable(L, -2); //pops key, pushes value
        //I would like to make this warning go away \/
        id object = [[class alloc] initWithCoder:self];
        [array addObject:object];
        [object release];
        lua_pop(L, 1); //pops value
    }
    lua_pop(L, 1); //pop the array's table
    return array;
}
@end
