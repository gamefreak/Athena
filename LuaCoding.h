//
//  LuaCoding.h
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LuaArchiver, LuaUnarchiver;

@protocol LuaCoding
- (id) initWithLuaCoder:(LuaUnarchiver *)coder;
- (void) encodeLuaWithCoder:(LuaArchiver *)coder;
+ (BOOL) isComposite;
+ (Class) classForLuaCoder:(LuaUnarchiver *)coder;
@end
