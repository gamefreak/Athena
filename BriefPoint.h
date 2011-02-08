//
//  BriefPoint.h
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LuaCoding.h"

@class XSPoint;

typedef enum {
    BriefTypeNoPoint,
    BriefTypeObject,
    BriefTypeAbsolute,
    BriefTypeFreestanding
} BriefingType;

@interface BriefPoint : NSObject <LuaCoding> {
    NSString *title;
    BriefingType type;
    NSInteger objectId;
    BOOL isVisible;
    XSPoint *range;
    NSString *content;
}
@property (readwrite, retain) NSString *title;
@property (readwrite, assign) BriefingType type;
@property (readwrite, assign) NSInteger objectId;
@property (readwrite, assign) BOOL isVisible;
@property (readwrite, retain) XSPoint *range;
@property (readwrite, assign) NSString *content;
@end
