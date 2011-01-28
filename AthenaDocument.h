//
//  AthenaDocument.h
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class MainData;

@interface AthenaDocument : NSDocument {
    MainData *data;
}
@end
