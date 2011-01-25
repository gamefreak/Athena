//
//  XSBool.h
//  Athena
//
//  Created by Scott McClaugherty on 1/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

@interface XSBool : NSObject <LuaCoding> {
    BOOL value;
}
@property (readwrite, assign) BOOL value;
- (id) initWithBool:(BOOL)value;
+ (id) yes;
+ (id) no;
+ (id) boolWithBool:(BOOL)_bool;
@end
