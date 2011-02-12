//
//  ActionRefs.h
//  Athena
//
//  Created by Scott McClaugherty on 1/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"
#import "ResCoding.h"

@interface ActionRef : NSObject <LuaCoding, ResCoding> {
    NSInteger first, count;
    NSMutableArray *actions;
}
@property (readwrite, retain) NSMutableArray *actions;

+ (id) ref;
@end

@interface DestroyActionRef : ActionRef {
    BOOL dontDestroyOnDeath;
}
@property (readwrite, assign) BOOL dontDestroyOnDeath;
@end

@interface ActivateActionRef : ActionRef {
    NSInteger interval;
    NSInteger intervalRange;
}
@property (readwrite, assign) NSInteger interval;
@property (readwrite, assign) NSInteger intervalRange;
@end