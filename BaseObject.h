//
//  BaseObject.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BaseObjectFlags.h"
#import "ActionRefs.h"
#import "Color.h"

typedef enum {
    IconShapeNone,//SIGH
    IconShapeSquare,
    IconShapeTriangle,
    IconShapeDiamond,
    IconShapePlus,
    IconShapeFramedSquare
} IconShape;

@interface Weapon : NSObject <NSCoding> {
    NSInteger ID;//Uppercase because objective-c uses 'id' as a keyword.
    NSInteger positionCount;
    NSMutableArray *positions;
}
+ (id) weapon;
@end

@interface BaseObject : NSObject <NSCoding> {
    NSString *name;
    NSString *shortName;
    NSString *notes;
    NSString *staticName;

    BaseObjectAttributes *attributes;
    BaseObjectBuildFlags *buildFlags;
    BaseObjectOrderFlags *orderFlags;
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

    IconShape iconShape;
    NSInteger iconSize;

    ClutColor shieldColor;

    NSInteger initialDirection;
    NSInteger initialDirectionRange;

    NSMutableDictionary *weapons;

    float friendDefecit;
    float dangerThreshold;

//Disabled
//    NSInteger specialDirection;
    NSInteger arriveActionDistance;
    
    NSMutableDictionary *actions;
}

@end
