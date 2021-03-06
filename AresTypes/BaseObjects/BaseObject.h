//
//  BaseObject.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObjectFlags.h"
#import "ActionRefs.h"
#import "Color.h"
#import "FrameData.h"
#import "LuaCoding.h"
#import "ResCoding.h"
#import "StringTable.h"

#import "IndexedObject.h"

typedef enum {
    IconShapeSquare = 0x00,
    IconShapeTriangle = 0x10,
    IconShapeDiamond = 0x20,
    IconShapePlus = 0x30,
    IconShapeFramedSquare = 0x40,
    IconShapeNone = 0xf0 //SIGH
} IconShape;

typedef enum {
    RotationalObject,
    AnimatedObject,
    BeamObject,
    DeviceObject
} ObjectType;

@class Weapon;

//SOOOOO many variables 0_0
@interface BaseObject : IndexedObject <LuaCoding, ResCoding> {
    NSString *name;
    NSString *shortName;
    NSString *notes;

    BaseObjectAttributes *attributes;
    BaseObjectBuildFlags *buildFlags;
    BaseObjectOrderFlags *orderFlags;
    NSInteger classNumber;//changed from simply class because of another objective-c name collision :|
    NSInteger race;

    NSInteger price;
    NSInteger buildTime;
    float buildRatio;

    float offence;
    NSInteger escortRank;//Target

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

    double scale;
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

    FrameData *frame;

    NSInteger skillNum, skillDen;
    NSInteger skillNumAdj, skillDenAdj;

    NSInteger portraitId;
    Index *portrait;
}
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSString *shortName;
@property (readwrite, retain) NSString *notes;
@property (readwrite, retain) BaseObjectAttributes *attributes;
@property (readwrite, retain) BaseObjectBuildFlags *buildFlags;
@property (readwrite, retain) BaseObjectOrderFlags *orderFlags;
@property (readwrite, assign) NSInteger classNumber;
@property (readwrite, assign) NSInteger race;
@property (readwrite, assign) NSInteger price;
@property (readwrite, assign) NSInteger buildTime;
@property (readwrite, assign) float buildRatio;
@property (readwrite, assign) float offence;
@property (readwrite, assign) NSInteger escortRank;
@property (readwrite, assign) float maxVelocity;
@property (readwrite, assign) float warpSpeed;
@property (readwrite, assign) NSInteger warpOutDistance;
@property (readwrite, assign) float initialVelocity;
@property (readwrite, assign) float initialVelocityRange;
@property (readwrite, assign) float mass;
@property (readwrite, assign) float thrust;
@property (readwrite, assign) NSInteger health;
@property (readwrite, assign) NSInteger energy;
@property (readwrite, assign) NSInteger damage;
@property (readwrite, assign) NSInteger initialAge;
@property (readwrite, assign) NSInteger initialAgeRange;
@property (readwrite, assign) double scale;
@property (readwrite, assign) NSInteger layer;
@property (readwrite, assign) NSInteger spriteId;
@property (readwrite, assign) IconShape iconShape;
@property (readwrite, assign) NSInteger iconSize;
@property (readwrite, assign) ClutColor shieldColor;
@property (readwrite, assign) NSInteger initialDirection;
@property (readwrite, assign) NSInteger initialDirectionRange;
@property (readwrite, retain) NSMutableDictionary *weapons;
@property (readwrite, assign) float friendDefecit;
@property (readwrite, assign) float dangerThreshold;
//@property (readwrite, assign) NSInteger specialDirection; //Disabled
@property (readwrite, assign) NSInteger arriveActionDistance;
@property (readwrite, retain) NSMutableDictionary *actions;
@property (readwrite, retain) FrameData *frame;
@property (readwrite, assign) NSInteger skillNum;
@property (readwrite, assign) NSInteger skillDen;
@property (readwrite, assign) NSInteger skillNumAdj;
@property (readwrite, assign) NSInteger skillDenAdj;
@property (readonly, assign) NSInteger portraitId;
@property (readwrite, retain) Index *portrait;

- (int) calculateWarpOutDistance;
- (ObjectType)objectType;
- (NSString *)specialPanelNib;
@end

@interface Weapon : NSObject <LuaCoding> {
    BaseObject *device;
    NSMutableArray *positions;
@private
    int ID;//Only used during Lua decoding
}
@property (readwrite, retain) BaseObject *device;
@property (readwrite, retain) NSMutableArray *positions;
@property (readonly) NSInteger safeID;


- (id) initWithResArchiver:(ResUnarchiver *)coder id:(NSInteger)ID count:(NSInteger)count;
- (void) encodeResWithCoder:(ResArchiver *)coder;
+ (id) weapon;
@end
