//
//  MainData.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaCoding.h"
#import "ResCoding.h"

#import "FlagBlob.h"

@class Index;

enum {
    DefaultPlayerBodyId = 22,
    DefaultEnergyBlobId = 28,
    DefaultInFlareId = 32,
    DefaultOutFlareId = 33,
};

@interface MainDataFlags : FlagBlob {
    BOOL isNetworkable;
    BOOL customObjects;
    BOOL customRaces;
    BOOL customScenarios;
    BOOL isUnoptimized;
}
@property (readwrite) BOOL isNetworkable;
@property (readwrite) BOOL customObjects;
@property (readwrite) BOOL customRaces;
@property (readwrite) BOOL customScenarios;
@property (readwrite) BOOL isUnoptimized;
@end

@interface MainData : NSObject <LuaCoding, ResCoding> {
    Index *warpInFlare;
    Index *warpOutFlare;
    Index *playerBody;
    Index *energyBlob;
    NSString *title;
    NSString *downloadUrl;
    NSString *author;
    NSString *authorUrl;
    NSString *identifier;

    MainDataFlags *flags;
    NSUInteger version, minVersion;
    NSUInteger checkSum;//BLAH


    NSMutableArray *objects;
    NSMutableArray *scenarios;
    NSMutableArray *races;
    NSMutableArray *sprites;
    NSMutableArray *sounds;
    NSMutableArray *images;
}
@property (readwrite, retain) Index *warpInFlare;
@property (readwrite, retain) Index *warpOutFlare;
@property (readwrite, retain) Index *playerBody;
@property (readwrite, retain) Index *energyBlob;
@property (readwrite, retain) NSString *title;
@property (readwrite, retain) NSString *downloadUrl;
@property (readwrite, retain) NSString *author;
@property (readwrite, retain) NSString *authorUrl;
@property (readwrite, retain) NSString *identifier;
@property (readonly) MainDataFlags *flags;
@property (readwrite) NSUInteger version;
@property (readwrite) NSUInteger minVersion;
//@property (readonly) NSUInteger checkSum;

@property (readonly) NSMutableArray *objects;
@property (readonly) NSMutableArray *scenarios;
@property (readonly) NSMutableArray *races;
@property (readonly) NSMutableArray *sprites;
@property (readonly) NSMutableArray *sounds;
@property (readonly) NSMutableArray *images;

- (NSString *) computedIdentifier;
@end
