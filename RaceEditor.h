//
//  RaceEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 1/27/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData;

@interface RaceEditor : NSWindowController {
    MainData *data;
}
- (id) initWithMainData:(MainData *)data;
@end
