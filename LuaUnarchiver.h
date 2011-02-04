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

@protocol Alloc + (id) alloc; @end
@interface NSObject (ALLOC_DO_YOU_SPEAK_IT) <Alloc> @end

@interface LuaUnarchiver : NSCoder {
    lua_State *L;
}
+ (id) unarchiveObjectWithData:(NSData *)data;
- (void) loadData:(NSData *)data;
- (id) decodeObjectOfClass:(Class<Alloc, LuaCoding>)class forKey:(NSString *)key;
- (id) decodeObjectOfClass:(Class<Alloc, LuaCoding>)class forKeyPath:(NSString *)keyPath;
- (NSMutableArray *) decodeArrayOfClass:(Class<Alloc, LuaCoding>)_class forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed;
- (NSMutableDictionary *) decodeDictionaryOfClass:(Class<Alloc, LuaCoding>)class forKey:(NSString *)key;
- (BOOL) decodeBool;
- (BOOL) decodeBoolForKeyPath:(NSString *)keyPath;

- (NSString *) decodeString;
- (NSString *) decodeStringForKey:(NSString *)key;
- (NSString *) decodeStringForKeyPath:(NSString *)keyPath;

- (XSPoint *) decodePointForKey:(NSString *)key;
- (NSInteger) decodeInteger;
- (NSInteger) decodeIntegerForKeyPath:(NSString *)keyPath;

@end
