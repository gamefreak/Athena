//
//  NSStringExtensions.h
//  Athena
//
//  Created by Scott McClaugherty on 1/26/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"

@interface NSString (NSStringExtensions) <LuaCoding>
- (id) string;
- (unsigned short)unsignedShortValue;
- (NSComparisonResult) numericCompare:(NSString *)string;
@end
