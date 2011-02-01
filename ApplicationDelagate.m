//
//  ApplicationDelagate.m
//  Athena
//
//  Created by Scott McClaugherty on 2/1/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ApplicationDelagate.h"
#import "AthenaDocument.h"

@implementation ApplicationDelagate
- (void) applicationDidFinishLaunching:(NSNotification *)notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *location = [defaults URLForKey:@"DefaultDataLocation"];

    if (location == nil) {
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setAllowsMultipleSelection:YES];
        [openPanel setTitle:@"Select default file location"];
        [openPanel setMessage:@"Select the default data file."];
        [openPanel setDirectory:NSHomeDirectory()];

        NSInteger result = [openPanel runModal];

        if (result == NSOKButton) {
            location = [openPanel URL];
            [defaults setURL:location forKey:@"DefaultDataLocation"];
        }
    }
    if (location != nil) {
        NSDocumentController *doc = [NSDocumentController sharedDocumentController];
        NSError **error;
        [doc openDocumentWithContentsOfURL:location
                                   display:YES
                                     error:error];
        if (error != NULL) {
            NSLog(@"ERROR: %@", *error);
        }
    }
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender {
    return NO;
}
@end
