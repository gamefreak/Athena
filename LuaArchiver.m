//
//  LuaArchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 1/21/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "LuaArchiver.h"

@interface NSNumber (StringEncoding)
- (NSString *) encodedValue;
@end

@implementation NSNumber (StringEncoding)
- (NSString *) encodedValue {
    char code = *@encode(char);
    switch (code) {
        case 'c'://char forced to bool
            return ([self boolValue]?@"YES":@"NO");
            break;
        case 'i'://int
            return [NSString stringWithFormat:@"%d", [self intValue]];
            break;
        case 'f':
            return [NSString stringWithFormat:@"%f", [self floatValue]];
            break;
        default:
            @throw @"Unsupported NSNumber type";
            break;
    }
}
@end



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

- (void) encodeObject:(id <NSObject, LuaCoding>)obj forKey:(NSString *)key {
    [self up];
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
    [self down];
}

- (void) encodeArray:(NSArray *)array forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed {
    [self up];
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
    [self down];
}

- (void) encodeDictionary:(NSDictionary *)dict forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendString:key];
    [data appendString:@" = {\n"];
    //Alphabetical sort
    NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (id key in keys) {
        id<LuaCoding> obj = [dict objectForKey:key];
        [self encodeObject:obj forKey:key];
    }
    [self indent];
    [data appendString:@"};\n"];
    [self down];
}

- (void) encodeBool:(BOOL)value {
    [data appendString:(value?@"true":@"false")];
}

- (void) encodeBool:(BOOL)value forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendFormat:@"%@ = %@;\n", key, (value?@"true":@"false")];
    [self down];
}

- (void) encodeString:(NSString *)string {
    [data appendFormat:@"[[%@]]", [string stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"]];
}

- (void) encodeString:(NSString *)string forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendFormat:@"%@ = ", key];
    [self encodeString:string];
    [data appendString:@";\n"];
    [self down];
}

- (void) encodeFloat:(float)value forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendFormat:@"%@ = %f;\n", key, value];
    [self down];
}

- (void) encodePoint:(XSPoint *)point forKey:(NSString *)key {
    [self encodeObject:point forKey:key];
}

- (void) encodeInteger:(NSInteger)value {
    [self up];
    [self indent];
    [data appendFormat:@"%d"];
    [self down];
}

- (void) encodeInteger:(NSInteger)value forKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendFormat:@"%@ = %d;\n", key, value];
    [self down];
}

- (void) encodeNilForKey:(NSString *)key {
    [self up];
    [self indent];
    [data appendFormat:@"%@ = nil;\n", key];
    [self down];
}
@end
