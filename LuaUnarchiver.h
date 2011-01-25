//
//  LuaUnarchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "lua.h"

@class XSPoint;

@interface LuaUnarchiver : NSCoder {
    lua_State *L;
}
+ (id) unarchiveObjectWithData:(NSData *)data;
- (void) loadData:(NSData *)data;
- (id) decodeObjectOfClass:(Class<NSCoding>)class forKey:(NSString *)key;
- (id) decodeObjectOfClass:(Class<NSCoding>)class forKeyPath:(NSString *)keyPath;
- (NSMutableArray *) decodeArrayOfClass:(Class)_class forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed;
- (NSMutableDictionary *) decodeDictionaryOfClass:(Class)class forKey:(NSString *)key;
- (NSString *) decodeStringForKey:(NSString *)key;
- (XSPoint *) decodePointForKey:(NSString *)key;

@end
