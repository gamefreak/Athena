//
//  ResEntry.h
//  Athena
//
//  Created by Scott McClaugherty on 2/23/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

@class ResSegment;

//This is simply to prevent overuse of ResSegment.
//Also this is different in intent
@interface ResEntry : NSObject {
    ResID ID;
    ResType type;
    NSString *name;
    NSData *data;
}
@property (readwrite, assign) ResID ID;
@property (readwrite, assign) ResType type;
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSData *data;
- (id) initWithSegment:(ResSegment *)segment;
- (id) initWithResType:(ResType)type atId:(ResID)ID name:(NSString *)name data:(NSData *)data;
- (void) save;
@end
