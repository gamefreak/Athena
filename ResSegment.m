//
//  ResSegment.m
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ResSegment.h"


@implementation ResSegment
- (id) initWithClass:(Class)class data:(NSData *)_data {
    self = [super init];
    if (self) {
        data = [_data retain];
        object = [class alloc];
        dataClass = class;
        cursor = 0;
        loaded = NO;
    }
    return self;
}

- (void) dealloc {
    [data release];
    [super dealloc];
}

- (void) readBytes:(void *)bytes length:(NSUInteger)length {
    [data getBytes:bytes range:NSMakeRange(cursor, length)];
    cursor += length;
}
@end