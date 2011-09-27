//
//  XSKeyValuePair.h
//  Athena
//
//  Created by Scott McClaugherty on 9/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSKeyValuePair : NSObject {
    id key;
    id value;
}
@property (retain) id key;
@property (retain) id value;
+ (id)pairWithKey:(id)key value:(id)value;
- (id)initWithKey:(id)key value:(id)value;
@end
