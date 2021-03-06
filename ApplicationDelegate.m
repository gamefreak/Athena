//
//  ApplicationDelegate.m
//  Athena
//
//  Created by Scott McClaugherty on 2/1/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ApplicationDelegate.h"
#import "AthenaDocument.h"
#import "DownloadWindow.h"
#import "Color.h"

NSString *XSAresDataUrl = @"https://github.com/downloads/gamefreak/Athena/AresMedia.zip";
NSString *XSHasAskedForData = @"AskedToGetData";
NSString *XSHasAresData = @"HasAresData";
NSString *HeraHelpURL = @"http://hera.arescentral.org/";


@implementation ApplicationDelegate
- (void) applicationDidFinishLaunching:(NSNotification *)notification {
    //Prepare the reverse color lookuptable
    rclut_init();

    NSMutableDictionary *baseDefaults = [NSMutableDictionary dictionary];
    [baseDefaults setObject:[NSNumber numberWithBool:NO] forKey:XSHasAskedForData];
    [baseDefaults setObject:[NSNumber numberWithBool:NO] forKey:XSHasAresData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults  registerDefaults:baseDefaults];
    
    BOOL hasData = [defaults boolForKey:XSHasAresData];
    BOOL asked = [defaults boolForKey:XSHasAskedForData];
    if (!hasData && !asked) {
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert setMessageText:@"Download ares data?"];
        [alert setInformativeText:@"To make scenario creation easier it is possible to start with the original scenario from Ares."];
        [alert addButtonWithTitle:@"Yes"];
        [alert addButtonWithTitle:@"No"];
        NSInteger result = [alert runModal];
        if (result == 1000) {
            [self downloadAresData];
        } else if (result == 1001) {
        }
        [defaults setBool:YES forKey:XSHasAskedForData];
    } else if (hasData) {
        [self openDefaultData];
    } else if (asked && !hasData) {
        //Ask for file
        [[NSDocumentController sharedDocumentController] openDocument:nil];
    }
}

+ (NSString *)supportDir {
    NSString *appSupport = NSHomeDirectory();
    appSupport = [appSupport stringByAppendingPathComponent:@"Library"];
    appSupport = [appSupport stringByAppendingPathComponent:@"Application Support"];
    appSupport = [appSupport stringByAppendingPathComponent:@"Athena"];
    return appSupport;
}

+ (void)ensureDirectoryExists:(NSString *)dir {
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dir]) {
        [fm createDirectoryAtPath:dir
      withIntermediateDirectories:YES
                       attributes:nil
                            error:&error];
        if (error) {
            NSLog(@"Failed to create directory: %@", error);
        }
    }
}


- (void)downloadAresData {
    NSString *appSupport = [ApplicationDelegate supportDir];
    [ApplicationDelegate ensureDirectoryExists:appSupport];
    NSURL *url = [NSURL URLWithString:XSAresDataUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0f];

    DownloadWindow *dWindow = [[DownloadWindow alloc] initWithWindowNibName:@"ProgressWindow"];
    [dWindow setDisplayText:@"Downloading Ares Data"];
    [dWindow setDestination:appSupport];
    NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:request delegate:dWindow];
    [download setDestination:[appSupport stringByAppendingPathComponent:@"AresMedia.zip"] allowOverwrite:YES];
    [dWindow showWindow:nil];
    [download release];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadDidComplete:)
                                                 name:XSDownloadComplete
                                               object:dWindow];
    [dWindow release];
    

}

- (void)downloadDidComplete:(NSNotification *)notification {
    //Open the archive
    NSString *path = [ApplicationDelegate supportDir];
    NSString *file = [path stringByAppendingPathComponent:@"AresMedia.zip"];
    NSString *dest = [path stringByAppendingPathComponent:@"Ares Data"];
    //use ditto not unzip because unzip doesn't handle resource fork
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/ditto"];
    [task setArguments:[NSArray arrayWithObjects:@"-xk", file, dest, nil]];
    [task setCurrentDirectoryPath:path];
    [task launch];
    [task waitUntilExit];
    if ([task terminationStatus]) {
        NSLog(@"Unzip failed");
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:XSHasAresData];
    }
    [task release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XSDownloadComplete object:[notification object]];
    [self openDefaultData];
}

- (void)openDefaultData {
    NSDocumentController *controller = [NSDocumentController sharedDocumentController];
    NSError *error = nil;
    NSString *path = [[ApplicationDelegate supportDir] stringByAppendingPathComponent:@"Ares Data"];
    NSURL *fileURL = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:@"Ares Scenarios"]];
    [controller openDocumentWithContentsOfURL:fileURL
                                      display:YES
                                        error:&error];
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
}

- (IBAction)openOrignalData:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:XSHasAresData]) {
        [self openDefaultData];
    } else {
        [self downloadAresData];
    }
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender {
    return NO;
}

- (IBAction)redownloadData:(id)sender {
    [self downloadAresData];
}


- (IBAction)showHeraHelp:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HeraHelpURL]];
}
@end
