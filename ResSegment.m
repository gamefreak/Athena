//
//  ResSegment.m
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ResSegment.h"


@implementation ResSegment
- (id) initWithClass:(Class)_class data:(NSData *)_data {
    self = [super init];
    if (self) {
        data = [_data retain];
        object = [_class alloc];
        dataClass = _class;
        cursor = 0;
        loaded = NO;
    }
    return self;
}

- (id) loadObjectWithCoder:(ResUnarchiver *)coder {
    if (!loaded) {
        [object initWithResArchiver:coder];
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
@end