//
//  main.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "cmdline.h"
#import "ApplicationDelegate.h"
#import "AthenaDocument.h"

int main(int argc, char *argv[]) {
    BOOL hasPSN = NO;
    if (argc > 1 && strncmp("-psn", argv[1], 4) == 0) {
        hasPSN = YES;
    }
    BOOL unhandledArguments = NO;
    struct athena_args args;
    if (!hasPSN && arg_parser(argc, argv, &args) != 0) {
        unhandledArguments = YES;
    }
    if (hasPSN || unhandledArguments || !args.base_given) {
        NSLog(@"No parameters, starting to GUI");
        if (!hasPSN) {
            arg_parser_free(&args);   
        }
        return NSApplicationMain(argc, (const char **) argv);
    }

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    //Determine file to work with.
    //Get desired path
    NSString *path = nil;
    NSString *supportDir = [ApplicationDelegate supportDir];
    BOOL needsToDownloadData = NO;
    if (args.base_arg == NULL) {
        //use downloaded info from Application Support
        path = supportDir;
        [ApplicationDelegate ensureDirectoryExists:path];
        path = [path stringByAppendingPathComponent:@"Ares Data"];
        path = [path stringByAppendingPathComponent:@"Ares Scenarios"];
        //check if we need to download anyway
        needsToDownloadData = ![[NSUserDefaults standardUserDefaults] boolForKey:XSHasAresData];
    } else {
        //use specified file
        path = [NSString stringWithUTF8String:args.base_arg];
    }
    if ((args.download_given) || needsToDownloadData) {
        NSString *downloadPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AresMedia.zip"];
        //Download data from host to desired file path
        NSTask *task;
        //Download
        task = [[[NSTask alloc] init] autorelease];
        [task setLaunchPath:@"/usr/bin/curl"];
        [task setArguments:[NSArray arrayWithObjects:@"--location", @"-o", downloadPath, XSAresDataUrl, nil]];
        [task setCurrentDirectoryPath:supportDir];
        [task launch];
        [task waitUntilExit];
        if ([task terminationStatus]) exit(1);

        //And unzip
        task = [[[NSTask alloc] init] autorelease];
        [task setLaunchPath:@"/usr/bin/ditto"];
        [task setArguments:[NSArray arrayWithObjects:@"-xk", downloadPath, [supportDir stringByAppendingPathComponent:@"Ares Data"], nil]];
        [task setCurrentDirectoryPath:supportDir];
        [task launch];
        [task waitUntilExit];
        if ([task terminationStatus]) exit(1);

        //Clean up
        task = [[[NSTask alloc] init] autorelease];
        [task setLaunchPath:@"/bin/rm"];
        [task setArguments:[NSArray arrayWithObjects:@"-f", downloadPath, nil]];
        [task launch];
        [task waitUntilExit];
        if ([task terminationStatus]) exit(1);
    }

    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    NSString *type = [[NSWorkspace sharedWorkspace] typeOfFile:path error:&error];
    if (error) {
        NSLog(@"ERROR %@", error);
        exit(1);
    }

    AthenaDocument *document = [[[AthenaDocument alloc] initWithContentsOfURL:url ofType:type error:&error] autorelease];
    if (error) {
        NSLog(@"ERROR %@", error);
        exit(1);
    }

    //FUTURE: handle check
    //FUTURE: handle list

    //Should we create a new file?
    if (args.out_given) {
        assert(args.type_given);
        //retrieve output type
        NSString *type = nil;
        switch (args.type_arg) {
            case type_arg_ares:
                type = XSAresPluginUTI;
                break;
            case type_arg_xsera:
                type = XSXseraPluginUTI;
                break;
            case type_arg_antares:
                type = XSAntaresPluginUTI;
                break;
            default:
                assert(0);
                break;
        }
        assert(type);
        //Get output path
        NSURL *outUrl = [NSURL fileURLWithPath:[[NSString stringWithUTF8String:args.out_arg] stringByExpandingTildeInPath]];
        error = nil;
        BOOL result = [document writeToURL:outUrl ofType:type error:&error];
        if (!result || error) {
            NSLog(@"Error: %@", error);
            exit(1);
        }
    }
    //clean up
    [pool drain];
    arg_parser_free(&args);
    return 0;
}
