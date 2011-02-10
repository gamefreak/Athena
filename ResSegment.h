//
//  ResSegment.h
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResSegment : NSObject {
    NSData *data;
    id object;
    Class dataClass;
    NSUInteger cursor;
    BOOL loaded;
}
- (id) initWithClass:(Class)class data:(NSData *)data;
- (void) readBytes:(void *)bytes length:(NSUInteger)length;
@end

