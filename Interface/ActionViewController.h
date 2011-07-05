//
//  ActionViewController.h
//  Athena
//
//  Created by Scott McClaugherty on 7/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Action;

@interface ActionViewController : NSViewController {
@private
    Action *action;
}
@property (readwrite, retain) Action *action;
@end
