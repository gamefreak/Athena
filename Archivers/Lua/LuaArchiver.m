//
//  LuaArchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 1/21/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "LuaArchiver.h"
#import "NSStringExtensions.h"

@interface LuaArchiver (Private)
- (void) indent;
@end

@implementation LuaArchiver (Private)
- (void) indent {
    int depth = [keyStack count];
    for (int i = 1; i < depth; i++) [data appendString:@"\t"];
}
@end


@implementation LuaArchiver
@dynamic data;
@synthesize baseDir;

- (id)init {
    self = [super init];
    if (self) {
        baseDir = @"";
        data = [[NSMutableString alloc] init];
        keyStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc {
    [keyStack release];
    [baseDir release];
    [data release];
    [super dealloc];
}

- (BOOL)isPluginFormat {
    return [baseDir isNotEqualTo:@""];
}

- (NSString *)topKey {
    return [keyStack lastObject];
}

- (NSData *) data {
    if ([keyStack count] > 0) @throw @"Stack not empty";
    return [data dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *) archivedDataWithRootObject:(id<LuaCoding>)object withName:(NSString *)name {
    LuaArchiver *arch = [[LuaArchiver alloc] init];
    [arch encodeObject:object forKey:name];
    NSData *dat = [arch data];
    [arch release];
    return dat;
}

+ (NSData *) archivedDataWithRootObject:(id<LuaCoding>)object withName:(NSString *)name baseDirectory:(NSString *)baseDir {
    LuaArchiver *arch = [[LuaArchiver alloc] init];
    [arch setBaseDir:baseDir];
    [arch encodeObject:object forKey:name];
    NSData *dat = [arch data];
    [arch release];
    return dat;
}

- (void) encodeObject:(id <NSObject, LuaCoding>)obj forKey:(NSString *)key {
    [keyStack addObject:key];
    [self indent];
    [data appendString:key];
    if ([[obj class] isComposite]) {
        [data appendString:@" = {\n"];
    } else {
        [data appendString:@" = "];
    }
    [obj encodeLuaWithCoder:self];
    if ([[obj class] isComposite]) {
        [self indent];
        [data appendString:@"};\n"];
    } else {
        [data appendString:@";\n"];
    }
    [keyStack removeLastObject];
}

- (void) encodeArray:(NSArray *)array forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed {
    [keyStack addObject:key];
    [self indent];
    [data appendString:key];
    [data appendString:@" = {\n"];
    NSInteger idx = (isZeroIndexed?0:1);
    for (id<LuaCoding> obj in array) {
        [self encodeObject:obj
                    forKey:[NSString stringWithFormat:@"[%d]", idx]];
        idx++;
    }
    [self indent];
    [data appendString:@"};\n"];
    [keyStack removeLastObject];
}

- (void) encodeDictionary:(NSDictionary *)dict forKey:(NSString *)key asArray:(BOOL)asArray {
    [keyStack addObject:key];
    [self indent];
    [data appendString:key];
    [data appendString:@" = {\n"];
    //Alphabetical sort
    NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (id key in keys) {
        id<LuaCoding> obj = [dict objectForKey:key];
        if (asArray) {
            [self encodeObject:obj forKey:[NSString stringWithFormat:@"[%@]", key]];
        } else {
            [self encodeObject:obj forKey:key];
        }
    }
    [self indent];
    [data appendString:@"};\n"];
    [keyStack removeLastObject];
}

- (void) encodeBool:(BOOL)value {
    [data appendString:(value?@"true":@"false")];
}

- (void) encodeBool:(BOOL)value forKey:(NSString *)key {
    [keyStack addObject:key];
    [self indent];
    [data appendFormat:@"%@ = %@;\n", key, (value?@"true":@"false")];
    [keyStack removeLastObject];
}

- (void) encodeString:(NSString *)string {
    NSMutableString *str = [NSMutableString stringWithString:string];
    NSRange range = [str rangeOfString:@"]"];
    NSMutableString *buffer = [NSMutableString string];
    while (range.location != NSNotFound) {
        [buffer appendString:@"="];
        range = [str rangeOfString:[NSString stringWithFormat:@"]%@]", buffer]];
    }

    [data appendFormat:@"[%@[%@]%@]", buffer, str, buffer];
}

- (void) encodeString:(NSString *)string forKey:(NSString *)key {
    [keyStack addObject:key];
    [self indent];
    [data appendFormat:@"%@ = ", key];
    [self encodeString:string];
    [data appendString:@";\n"];
    [keyStack removeLastObject];
}

- (void) encodeFloat:(float)value forKey:(NSString *)key {
    [keyStack addObject:key];
    [self indent];
    [data appendFormat:@"%@ = %f;\n", key, value];
    [keyStack removeLastObject];
}

- (void) encodePoint:(id<XSPoint>)point forKey:(NSString *)key {
    [self encodeObject:point forKey:key];
}

- (void) encodeInteger:(NSInteger)value {
    //Why did I do that?? (remove if I give up on that)
//    [self up];
//    [self indent];
    [data appendFormat:@"%d"];
//    [self down];
}

- (void) encodeInteger:(NSInteger)value forKey:(NSString *)key {
    [keyStack addObject:key];
    [self indent];
    [data appendFormat:@"%@ = %d;\n", key, value];
    [keyStack removeLastObject];
}

- (void) encodeNilForKey:(NSString *)key {
    [keyStack addObject:key];
    [self indent];
    [data appendFormat:@"%@ = nil;\n", key];
    [keyStack removeLastObject];
}
@end
