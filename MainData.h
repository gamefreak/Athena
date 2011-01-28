//
//  MainData.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

@interface MainData : NSObject <LuaCoding> {
    NSMutableArray *objects;
    NSMutableArray *scenarios;
    NSMutableArray *races;
}

@end
