//
//  XSImage.h
//  Athena
//
//  Created by Scott McClaugherty on 10/4/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "Archivers.h"

@interface XSImage : NSObject <ResCoding, LuaCoding> {
    NSString *name;
    NSImage *image;
}
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSImage *image;
- (NSData *)PNGData;
@end
