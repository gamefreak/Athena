//
//  LuaArchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 1/21/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"

@class XSPoint;

@interface LuaArchiver : NSCoder {
    NSMutableString *data;
    NSUInteger depth;
}
@property (readonly) NSData *data;
+ (NSData *) archivedDataWithRootObject:(id<LuaCoding>)object withName:(NSString *)name;
- (void) encodeArray:(NSArray *)array forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed;
- (void) encodeDictionary:(NSDictionary *)dict forKey:(NSString *)key asArray:(BOOL)asArray;

- (void) encodeString:(NSString *)string;
- (void) encodeString:(NSString *)string forKey:(NSString *)key;

- (void) encodeBool:(BOOL)value;
- (void) encodeInteger:(NSInteger)value;
- (void) encodePoint:(XSPoint *)point forKey:(NSString *)key;
- (void) encodeNilForKey:(NSString *)key;
@end
