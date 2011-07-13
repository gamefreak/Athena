//
//  LuaUnarchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"
#import "LuaCoding.h"

@class XSPoint, Index;

@interface LuaUnarchiver : NSCoder {
    lua_State *L;
    NSMutableDictionary *refTable;
    NSString *baseDir;
}
@property (readwrite, retain) NSString *baseDir;
+ (id) unarchiveObjectWithData:(NSData *)data baseDirectory:(NSString *)baseDir;
- (void) loadData:(NSData *)data;

- (BOOL) hasKey:(NSString *)key;
- (BOOL) hasKeyPath:(NSString *)keyPath;

- (id) decodeObjectOfClass:(Class<Alloc, LuaCoding>)class forKey:(NSString *)key;
- (id) decodeObjectOfClass:(Class<Alloc, LuaCoding>)class forKeyPath:(NSString *)keyPath;

- (NSMutableArray *) decodeArrayOfClass:(Class<Alloc, LuaCoding>)_class forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed;
- (NSMutableDictionary *) decodeDictionaryOfClass:(Class<Alloc, LuaCoding>)class forKey:(NSString *)key;

- (BOOL) decodeBool;
- (BOOL) decodeBoolForKeyPath:(NSString *)keyPath;

- (NSMutableString *) decodeString;
- (NSMutableString *) decodeStringForKey:(NSString *)key;
- (NSMutableString *) decodeStringForKeyPath:(NSString *)keyPath;

- (XSPoint *) decodePointForKey:(NSString *)key;
- (NSInteger) decodeInteger;
- (NSInteger) decodeIntegerForKeyPath:(NSString *)keyPath;

- (Index *) getIndexRefWithIndex:(NSUInteger)index forClass:(Class<LuaCoding>)class;

- (NSString *) topKey;
@end
