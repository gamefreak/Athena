//
//  LuaArchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 1/21/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"

@protocol XSPoint;

@interface LuaArchiver : NSObject {
    NSMutableString *data;
    NSMutableArray *keyStack;
    NSMutableDictionary *files;
    dispatch_group_t disp_group;
    dispatch_queue_t disp_queue;
}
@property (readonly) NSData *data;
@property (readonly) NSMutableDictionary *files;

- (NSString *)topKey;

- (void) saveFile:(NSData *)data named:(NSString *)name inDirectory:(NSString *)directory;

- (void) encodeObject:(id)object forKey:(NSString *)key;
- (void) encodeArray:(NSArray *)array forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed;
- (void) encodeDictionary:(NSDictionary *)dict forKey:(NSString *)key asArray:(BOOL)asArray;

- (void) encodeString:(NSString *)string;
- (void) encodeString:(NSString *)string forKey:(NSString *)key;

- (void) encodeBool:(BOOL)value;
- (void) encodeBool:(BOOL)value forKey:(NSString *)key;
//- (void) encodeFloat
- (void) encodeFloat:(float)value forKey:(NSString *)key;
- (void) encodeInteger:(NSInteger)value;
- (void) encodeInteger:(NSInteger)value forKey:(NSString *)key;
- (void) encodePoint:(id<XSPoint>)point forKey:(NSString *)key;
- (void) encodeNilForKey:(NSString *)key;

- (void) async:(void (^)(void))block;
- (void) sync;
@end
