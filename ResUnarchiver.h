//
//  ResUnarchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 2/9/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import "ResCoding.h"

@interface ResUnarchiver : NSObject {
    NSMutableDictionary *types;
    NSMutableArray *stack;
    ResFileRefNum resFile;
}
- (id) initWithFilePath:(NSString *)path;

- (void) registerClass:(Class<ResCoding>)class;
- (NSUInteger) countOfClass:(Class<ResCoding>)class;

- (void) skip:(NSUInteger)bytes;
- (NSUInteger) currentIndex;

- (UInt8) decodeUInt8;
- (SInt8) decodeSInt8;
- (UInt16) decodeUInt16;
- (SInt16) decodeSInt16;
- (UInt32) decodeUInt32;
- (SInt32) decodeSInt32;
- (UInt64) decodeUInt64;
- (SInt64) decodeSInt64;

- (CGFloat) decodeFixed;

- (NSString *) decodePString;
//Length does not include the length byte
- (NSString *) decodePStringOfLength:(UInt8)length;

- (void *) decodeStructWithLength:(size_t)length;
- (id) decodeObjectOfClass:(Class<ResCoding>)class atIndex:(NSUInteger)index;
@end
