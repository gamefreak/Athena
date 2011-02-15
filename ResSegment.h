//
//  ResSegment.h
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResCoding.h"

@class ResUnarchiver;

@interface ResSegment : NSObject {
    NSData *data;
    NSString *name;
    id<ResCoding, NSObject> object;
    Class dataClass;
    NSUInteger cursor;
    BOOL loaded;
    NSUInteger index;
}
@property (readonly) NSData *data;
@property (readonly) id<ResCoding, NSObject> object;
@property (readonly) Class dataClass;
@property (readonly) NSUInteger cursor;
@property (readonly) BOOL loaded;
@property (readonly) NSUInteger index;
@property (readwrite, retain) NSString *name;

- (id) initWithClass:(Class)class data:(NSData *)data index:(NSUInteger)index name:(NSString *)_name;
- (id) loadObjectWithCoder:(ResUnarchiver *)unarchiver;
- (void) readBytes:(void *)bytes length:(NSUInteger)length;
- (void) advance:(NSUInteger)bytes;
- (void) seek:(NSUInteger)position;
@end
