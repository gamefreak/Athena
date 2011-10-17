//
//  NSArray+AthenaAdditions.h
//  Athena
//
//  Created by Scott McClaugherty on 10/17/11.
//  Copyright (c) 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AthenaAdditions)
//This should be QUITE self explanitory
- (id)firstObjectPassingTest:(BOOL (^)(id object, NSUInteger idx))predicate;
@end
