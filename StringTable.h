//
//  StringTable.h
//  Athena
//
//  Created by Scott McClaugherty on 2/10/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResCoding.h"

@interface StringTable : NSObject <ResCoding> {
    NSMutableArray *strings;
}
- (NSString *)stringAtIndex:(NSUInteger)index;
- (NSUInteger)addString:(NSString *)string;
@end
