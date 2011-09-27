//
//  XSKeyValuePair.m
//  Athena
//
//  Created by Scott McClaugherty on 9/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "XSKeyValuePair.h"

@implementation XSKeyValuePair
@synthesize key, value;
+ (id)pairWithKey:(id)key value:(id)value {
    return [[[XSKeyValuePair alloc] initWithKey:key value:value] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
        key = nil;
        value = nil;
    }
    return self;
}

- (id)initWithKey:(id)key_ value:(id)value_ {
    self = [super init];
    if (self) {
        key = [key_ retain];
        value = [value_ retain];
    }
    return self;
}

@end
