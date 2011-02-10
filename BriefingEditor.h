//
//  BriefingEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 2/8/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Scenario;

@interface BriefingEditor : NSWindowController {
    Scenario *scenario;
}
- (id) initWithScenario:(Scenario *)scenario;
@end
