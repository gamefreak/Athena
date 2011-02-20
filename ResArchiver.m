//
//  ResArchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 2/19/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ResArchiver.h"
#import "ResCoding.h"
#import "ResSegment.h"
#import "StringTable.h"

@interface ResArchiver (Private)
- (NSMutableDictionary *) getTableForClass:(Class<ResCoding>)class;
- (NSUInteger) getNextIndexOfClass:(Class)class;
@end

@implementation ResArchiver (Private)
- (NSMutableDictionary *) getTableForClass:(Class<ResCoding>)class {
    NSMutableDictionary *table = [types objectForKey:class];
    if (table == nil) {
        table = [[NSMutableDictionary alloc] init];
        [types setObject:table forKey:class];
        [table setObject:[NSNumber numberWithUnsignedInt:0u] forKey:@"COUNTER"];
    }
    return table;
}

- (NSUInteger) getNextIndexOfClass:(Class)class {
    NSMutableDictionary *table = [self getTableForClass:class];
    NSUInteger val = [[table objectForKey:@"COUNTER"] unsignedIntegerValue];
    [table setObject:[NSNumber numberWithUnsignedInt:val+1] forKey:@"COUNTER"];
    return val;
}
@end



@implementation ResArchiver
- (id) init {
    self = [super init];
    if (self) {
        types = [[NSMutableDictionary alloc] init];
        stack = [[NSMutableArray alloc] init];
        stringTables = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
    [types release];
    [stack release];
    [stringTables release];
    [super dealloc];
}

- (void) skip:(size_t)length {
    [[stack lastObject] advance:length];
}

- (NSUInteger) encodeObject:(id<ResCoding, NSObject>)object {
    Class<ResCoding> class = [object class];
    NSMutableDictionary *table = [self getTableForClass:class];
    NSUInteger idx = [self getNextIndexOfClass:class];
    ResSegment *seg = [[ResSegment alloc] initWithObject:object atIndex:idx];
    [table setObject:seg forKey:[NSNumber numberWithUnsignedInteger:idx]];
    [stack addObject:seg];
    [object encodeResWithCoder:self];
    [stack removeLastObject];
    [seg release];
    return idx;
}

- (void) encodeObject:(id<ResCoding, NSObject>)object atIndex:(NSUInteger)index {
    Class<ResCoding> class = [object class];
    NSMutableDictionary *table = [self getTableForClass:class];
    ResSegment *seg = [[ResSegment alloc] initWithObject:object atIndex:index];
    [table setObject:seg forKey:[NSNumber numberWithUnsignedInteger:index]];
    [stack addObject:seg];
    [object encodeResWithCoder:self];
    [stack removeLastObject];
    [seg release];
}

- (void) encodeUInt8:(UInt8)value {
    [[stack lastObject] writeBytes:&value length:sizeof(value)];
}

- (void) encodeSInt8:(SInt8)value {
    [[stack lastObject] writeBytes:&value length:sizeof(value)];
}

- (void) encodeUInt16:(UInt16)value {
    value = CFSwapInt16HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(value)];
}

- (void) encodeSInt16:(SInt16)value {
    value = CFSwapInt16HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(value)];
}

- (void) encodeUInt32:(UInt32)value {
    value = CFSwapInt32HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(value)];
}

- (void) encodeSInt32:(SInt32)value {
    value = CFSwapInt32HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(value)];
}

- (void) encodeUInt64:(UInt64)value {
    value = CFSwapInt64HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(value)];
}

- (void) encodeSInt64:(SInt64)value {
    value = CFSwapInt64HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(value)];
}

- (void) encodeFixed:(CGFloat)value {
    [self encodeSInt32:(SInt32)(value*256.0f)];
}

- (void) encodePString:(NSString *)string {
    NSUInteger length = [string length];
    [self encodeUInt8:(UInt8)length];
    [[stack lastObject]
     writeBytes:(void *)[string cStringUsingEncoding:NSMacOSRomanStringEncoding]
     length:length];
}

- (void) encodePString:(NSString *)string ofFixedLength:(size_t)length {
    NSUInteger length_ = [string length];
    [self encodeUInt8:(UInt8)length_];
    [[stack lastObject]
     writeBytes:(void *)[string cStringUsingEncoding:NSMacOSRomanStringEncoding]
     length:length_];
    [[stack lastObject] advance:(length - length_)];
}

- (NSUInteger) addString:(NSString *)string toStringTable:(NSUInteger)tableId {
    NSNumber *key = [NSNumber numberWithUnsignedInteger:tableId];
    StringTable *table = [stringTables objectForKey:key];
    if (table == nil) {
        table = [[StringTable alloc] init];
        [stringTables setObject:table forKey:key];
    }
    return [table addString:string];
}

- (NSUInteger) addUniqueString:(NSString *)string toStringTable:(NSUInteger)tableId {
    NSNumber *key = [NSNumber numberWithUnsignedInteger:tableId];
    StringTable *table = [stringTables objectForKey:key];
    if (table == nil) {
        table = [[StringTable alloc] init];
        [stringTables setObject:table forKey:key];
    }
    return [table addUniqueString:string];
}
@end
