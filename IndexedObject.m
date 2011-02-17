//
//  IndexedObject.m
//  Athena
//
//  Created by Scott McClaugherty on 2/16/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "IndexedObject.h"


@implementation IndexedObject
@dynamic objectIndex;
@dynamic indexRef;

- (id) init {
    self = [super init];
    if (self) {
        index = [[Index alloc] init];
    }
    return self;
}

- (id) initWithIndex:(NSUInteger)_index {
    self = [super init];
    if (self) {
        index = [[Index alloc] initWithIndex:_index];
    }
    return self;
}

- (void) dealloc {
    [index release];
    [super dealloc];
}
                  
- (void) objectsAddedAtIndexes:(NSIndexSet *)indexes {
    self.objectIndex += [indexes countOfIndexesInRange:NSMakeRange(0, index.index+1)];
}

- (void) objectsRemovedAtIndexes:(NSIndexSet *)indexes {
    self.objectIndex -= [indexes countOfIndexesInRange:NSMakeRange(0, index.index)];
}

- (NSUInteger) objectIndex {
    return index.index;
}

- (void) setObjectIndex:(NSUInteger)_index {
    index.index = _index;
}

- (Index *) indexRef {
    return index;
}

@end

@implementation Index
@synthesize index;
- (id) init {
    self = [self initWithIndex:NSUIntegerMax];
    if (self) {
    }
    return self;
}
- (id) initWithIndex:(NSUInteger)_index {
    self = [super init];
    if (self) {
        index = _index;
    }
    return self;
}
@end

