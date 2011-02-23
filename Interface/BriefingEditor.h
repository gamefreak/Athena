//
//  BriefingEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 2/8/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainData, Scenario;

@interface BriefingEditor : NSWindowController {
    MainData *data;
    Scenario *scenario;
    NSMutableArray *briefings;
}
- (id) initWithMainData:(MainData *)data scenario:(NSUInteger)scenario;
@end
