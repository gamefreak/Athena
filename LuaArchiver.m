//
//  LuaArchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 1/21/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "LuaArchiver.h"

@interface LuaArchiver (Private)
- (NSUInteger) up;
- (NSUInteger) down;
- (void) indent;
@end

@implementation LuaArchiver (Private)
- (NSUInteger) up {
    depth++;
    return depth;
}
- (NSUInteger) down {
    depth--;
    return depth;
}
- (void) indent {
    for (int i = 1; i < depth; i++) [data appendString:@"\t"];
}
@end


@implementation LuaArchiver
@dynamic data;
- (id)init {
    [super init];
    data = [[NSMutableString alloc] init];
    depth = 0;
    return self;
}

- (void) dealloc {
    [data release];
    [super dealloc];
}

- (NSData *) data {
    if (depth > 0) @throw @"Stack not empty";
    return [data dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *) archivedDataWithRootObject:(id)object withName:(NSString *)name {
    LuaArchiver *arch = [[LuaArchiver alloc] init];
    [arch encodeObject:object forKey:name];
    NSData *dat = [arch data];
    [arch release];
    return dat;
}

- (void) encodeObject:(id <NSObject,NSCoding>)obj forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendString:key];
    [data appendString:@" = {\n"];
    [obj encodeWithCoder:self];
    [self indent];
    [data appendString:@"};\n"];
    [self down];
}

- (void) encodeArray:(NSArray *)array forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendString:key];
    [data appendString:@" = {\n"];
    [self up];
    NSInteger idx = 0;
    for (id<NSCoding> obj in array) {
        [self indent]; [data appendFormat:@"[%d] = {\n", idx];
        [obj encodeWithCoder:self];
        [self indent]; [data appendString:@"};\n"];
        idx++;
    }
    [self down];
    [self indent];
    [data appendString:@"};\n"];
    [self down];
}

- (void) encodeBool:(BOOL)value forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendFormat:@"%@ = %@;\n", key, (value?@"true":@"false")];
    [self down];
}

- (void) encodeString:(NSString *)string forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendFormat:@"%@ = [[%@]];\n", key, [string stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"]];
    [self down];
}

- (void) encodeFloat:(float)value forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendFormat:@"%@ = %f;\n", key, value];
    [self down];
}

- (void) encodePoint:(NSPoint)point forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendFormat:@"%@ = {\n", key];
    [self encodeFloat:point.x forKey:@"x"];
    [self encodeFloat:point.y forKey:@"y"];
    [self indent];
    [data appendString:@"};\n"];
    [self down];
}
@end
