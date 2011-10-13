//
//  ActionViewController.h
//  Athena
//
//  Created by Scott McClaugherty on 7/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Action;
@class BaseObject;

@interface ActionViewController : NSViewController {
    Action *actionObj;
    IBOutlet NSObjectController *actionController;
}
@property (readwrite, retain) Action *actionObj;
@property (readwrite, retain) BaseObject *type;
@property (readwrite, retain) BaseObject *ref;
@property (readwrite) NSUInteger nextScenarioIndex;
- (IBAction)openObjectPicker:(id)sender;
- (IBAction)openObjectPicker2:(id)sender;
@end
