//
//  XSInteger.h
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

@interface XSInteger : NSObject <LuaCoding> {
    NSInteger value;
}
@property (readwrite, assign) NSInteger value;
- (id) initWithValue:(NSInteger)value;
+ (id) xsIntegerWithValue:(NSInteger)value;
@end
