//
//  ProgressWindow.h
//  Athena
//
//  Created by Scott McClaugherty on 8/29/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ProgressWindow : NSWindowController {
    float percentage;
    IBOutlet NSProgressIndicator *progressBar;
}
@property (assign) float percentage;
- (NSString *)displayText;
- (BOOL)displayCancelButton;

- (IBAction)cancel:(id)sender;
@end
