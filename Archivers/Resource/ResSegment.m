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
#import <objc/runtime.h>

@implementation ResSegment
@synthesize data, object, dataClass, cursor, loaded, name, origin;
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
        origin = DataBasisNone;
    }
    return self;
}

- (id) initWithClass:(Class<Alloc, ResCoding, NSObject>)_class data:(NSData *)_data index:(NSUInteger)_index name:(NSString *)_name origin:(DataBasis)_origin {
    self = [super init];
    if (self) {
        name = [_name retain];
        data = [_data mutableCopy];
        dataClass = _class;
        cursor = 0;
        loaded = NO;
        index = [[Index alloc] initWithIndex:_index];
        origin = _origin;
    }
    return self;
}

- (id) loadObjectWithCoder:(ResUnarchiver *)coder {
    if (!loaded) {
        //Special case
        if (class_conformsToProtocol(dataClass, @protocol(ResClassOverriding))) {
            dataClass = (Class<Alloc,ResCoding>)[(Class<ResClassOverriding>)dataClass classForResCoder:coder];
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
