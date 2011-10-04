//
//  XSImage.h
//  Athena
//
//  Created by Scott McClaugherty on 10/4/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "Archivers.h"

@interface XSImage : NSImage <ResCoding> {
    NSString *name;
}
@property (retain) NSString *name;
@end
