//
//  ProgressWindow.m
//  Athena
//
//  Created by Scott McClaugherty on 8/29/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ProgressWindow.h"


@implementation ProgressWindow
@synthesize percentage;
- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        percentage = 0.0f;
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (NSString *)displayText {
    return @"PLACEHOLDER";
}

- (BOOL)displayCancelButton {
    return YES;
}

- (IBAction)cancel:(id)sender {
    [self close];
}
@end
