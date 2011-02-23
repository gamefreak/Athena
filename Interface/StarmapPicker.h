//
//  StarmapPicker.h
//  Athena
//
//  Created by Scott McClaugherty on 2/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Scenario;

@interface StarmapPicker : NSWindowController {
    Scenario *scenario;
}
@property (readonly) Scenario *scenario;
- (id) initWithScenario:(Scenario *)scenario;
@end
