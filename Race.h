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

@end
