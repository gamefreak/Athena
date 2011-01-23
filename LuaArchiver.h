//
//  LuaArchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 1/21/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class XSPoint;

@interface LuaArchiver : NSCoder {
    NSMutableString *data;
    NSUInteger depth;
}
@property (readonly) NSData *data;
+ (NSData *) archivedDataWithRootObject:(id)object withName:(NSString *)name;
- (void) encodeArray:(NSArray *)array forKey:(NSString *)key;
- (void) encodeString:(NSString *)string forKey:(NSString *)key;
- (void) encodePoint:(XSPoint *)point forKey:(NSString *)key;
@end
