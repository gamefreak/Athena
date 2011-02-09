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
    NSMutableDictionary *sprites;
    NSMutableDictionary *sounds;
}
@property (readonly) NSMutableArray *objects;
@property (readonly) NSMutableArray *scenarios;
@property (readonly) NSMutableArray *races;
@property (readonly) NSMutableDictionary *sprites;
@property (readonly) NSMutableDictionary *sounds;
@end
