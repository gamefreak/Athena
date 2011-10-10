//
//  LuaArchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 1/21/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "LuaArchiver.h"
#import "NSStringExtensions.h"
#import "XSKeyValuePair.h"

//DISABLED ~3.5s
//ENABLED ~2s
//Tested on a 2.53 Ghz Core2Duo
#define ENABLE_PARALLEL

@interface LuaArchiver (Private)
- (void) indent;
@end

@implementation LuaArchiver (Private)
- (void) indent {
    @synchronized(files) {
        int depth = [keyStack count];
        for (int i = 1; i < depth; i++) [data appendString:@"\t"];
    }
}
@end


@implementation LuaArchiver
@dynamic data;
@synthesize files;

- (id)init {
    self = [super init];
    if (self) {
        data = [[NSMutableString alloc] initWithCapacity:4*1024*1024];
        keyStack = [[NSMutableArray alloc] init];
        files = [[NSMutableDictionary alloc] init];
        disp_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        disp_group = dispatch_group_create();
    }
    return self;
}

- (void) dealloc {
    @synchronized(self) {
        dispatch_group_wait(disp_group, DISPATCH_TIME_FOREVER);
        dispatch_release(disp_group);
        dispatch_release(disp_queue);
        [files release];
        [keyStack release];
        [data release];
        [super dealloc];
    }
}


- (NSString *)topKey {
    return [keyStack lastObject];
}

- (NSData *) data {
    @synchronized(files) {
        if ([keyStack count] > 0) @throw @"Stack not empty";
        return [data dataUsingEncoding:NSUTF8StringEncoding];
    }
}


- (void) saveFile:(NSData *)fileData named:(NSString *)name inDirectory:(NSString *)directory {
    @synchronized(files) {
        NSArray *path = [directory pathComponents];
        NSMutableDictionary *cursor = files;
        for (NSString *element in path) {
            NSMutableDictionary *d = [cursor objectForKey:element];
            if (d == nil) {
                d = [NSMutableDictionary dictionary];
                [cursor setObject:d forKey:element];
            }
            cursor = d;
        }
        [cursor setObject:fileData forKey:name];
    }
}

- (void) encodeObject:(id <NSObject, LuaCoding>)obj forKey:(NSString *)key {
    @synchronized(self) {
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
}

- (void) encodeArray:(NSArray *)array forKey:(NSString *)key zeroIndexed:(BOOL)isZeroIndexed {
    @synchronized(self) {
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
}

- (void) encodePairArray:(NSArray *)array forKey:(NSString *)key {
    @synchronized(self) {
        [keyStack addObject:key];
        [self indent];
        [data appendString:key];
        [data appendString:@" = {\n"];
        for (XSKeyValuePair *pair in array) {
            [self encodeObject:pair.value forKey:[NSString stringWithFormat:@"[%@]", pair.key]];
        }
        [self indent];
        [data appendString:@"};\n"];
        [keyStack removeLastObject];
    }
}

- (void) encodeDictionary:(NSDictionary *)dict forKey:(NSString *)key asArray:(BOOL)asArray {
    @synchronized(self) {
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
}

- (void) encodeBool:(BOOL)value {
    @synchronized(self) {
        [data appendString:(value?@"true":@"false")];
    }
}

- (void) encodeBool:(BOOL)value forKey:(NSString *)key {
    @synchronized(self) {
        [keyStack addObject:key];
        [self indent];
        [data appendFormat:@"%@ = %@;\n", key, (value?@"true":@"false")];
        [keyStack removeLastObject];
    }
}

- (void) encodeString:(NSString *)string {
    @synchronized(self) {
        NSMutableString *str = [NSMutableString stringWithString:string];
        NSRange range = [str rangeOfString:@"]"];
        NSMutableString *buffer = [NSMutableString string];
        while (range.location != NSNotFound) {
            [buffer appendString:@"="];
            range = [str rangeOfString:[NSString stringWithFormat:@"]%@]", buffer]];
        }

        [data appendFormat:@"[%@[%@]%@]", buffer, str, buffer];
    }
}

- (void) encodeString:(NSString *)string forKey:(NSString *)key {
    @synchronized(self) {
        [keyStack addObject:key];
        [self indent];
        [data appendFormat:@"%@ = ", key];
        [self encodeString:string];
        [data appendString:@";\n"];
        [keyStack removeLastObject];
    }
}

- (void) encodeFloat:(float)value forKey:(NSString *)key {
    @synchronized(self) {
        [keyStack addObject:key];
        [self indent];
        [data appendFormat:@"%@ = %f;\n", key, value];
        [keyStack removeLastObject];
    }
}

- (void) encodePoint:(id<XSPoint>)point forKey:(NSString *)key {
    @synchronized(self) {
        [self encodeObject:point forKey:key];
    }
}

- (void) encodeInteger:(NSInteger)value {
    @synchronized(self) {
        [data appendFormat:@"%lli", value];
    }
}

- (void) encodeInteger:(NSInteger)value forKey:(NSString *)key {
    @synchronized(self) {
        [keyStack addObject:key];
        [self indent];
        [data appendFormat:@"%@ = %lli;\n", key, value];
        [keyStack removeLastObject];
    }
}

- (void) encodeNilForKey:(NSString *)key {
    @synchronized(self) {
        [keyStack addObject:key];
        [self indent];
        [data appendFormat:@"%@ = nil;\n", key];
        [keyStack removeLastObject];
    }
}

- (void)async:(void (^)(void))block {
#ifdef ENABLE_PARALLEL
    dispatch_group_async(disp_group, disp_queue, block);
#else
    dispatch_sync(disp_queue, block);
#endif
}

- (void)sync {
    dispatch_group_wait(disp_group, DISPATCH_TIME_FOREVER);
}
@end
