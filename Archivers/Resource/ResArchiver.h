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
    BOOL hasBeenFlattened;
    NSMutableDictionary *types;
    NSMutableArray *stack;
    NSMutableDictionary *stringTables;
    NSMutableDictionary *planes;
}
- (BOOL) writeToFile:(NSString *)file;

- (void) skip:(size_t)length;
- (void) seek:(size_t)position;
- (void) extend:(NSUInteger)bytes;
- (void) setName:(NSString *)name;

- (NSUInteger) encodeObject:(id<ResCoding, NSObject>)object;
- (void) encodeObject:(id<ResCoding, NSObject>)object atIndex:(NSUInteger)index;

- (void) writeBytes:(void *)bytes length:(size_t)length;

- (void) encodeUInt8:(UInt8)value;
- (void) encodeSInt8:(SInt8)value;
- (void) encodeUInt16:(UInt16)value;
- (void) encodeSInt16:(SInt16)value;
- (void) encodeUInt32:(UInt32)value;
- (void) encodeSInt32:(SInt32)value;
- (void) encodeUInt64:(UInt64)value;
- (void) encodeSInt64:(SInt64)value;

- (void) encodeFixed:(CGFloat)value;

- (void) encodePString:(NSString *)string;
- (void) encodePString:(NSString *)string ofFixedLength:(size_t)length;

- (NSUInteger) addString:(NSString *)string toStringTable:(NSUInteger)table;
- (NSUInteger) addUniqueString:(NSString *)string toStringTable:(NSUInteger)table;

- (void) flatten;
- (uint32) checkSumForIndex:(NSInteger)index ofPlane:(NSString *)plane;
@end
