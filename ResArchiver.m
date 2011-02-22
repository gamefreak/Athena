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
- (NSUInteger) getNextIndexOfClass:(Class<ResCoding>)class;
- (void) flattenTableForType:(NSString *)type;
@end

@implementation ResArchiver (Private)
- (NSMutableDictionary *) getTableForClass:(Class<ResCoding>)class {
    NSMutableDictionary *table = [types objectForKey:[class typeKey]];
    if (table == nil) {
        NSLog(@"Begining to encode resources of type '%@'", [class typeKey]);
        table = [[NSMutableDictionary alloc] init];
        [types setObject:table forKey:[class typeKey]];
        [table setObject:[NSNumber numberWithUnsignedInt:0u] forKey:@"COUNTER"];
    }
    return table;
}

- (NSUInteger) getNextIndexOfClass:(Class<ResCoding>)class {
    NSMutableDictionary *table = [self getTableForClass:class];
    NSUInteger val = [[table objectForKey:@"COUNTER"] unsignedIntegerValue];
    [table setObject:[NSNumber numberWithUnsignedInt:val+1] forKey:@"COUNTER"];
    if ([class resType] == 'TEXT') {
        return val + 3000;
    }
    return val;
}

- (void) flattenTableForType:(NSString *)type {
    NSMutableDictionary *table = [types objectForKey:type];
    [table removeObjectForKey:@"COUNTER"];
    NSArray *keys = [[table allKeys] sortedArrayUsingSelector:@selector(compare:)];
    Class<ResCoding> class = [[table objectForKey:[keys lastObject]] dataClass];
    if ([class isPacked]) {
        size_t size = [class sizeOfResourceItem];
        NSMutableData *data = [NSMutableData dataWithCapacity:[keys count]*size];
        for (id key in keys) {
            [data appendData:[[table objectForKey:key] data]];
        }
        [planes setObject:[NSDictionary dictionaryWithObject:data forKey:[NSNumber numberWithInt:500]] forKey:type];
    } else {
        NSMutableDictionary *plane = [NSMutableDictionary dictionary];
        for (id key in keys) {
            [plane setObject:[[table objectForKey:key] data] forKey:key];
        }
        [planes setObject:plane forKey:type];
    }
}
@end



@implementation ResArchiver
- (id) init {
    self = [super init];
    if (self) {
        hasBeenFlattened = NO;
        types = [[NSMutableDictionary alloc] init];
        stack = [[NSMutableArray alloc] init];
        stringTables = [[NSMutableDictionary alloc] init];
        planes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
    [types release];
    [stack release];
    [stringTables release];
    [planes release];
    [super dealloc];
}

- (void) skip:(size_t)length {
    [[stack lastObject] advance:length];
}

- (void) extend:(NSUInteger)bytes {
    [[stack lastObject] extend:bytes];
}

- (NSUInteger) encodeObject:(id<ResCoding, NSObject>)object {
    if (hasBeenFlattened) {
        @throw @"Cannot encode new object because the data has been flattened.";
    }
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
    if (hasBeenFlattened) {
        @throw @"Cannot encode new object because the data has been flattened.";
    }
    Class<ResCoding> class = [object class];
    NSMutableDictionary *table = [self getTableForClass:class];
    ResSegment *seg = [[ResSegment alloc] initWithObject:object atIndex:index];
    [table setObject:seg forKey:[NSNumber numberWithUnsignedInteger:index]];
    [stack addObject:seg];
    [object encodeResWithCoder:self];
    [stack removeLastObject];
    [seg release];
    if (hasBeenFlattened) {//For flattening the top level object
        [self flattenTableForType:[class typeKey]];
    }
}

- (void) writeBytes:(void *)bytes length:(size_t)length {
    [[stack lastObject] writeBytes:bytes length:length];
}

- (void) encodeUInt8:(UInt8)value {
    [[stack lastObject] writeBytes:&value length:sizeof(UInt8)];
}

- (void) encodeSInt8:(SInt8)value {
    [[stack lastObject] writeBytes:&value length:sizeof(SInt8)];
}

- (void) encodeUInt16:(UInt16)value {
    value = CFSwapInt16HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(UInt16)];
}

- (void) encodeSInt16:(SInt16)value {
    value = CFSwapInt16HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(SInt16)];
}

- (void) encodeUInt32:(UInt32)value {
    value = CFSwapInt32HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(UInt32)];
}

- (void) encodeSInt32:(SInt32)value {
    value = CFSwapInt32HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(SInt32)];
}

- (void) encodeUInt64:(UInt64)value {
    value = CFSwapInt64HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(UInt64)];
}

- (void) encodeSInt64:(SInt64)value {
    value = CFSwapInt64HostToBig(value);
    [[stack lastObject] writeBytes:&value length:sizeof(SInt64)];
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

- (void) flatten {
    NSAssert(!hasBeenFlattened, @"Data has been flattened, no more objects can be encoded.");
    NSAssert([stack count] <= 1, @"-flatten must be called externally or from the top level object.");
    hasBeenFlattened = YES;
    NSString *excludedType = [[[stack lastObject] dataClass] typeKey];
    for (NSString *type in types) {
        if ([type isNotEqualTo:excludedType]) {
            [self flattenTableForType:type];
        }
    }
}

- (uint32) checkSumForIndex:(NSInteger)index ofPlane:(NSString *)plane {
    NSDictionary *table = [planes objectForKey:plane];
    NSAssert(table != nil, @"Attempt to checksum nonexistant data plane.");
    NSData *data = [table objectForKey:[NSNumber numberWithUnsignedInt:index]];
    NSAssert(data != nil, @"Attempt to checksum nonexistant data plane.");
    //Checksumming code lifted almost verbatim from Hera_Data.c
    uint32 checkSum = 0x00000000;
    sint32 l = [data length];
    sint32 shiftCount = 0;
    uint8 *c = (uint8 *)[data bytes];
    while (l > 0) {
        checkSum ^= ((uint32)*c) << shiftCount;
        shiftCount += 8;
        c++;
        if (shiftCount >= 32) shiftCount = 0;
        l--;
    }
    return checkSum;
}
@end
