//
//  ResCoding.h
//  Athena
//
//  Created by Scott McClaugherty on 2/9/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import <sys/types.h>

@class ResArchiver, ResUnarchiver;

@protocol ResCoding
- (id) initWithResArchiver:(ResUnarchiver *)unarchiver;
- (void) encodeResWithCoder:(ResArchiver *)archiver;
+ (ResType) resType;
+ (NSString *) typeKey;
+ (BOOL) isPacked;
@optional
+ (size_t) sizeOfResourceItem;
@end
