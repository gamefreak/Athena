//
//  NSString+LuaCoding.h
//  Athena
//
//  Created by Scott McClaugherty on 1/26/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

@interface NSString (LuaCoding) <LuaCoding>
- (id) string;
@end
