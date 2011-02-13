//
//  ResSegment.m
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ResSegment.h"

@implementation ResSegment
@synthesize data, object, dataClass, cursor, index, loaded;

- (id) initWithClass:(Class<ResCoding, NSObject>)_class data:(NSData *)_data index:(NSUInteger)_index{
    self = [super init];
    if (self) {
        data = [_data retain];
        dataClass = _class;
        cursor = 0;
        loaded = NO;
        index = _index;
    }
    return self;
}

- (id) loadObjectWithCoder:(ResUnarchiver *)coder {
    if (!loaded) {
        object = [[dataClass alloc] initWithResArchiver:coder];
        loaded = YES;
    }
    return object;
}

- (void) dealloc {
    [data release];
    [object release];
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
@end