//
//  FlagBlob.h
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"
#import "ResCoding.h"

//Semi-Abstract Class
@interface FlagBlob : NSObject <LuaCoding, ResCoding> {}
+ (NSArray *)keys;
@end
