//
//  ObjectEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 2/16/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData;

@interface ObjectEditor : NSWindowController {
    MainData *data;
    NSMutableArray *objects;
}
- (id)initWithMainData:(MainData *)data;
@end
