//
//  ResSegment.m
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ResSegment.h"
#import "ResCoding.h"
#import "IndexedObject.h"

@implementation ResSegment
@synthesize data, object, dataClass, cursor, loaded, name;
@dynamic index, indexRef;

- (id) initWithObject:(id<ResCoding, NSObject>)_object atIndex:(NSUInteger)_index {
    self = [super init];
    if (self) {
        dataClass = [_object class];
        name = [[dataClass typeKey] retain];
        if ([dataClass isPacked]) {
            data = [[NSMutableData alloc] initWithLength:[dataClass sizeOfResourceItem]];
        } else {
            data = [[NSMutableData alloc] init];
        }
        cursor = 0;
        loaded = NO;
        index = [[Index alloc] initWithIndex:_index];
        object = [_object retain];
    }
    return self;
}

- (id) initWithClass:(Class<ResCoding, NSObject>)_class data:(NSData *)_data index:(NSUInteger)_index name:(NSString *)_name {
    self = [super init];
    if (self) {
        name = [_name retain];
        data = [_data retain];
        dataClass = _class;
        cursor = 0;
        loaded = NO;
        index = [[Index alloc] initWithIndex:_index];
    }
    return self;
}

- (id) loadObjectWithCoder:(ResUnarchiver *)coder {
    if (!loaded) {
        //Special case
        if ([dataClass conformsToProtocol:@protocol(ResClassOverriding)]) {
            dataClass = [(Class<ResClassOverriding>)dataClass classForResCoder:coder];
        }
        object = [[dataClass alloc] initWithResArchiver:coder];
        if ([object isKindOfClass:[IndexedObject class]]) {
            [(IndexedObject *)object setIndexRef:index];
        }
        NSAssert(object != nil, @"Unarchived object is nil");
        loaded = YES;
    }
    return object;
}

- (void) dealloc {
    [index release];
    [data release];
    [object release];
    [name release];
    [super dealloc];
}

- (void) readBytes:(void *)bytes length:(NSUInteger)length {
    [data getBytes:bytes range:NSMakeRange(cursor, length)];
    [self advance:length];
}

- (void) writeBytes:(void *)bytes length:(size_t)length {
    [data replaceBytesInRange:NSMakeRange(cursor, length) withBytes:bytes];
    [self advance:length];
}

- (void) advance:(NSUInteger)bytes {
    cursor += bytes;
}

- (void) seek:(NSUInteger)position {
    cursor = position;
}

- (void) extend:(NSUInteger)bytes {
    [data increaseLengthBy:bytes];
}

- (NSUInteger) index {
    return index.index;
}

- (void) setIndex:(NSUInteger)_index {
    index.index = _index;
}

- (Index *) indexRef {
    return index;
}
@end