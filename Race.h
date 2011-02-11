//
//  Race.h
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"
#import "ResCoding.h"
#import "Color.h"


@interface Race : NSObject <LuaCoding, ResCoding> {
    NSInteger raceId;
    ClutColor apparentColor;
    NSUInteger illegalColors;
    CGFloat advantage;
    NSString *singular;
    NSString *plural;
    NSString *military;
    NSString *homeworld;
}
@property (readwrite, assign) NSInteger raceId;
@property (readwrite, assign) ClutColor apparentColor;
@property (readwrite, assign) NSUInteger illegalColors;
@property (readwrite, assign) CGFloat advantage;
@property (readwrite, retain) NSString *singular;
@property (readwrite, retain) NSString *plural;
@property (readwrite, retain) NSString *military;
@property (readwrite, retain) NSString *homeworld;
@end
