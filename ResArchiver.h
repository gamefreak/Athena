//
//  ResArchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 2/19/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

@protocol ResCoding;

@interface ResArchiver : NSObject {
    NSMutableDictionary *types;
    NSMutableArray *stack;
}
- (NSUInteger) encodeObject:(id<ResCoding, NSObject>)object;
- (void) encodeObject:(id<ResCoding, NSObject>)object atIndex:(NSUInteger)index;

- (void) encodeUInt8:(UInt8)value;
- (void) encodeSInt8:(SInt8)value;
- (void) encodeUInt16:(UInt16)value;
- (void) encodeSInt16:(SInt16)value;
- (void) encodeUInt32:(UInt32)value;
- (void) encodeSInt32:(SInt32)value;
- (void) encodeUInt64:(UInt64)value;
- (void) encodeSInt64:(SInt64)value;
@end
