//
//  LuaArchiver.h
//  Athena
//
//  Created by Scott McClaugherty on 1/21/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LuaArchiver : NSCoder {
    NSMutableString *data;
    NSUInteger depth;
}
@property (readonly) NSData *data;
+ (NSData *) archivedDataWithRootObject:(id)object withName:(NSString *)name;
- (void) encodeArray:(NSArray *)array forKey:(NSString *)key;
@end
