//
//  Race.h
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

@interface Race : NSObject <LuaCoding> {
    NSInteger raceId;
    CGFloat advantage;
    NSString *singular;
    NSString *plural;
    NSString *military;
    NSString *homeworld;
}
@property (readwrite, assign) NSInteger raceId;
@property (readwrite, assign) CGFloat advantage;
@property (readwrite, retain) NSString *singular;
@property (readwrite, retain) NSString *plural;
@property (readwrite, retain) NSString *military;
@property (readwrite, retain) NSString *homeworld;
@end
