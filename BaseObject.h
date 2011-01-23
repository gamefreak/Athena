//
//  BaseObject.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BaseObject : NSObject <NSCoding> {
    NSString *name;
    NSString *shortName;
    NSString *notes;
    NSString *staticName;
    //Attributes
    //Build flags
    //Order flags
    NSInteger class;
    NSInteger race;

    NSInteger price;
    NSInteger buildTime;
    float buildRatio;

    float offence;
    NSInteger escortRank;

    float maxVelocity;
    float warpSpeed;
    NSInteger warpOutDistance;
    float initialVelocity;
    float initialVelocityRange;

    float mass;
    float thrust;

    NSInteger health;
    NSInteger energy;
    NSInteger damage;

    NSInteger initialAge;
    NSInteger initialAgeRange;

    NSInteger scale;
    NSInteger layer;
    NSInteger spriteId;
}

@end
