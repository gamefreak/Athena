//
//  NSArray+AthenaAdditions.m
//  Athena
//
//  Created by Scott McClaugherty on 10/17/11.
//  Copyright (c) 2011 Scott McClaugherty. All rights reserved.
//

#import "NSArray+AthenaAdditions.h"

@implementation NSArray (AthenaAdditions)
- (id)firstObjectPassingTest:(BOOL (^)(id object, NSUInteger idx))predicate {
    NSUInteger index = 0;
    for (id object in self) {
        if (predicate(object, index)) {
            return object;
        }
        index++;
    }
    return nil;
}
@end
