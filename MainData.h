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
    NSInteger inFlareId;
    NSInteger outFlareId;
    NSInteger playerBodyId;
    NSInteger energyBlobId;
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
@property (readwrite) NSInteger inFlareId;
@property (readwrite) NSInteger outFlareId;
@property (readwrite) NSInteger playerBodyId;
@property (readwrite) NSInteger energyBlobId;
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
