//
//  InitialEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 1/28/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData, Scenario;

@interface InitialEditor : NSWindowController {
    MainData *data;
    Scenario *scenario;
}
- (id) initWithMainData:(MainData *)data scenario:(NSUInteger)scenario;
@end
