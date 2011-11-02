//
//  ResSegment.h
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBasis.h"

@protocol ResCoding;
@class ResArchiver, ResUnarchiver, Index;

@interface ResSegment : NSObject {
    NSMutableData *data;
    NSString *name;
    id<ResCoding, NSObject> object;
    Class<Alloc, ResCoding> dataClass;
    NSUInteger cursor;
    BOOL loaded;
    Index *index;
    DataBasis origin;
}
@property (readonly) NSData *data;
@property (readonly) id<ResCoding, NSObject> object;
@property (readonly) Class<ResCoding> dataClass;
@property (readonly) NSUInteger cursor;
@property (readonly) BOOL loaded;
@property (readwrite, assign) NSUInteger index;
@property (readonly) Index *indexRef;
@property (readwrite, retain) NSString *name;
@property (readonly) DataBasis origin;
//For Writing
- (id) initWithObject:(id<ResCoding, NSObject>)object atIndex:(NSUInteger)index;
//For Reading
- (id) initWithClass:(Class<ResCoding>)class data:(NSData *)data index:(NSUInteger)index name:(NSString *)_name origin:(DataBasis)origin;

- (id) loadObjectWithCoder:(ResUnarchiver *)unarchiver;
- (void) readBytes:(void *)bytes length:(size_t)length;
- (void) writeBytes:(void *)bytes length:(size_t)length;
- (void) advance:(NSUInteger)bytes;
- (void) seek:(NSUInteger)position;
- (void) extend:(NSUInteger)bytes;
@end

