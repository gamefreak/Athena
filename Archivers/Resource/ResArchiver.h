//
//  ResArchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 2/19/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import "DataBasis.h"

@protocol ResCoding;

@interface ResArchiver : NSObject {
    DataBasis saveType;
    BOOL hasBeenFlattened;
    NSMutableDictionary *types;
    NSMutableArray *stack;
    NSMutableDictionary *stringTables;
    NSMutableDictionary *planes;

    NSMutableDictionary *metadataFiles;
}
@property (readwrite, assign) DataBasis saveType;
- (BOOL) writeToResourceFile:(NSString *)file;
- (BOOL) writeToZipFile:(NSString *)file;

- (size_t) tell;
- (void) skip:(size_t)length;
- (void) seek:(size_t)position;
- (void) extend:(NSUInteger)bytes;
- (void) setName:(NSString *)name;
- (NSUInteger) currentIndex;

- (NSUInteger) encodeObject:(id<ResCoding, NSObject>)object;
- (void) encodeObject:(id<ResCoding, NSObject>)object atIndex:(NSUInteger)index;

- (void) writeBytes:(void *)bytes length:(size_t)length;

- (void) encodeUInt8:(UInt8)value;
- (void) encodeSInt8:(SInt8)value;

- (void) encodeUInt16:(UInt16)value;
- (void) encodeSInt16:(SInt16)value;
- (void) encodeSwappedUInt16:(UInt16)value;
- (void) encodeSwappedSInt16:(SInt16)value;

- (void) encodeUInt32:(UInt32)value;
- (void) encodeSInt32:(SInt32)value;
- (void) encodeSwappedUInt32:(UInt32)value;
- (void) encodeSwappedSInt32:(SInt32)value;

- (void) encodeUInt64:(UInt64)value;
- (void) encodeSInt64:(SInt64)value;
- (void) encodeSwappedUInt64:(UInt64)value;
- (void) encodeSwappedSInt64:(SInt64)value;

- (void) encodeFixed:(CGFloat)value;

- (void) encodePString:(NSString *)string;
- (void) encodePString:(NSString *)string ofFixedLength:(size_t)length;

- (NSUInteger) addString:(NSString *)string toStringTable:(NSUInteger)table;
- (NSUInteger) addUniqueString:(NSString *)string toStringTable:(NSUInteger)table;

- (void) addMetadata:(NSString *)data forKey:(NSString *)key;
- (void) flatten;
- (uint32) checkSumForIndex:(NSInteger)index ofPlane:(NSString *)plane;
@end
