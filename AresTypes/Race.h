//
//  Race.h
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"
#import "ResCoding.h"
#import "Color.h"
#import "FlagBlob.h"

@interface IllegalColors : FlagBlob {
    BOOL gray, orange, yellow, blue;
    BOOL green, purple, indigo, salmon;
    BOOL gold, aqua, pink, paleGreen;
    BOOL palePurple, skyBlue, tan, red;
}
@property (readwrite, assign) BOOL gray;
@property (readwrite, assign) BOOL orange;
@property (readwrite, assign) BOOL yellow;
@property (readwrite, assign) BOOL blue;
@property (readwrite, assign) BOOL green;
@property (readwrite, assign) BOOL purple;
@property (readwrite, assign) BOOL indigo;
@property (readwrite, assign) BOOL salmon;
@property (readwrite, assign) BOOL gold;
@property (readwrite, assign) BOOL aqua;
@property (readwrite, assign) BOOL pink;
@property (readwrite, assign) BOOL paleGreen;
@property (readwrite, assign) BOOL palePurple;
@property (readwrite, assign) BOOL skyBlue;
@property (readwrite, assign) BOOL tan;
@property (readwrite, assign) BOOL red;
@end


@interface Race : NSObject <LuaCoding, ResCoding> {
    NSInteger raceId;
    ClutColor apparentColor;
    IllegalColors *illegalColors;
    CGFloat advantage;
    NSString *singular;
    NSString *plural;
    NSString *military;
    NSString *homeworld;
}
@property (readwrite, assign) NSInteger raceId;
@property (readwrite, assign) ClutColor apparentColor;
@property (readonly) IllegalColors *illegalColors;
@property (readwrite, assign) CGFloat advantage;
@property (readwrite, retain) NSString *singular;
@property (readwrite, retain) NSString *plural;
@property (readwrite, retain) NSString *military;
@property (readwrite, retain) NSString *homeworld;
@end
