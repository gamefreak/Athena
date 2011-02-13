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
#import "StringTable.h"

@implementation ResUnarchiver
- (id) initWithFilePath:(NSString *)path; {
    self = [super init];
    if (self) {
        types = [[NSMutableDictionary alloc] init];
        stack = [[NSMutableArray alloc] init];
        files = [[NSMutableArray alloc] init];
        [self addFile:path];
        [self registerClass:[StringTable class]];
    }
    
    return self;
}

- (void) addFile:(NSString *)path {
    FSRef file;
    if (!FSPathMakeRef((UInt8 *)[path cStringUsingEncoding:NSMacOSRomanStringEncoding], &file, NULL)) {
        ResFileRefNum resFile = FSOpenResFile(&file, fsRdPerm);
        UseResFile(resFile);
        [files addObject:[NSNumber numberWithShort:resFile]];
    }
}

- (void) registerClass:(Class <Alloc, ResCoding>)class {
    ResType type = [class resType];

    
    if ([class isPacked]) {//data is a concatinated array of structs
        NSLog(@"Unpacking resources of type: %@", [class typeKey]);
        //500 seems to be used for all of ares's packed types
        const ResID packedResourceId = 500u;
        //Pull the data out of resource
        Handle dataH = GetResource(type, packedResourceId);
        HLock(dataH);
        Size size = GetHandleSize(dataH);
        NSData *data = [NSData dataWithBytes:*dataH length:size];
        HUnlock(dataH);
        ReleaseResource(dataH);
        size_t recSize = [class sizeOfResourceItem];
        NSUInteger count = size/recSize;
        //Dictionary is used because NSArray doesn't handle sparse arrays
        NSMutableDictionary *table = [NSMutableDictionary dictionaryWithCapacity:count];
        
        char *buffer = malloc(size);
        for (NSUInteger k = 0; k < count; k++) {
            [data getBytes:buffer range:NSMakeRange(recSize * k, recSize)];
            ResSegment *seg = [[ResSegment alloc]
                               initWithClass:class
                               data:[NSData dataWithBytes:buffer length:recSize]
                               index:k];
            
            [table setObject:seg forKey:[[NSNumber numberWithUnsignedInteger:k] stringValue]];
            [seg release];
        }
        free(buffer);
        [types setObject:table forKey:[class typeKey]];
    } else {//Use indexed resources
        NSLog(@"Indexing resources of type: %@", [class typeKey]);
        ResourceCount count = CountResources(type);
        NSMutableDictionary *table = [NSMutableDictionary dictionaryWithCapacity:count];
        for (ResourceIndex index = 1; index <= count; index++) {
            Handle dataH = GetIndResource(type, index);
            //Pull out the ResId
            ResID rID;
            GetResInfo(dataH, &rID, NULL, NULL);
            HLock(dataH);
            Size size = GetHandleSize(dataH);
            ResSegment *seg = [[ResSegment alloc]
                               initWithClass:class
                               data:[NSData dataWithBytes:*dataH length:size]
                               index:rID];
            [table setObject:seg forKey:[[NSNumber numberWithShort:rID] stringValue]];
            [seg release];
            HUnlock(dataH);
            ReleaseResource(dataH);
        }
        [types setObject:table forKey:[class typeKey]];
        OSErr err = ResError();
        if (err != 0) {
            @throw [NSString stringWithFormat:@"Resource error: %d", err];
        }
    }
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

- (SInt16) decodeSwappedSInt16 {
    SInt16 out;
    [[stack lastObject] readBytes:&out length:sizeof(SInt16)];
    return out;;
}

- (UInt32) decodeUInt32 {
    UInt32 out;
    id seg = [stack lastObject];
    [seg readBytes:&out length:sizeof(UInt32)];
    return CFSwapInt32BigToHost(out);
}

- (SInt32) decodeSInt32 {
    SInt32 out;
    [[stack lastObject] readBytes:&out length:sizeof(SInt32)];
    return CFSwapInt32BigToHost(out);
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

- (BOOL) hasObjectOfClass:(Class<ResCoding>)class atIndex:(NSUInteger)index {
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
    if (seg == nil) @throw [NSString stringWithFormat:@"Failed to load resource of type '%@' at index %ui.", [class typeKey], index];
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

- (void)dealloc {
    [types release];
    [stack release];
    for (NSNumber *resRef in files) {
        CloseResFile([resRef shortValue]);
    }
    [super dealloc];
}

@end
