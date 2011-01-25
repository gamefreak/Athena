//
//  LuaUnarchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "lua.h"
#import "LuaCoding.h"

@class XSPoint;


@interface LuaUnarchiver : NSCoder {
    lua_State *L;
}
+ (id) unarchiveObjectWithData:(NSData *)data;
- (void) loadData:(NSData *)data;
- (id) decodeObjectOfClass:(Class<LuaCoding>)class forKey:(NSString *)key;
- (id) decodeObjectOfClass:(Class<LuaCoding>)class forKeyPath:(NSString *)keyPath;
- (NSMutableArray *) decodeArrayOfClass:(Class<LuaCoding>)_class forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed;
- (NSMutableDictionary *) decodeDictionaryOfClass:(Class<LuaCoding>)class forKey:(NSString *)key;
- (BOOL) decodeBool;
- (BOOL) decodeBoolForKeyPath:(NSString *)keyPath;
- (NSString *) decodeStringForKey:(NSString *)key;
- (XSPoint *) decodePointForKey:(NSString *)key;
- (NSInteger) decodeInteger;

@end
