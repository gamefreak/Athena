//
//  XSText.h
//  Athena
//
//  Created by Scott McClaugherty on 2/23/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResCoding.h"

@interface XSText : NSObject <ResCoding> {
    NSString *name;
    NSString *text;
}
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSString *text;
@end
