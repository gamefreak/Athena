//
//  ResUnarchiver.m
//  Athena
//
//  Created by Scott McClaugherty on 2/9/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ResUnarchiver.h"
#import "ResCoding.h"
#import "ResSegment.h"
#import "ResFiles.h"
#import "StringTable.h"
#import "Scenario.h"
#import <sys/stat.h>

OSStatus CoreEndianNULLFlipProc(OSType dataDomain, OSType dataType, short id, void *dataPtr, UInt32 dataSize, Boolean currentlyNative, void *refcon) {
    return noErr;
}

@implementation ResUnarchiver
@synthesize sourceType;
+ (void)initialize {
    CoreEndianInstallFlipper(kCoreEndianResourceManagerDomain, 'STR#', (CoreEndianFlipProc)&CoreEndianNULLFlipProc, NULL);
    CoreEndianInstallFlipper(kCoreEndianResourceManagerDomain, 'snd ', (CoreEndianFlipProc)&CoreEndianNULLFlipProc, NULL);
}

- (id)init {
    self = [super init];
    if (self) {
        types = [[NSMutableDictionary alloc] init];
        stack = [[NSMutableArray alloc] init];
        files = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [types release];
    [stack release];
    [files release];
    [super dealloc];
}

- (void) addFile:(NSString *)path ofType:(DataBasis)type {
    if (type == DataBasisAres) {
        ResourceFile *data = [[ResourceFile alloc] initWithFileName:path];
        [files addObject:data];
        [data release];
    } else {
        ZipFile *data = [[ZipFile alloc] initWithFileName:path];
        [files addObject:data];
        [data release];
    }
}

- (void) registerClass:(Class <NSObject, Alloc, ResCoding>)class {
    NSMutableDictionary *table = [NSMutableDictionary dictionary];
    for (id<ResFile> file in files) {
        NSDictionary *subTable = [file allEntriesOfClass:class];
        if ([class isPacked]) {
            if ([table count] > 0) {
                [table setDictionary:subTable];
            }
        } else {
            [table setValuesForKeysWithDictionary:subTable];
        }
    }
    [types setObject:table forKey:[class typeKey]];
}

- (NSUInteger) countOfClass:(Class<ResCoding>)_class {
    NSMutableDictionary *table = [types objectForKey:[_class typeKey]];
    if (table == nil) {
        [self registerClass:_class];
        table = [types objectForKey:[_class typeKey]];
    }
    return [table count];
}

- (void) skip:(NSUInteger)bytes {
    [[stack lastObject] advance:bytes];
}

- (void) seek:(NSUInteger)position {
    [[stack lastObject] seek:position];
}

- (void) readBytes:(void *)buffer length:(NSUInteger)length {
    [[stack lastObject] readBytes:buffer length:length];
}

- (NSUInteger) currentIndex {
    return [[stack lastObject] index];
}

- (NSUInteger) currentSize {
    return [[[stack lastObject] data] length];
}

- (NSString *) currentName {
    NSString *name = [[stack lastObject] name];
    /*
     Fucking fancy quotes...
    The resource name for the audmedon assault transport's sound inexplicably contains a fancy quote mark.
     This messes up fopen so this fix is being hard coded for now.
    */
    return [name stringByReplacingOccurrencesOfString:@"\x2019" withString:@"'"];
}

- (NSData *)rawData {
    return [[stack lastObject] data];
}

- (UInt8) decodeUInt8 {
    UInt8 out;
    ResSegment *seg = [stack lastObject];
    [seg readBytes:&out length:sizeof(UInt8)];
    return out;
}

- (SInt8) decodeSInt8 {
    SInt8 out;
    [[stack lastObject] readBytes:&out length:sizeof(SInt8)];
    return out;
}

- (UInt16) decodeUInt16 {
    UInt16 out;
    [[stack lastObject] readBytes:&out length:sizeof(UInt16)];
    return CFSwapInt16BigToHost(out);
}

- (SInt16) decodeSInt16 {
    SInt16 out;
    [[stack lastObject] readBytes:&out length:sizeof(SInt16)];
    return CFSwapInt16BigToHost(out);
}

- (UInt16) decodeSwappedUInt16 {
    UInt16 out;
    [[stack lastObject] readBytes:&out length:sizeof(UInt16)];
    return out;
}

- (SInt16) decodeSwappedSInt16 {
    SInt16 out;
    [[stack lastObject] readBytes:&out length:sizeof(SInt16)];
    return out;
}

- (UInt32) decodeUInt32 {
    UInt32 out;
    [[stack lastObject] readBytes:&out length:sizeof(UInt32)];
    return CFSwapInt32BigToHost(out);
}

- (SInt32) decodeSInt32 {
    SInt32 out;
    [[stack lastObject] readBytes:&out length:sizeof(SInt32)];
    return CFSwapInt32BigToHost(out);
}

- (UInt32) decodeSwappedUInt32 {
    UInt32 out;
    [[stack lastObject] readBytes:&out length:sizeof(UInt32)];
    return out;
}

- (SInt32) decodeSwappedSInt32 {
    SInt32 out;
    [[stack lastObject] readBytes:&out length:sizeof(SInt32)];
    return out;
}

- (UInt64) decodeUInt64 {
    UInt64 out;
    [[stack lastObject] readBytes:&out length:sizeof(UInt64)];
    return CFSwapInt64BigToHost(out);
}

- (SInt64) decodeSInt64 {
    SInt64 out;
    [[stack lastObject] readBytes:&out length:sizeof(SInt64)];
    return CFSwapInt64BigToHost(out);
}

- (CGFloat) decodeFixed {
    return (CGFloat)[self decodeSInt32]/256.0f;
}

- (BOOL) hasObjectOfClass:(Class<ResCoding, Alloc, NSObject>)class atIndex:(NSUInteger)index {
    NSMutableDictionary *table = [types objectForKey:[class typeKey]];
    if (table == nil) {
        [self registerClass:class];
        table = [types objectForKey:[class typeKey]];
    }
    if (table == nil) return NO;
    ResSegment *seg =  [table objectForKey:[[NSNumber numberWithUnsignedInteger:index] stringValue]];
    return (seg != nil);
}

- (id)decodeObjectOfClass:(Class)class atIndex:(NSUInteger)index {
    NSMutableDictionary *table = [types objectForKey:[class typeKey]];
    if (table == nil) {
        [self registerClass:class];
        table = [types objectForKey:[class typeKey]];
    }
    if (table == nil) @throw [NSString stringWithFormat:@"Unable to access objects of type '%@'", [class typeKey]];
    ResSegment *seg =  [table objectForKey:[[NSNumber numberWithUnsignedInteger:index] stringValue]];
    if (seg == nil) @throw [NSString stringWithFormat:@"Failed to load resource of type '%@' at index %lu.", [class typeKey], index];
    [stack addObject:seg];
    id object = [seg loadObjectWithCoder:self];
    [stack removeLastObject];
    return object;
}

- (NSMutableDictionary *)allObjectsOfClass:(Class<ResCoding>)class {
    NSMutableDictionary *table = [types objectForKey:[class typeKey]];
    if (table == nil) {
        [self registerClass:class];
        table = [types objectForKey:[class typeKey]];
    }
    NSMutableDictionary *outDict = [NSMutableDictionary dictionary];
    NSArray *indexes = [table allKeys];
    for (NSString *key in indexes) {
        ResSegment *seg = [table objectForKey:key];
        [stack addObject:seg];
        [outDict setObject:[seg loadObjectWithCoder:self] forKey:key];
        [stack removeLastObject];
    }
    return outDict;
}

- (Index *) getIndexRefWithIndex:(NSUInteger)index forClass:(Class<Alloc, ResCoding>)class {
    NSMutableDictionary *table = [types objectForKey:[class typeKey]];
    if (table == nil) {
        [self registerClass:class];
        table = [types objectForKey:[class typeKey]];
    }
    return [[table objectForKey:[[NSNumber numberWithUnsignedInteger:index] stringValue]] indexRef];
}

- (NSString *) decodePString {
    UInt8 length;
    ResSegment *seg = [stack lastObject];
    [seg readBytes:&length length:sizeof(UInt8)];
    char *buffer = malloc(length + 1);
    [seg readBytes:buffer length:length];
    buffer[length] = '\0';//Just in case
    NSString *string = [NSString stringWithCString:buffer encoding:NSMacOSRomanStringEncoding];
    free(buffer);
    return string;
}

- (NSString *) decodePStringOfLength:(UInt8)length {
    UInt8 sLength;
    ResSegment *seg = [stack lastObject];
    [seg readBytes:&sLength length:1];
    char *buffer = malloc(length + 1);
    [seg readBytes:buffer length:length];
    buffer[sLength] = '\0';//Just in case
    NSString *string = [NSString stringWithCString:buffer encoding:NSMacOSRomanStringEncoding];
    free(buffer);
    return string;
}

- (NSString *)getMetadataForKey:(NSString *)key {
    for (id<ResFile> file in files) {
        if ([file isKindOfClass:[ResourceFile class]]) {
            continue;
        }
        NSString *value = [(ResourceFile *)file getMetadataForKey:key];
        if (value != nil) {
            return value;
        }
    }
    return nil;
}

- (DataBasis)sourceType {
    return [[stack lastObject] origin];
}
@end
