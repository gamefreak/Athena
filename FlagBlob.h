//
//  FlagBlob.h
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

//Semi-Abstract Class
@interface FlagBlob : NSObject <LuaCoding> {}
+ (NSArray *)keys;
@end
