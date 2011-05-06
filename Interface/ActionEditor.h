//
//  ActionEditor.h
//  Athena
//
//  Created by Scott McClaugherty on 5/3/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ActionEditor : NSViewController {
    IBOutlet NSView *targetView;
    NSMutableArray *actions;
}
@property (readwrite, retain) NSMutableArray *actions;
@end
