//
//  Action.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

@interface Action : NSObject <LuaCoding> {
    BOOL reflexive;
    NSUInteger inclusiveFilter, exclusiveFilter;
    NSInteger subjectOverride, directOverride;
    NSInteger owner;
    NSInteger delay;
}
@end
