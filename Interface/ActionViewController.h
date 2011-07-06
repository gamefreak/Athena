//
//  ActionViewController.h
//  Athena
//
//  Created by Scott McClaugherty on 7/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Action;
@class ObjectTypeSelector;
@class Index;

@interface ActionViewController : NSViewController {
@private
    IBOutlet ObjectTypeSelector *objectPickerView;//Not always used
    Action *action;
}
@property (readwrite, retain) Action *action;
@property (readwrite, retain) Index *baseObjectType;//This is a workaround
@end
