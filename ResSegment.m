//
//  ResSegment.m
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ResSegment.h"
#import "IndexedObject.h"

@implementation ResSegment
@synthesize data, object, dataClass, cursor, loaded, name;
@dynamic index, indexRef;

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
        if ([dataClass respondsToSelector:@selector(classForResCoder:)]) {
            dataClass = [dataClass classForResCoder:coder];
        }
        object = [[dataClass alloc] initWithResArchiver:coder];
        if ([object isKindOfClass:[IndexedObject class]]) {
            [object setIndexRef:index];
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

- (void) advance:(NSUInteger)bytes {
    cursor += bytes;
}

- (void) seek:(NSUInteger)position {
    cursor = position;
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