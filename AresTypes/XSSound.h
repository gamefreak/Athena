//
//  XSSound.h
//  Athena
//
//  Created by Scott McClaugherty on 7/6/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResCoding.h"

@interface XSSound : NSObject <ResCoding> {
@private
    NSSound *sound;
}

@end
