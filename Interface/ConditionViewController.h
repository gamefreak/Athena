//
//  ConditionViewController.h
//  Athena
//
//  Created by Scott McClaugherty on 8/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Condition;

@interface ConditionViewController : NSViewController {
    Condition *conditionObj;
    IBOutlet NSObjectController *conditionController;
}
@property (readwrite, retain) Condition *conditionObj;
@end
