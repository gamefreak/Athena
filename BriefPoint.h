//
//  BriefPoint.h
//  Athena
//
//  Created by Scott McClaugherty on 1/22/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef enum {
    BriefTypeNoPoint,
    BriefTypeObject,
    BriefTypeAbsolute,
    BriefTypeFreestanding
} BriefingType;

@interface BriefPoint : NSObject <NSCoding> {
    NSString *title;
    BriefingType type;
    NSInteger objectId;
    BOOL isVisible;
    NSPoint range;
    NSInteger contentId;
}

@end
