//
//  main.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "cmdline.h"

int main(int argc, char *argv[]) {
    struct athena_args args;
    if (arg_parser(argc, argv, &args) != 0) {
        exit(1);
    }
    if (!args.base_given) {
        NSLog(@"No parameters, starting to GUI");
        arg_parser_free(&args);
        return NSApplicationMain(argc, (const char **) argv);
    }

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    //Determine file to work with.
    //Get desired path in a NSString
    if (args.base_arg == NULL) {
        //use downloaded info from Application Support
    } else {
        //use specified file
    }

    if (args.download_given) {
        //Download data from host to desired file path
    }

    //FUTURE: handle check
    //FUTURE: handle list

    if (args.type_given) {
        assert(args.out_given);
        //retrieve output type
        //retrieve output filename
        //save file
    }
    [pool drain];
    arg_parser_free(&args);
    return 0;
}
