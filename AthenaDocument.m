//
//  AthenaDocument.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "AthenaDocument.h"
#import "MainData.h"
#import "StringTable.h"
#import "Archivers.h"

#import "ObjectEditor.h"
#import "ScenarioEditor.h"
#import "RaceEditor.h"
#import "SpriteEditor.h"

@implementation AthenaDocument
@synthesize data;

- (id) init {
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        data = [[MainData alloc] init];
    }
    return self;
}

- (NSString *) windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"AthenaDocument";
}

- (void) windowControllerDidLoadNib:(NSWindowController *) aController {
    [super windowControllerDidLoadNib:aController];
    [aController setShouldCloseDocument:YES];
}

- (BOOL) writeToURL:(NSURL *)absoluteURL ofType:(NSString *)type error:(NSError **)outError {
    NSString *fileName = [absoluteURL path];
    if ([type isEqualTo:@"Ares Data"]) {
        ResArchiver *coder = [[ResArchiver alloc] init];
        [coder encodeObject:data atIndex:128];
        BOOL success = [coder writeToFile:fileName];
        [coder release];
        return success;
    } else if ([type isEqualTo:@"org.brainpen.XseraData"]) {
        NSString *fullName = [absoluteURL path];
        NSString *localRoot = [fullName stringByDeletingLastPathComponent];
        NSString *baseDir = [localRoot stringByAppendingPathComponent:@"data/"];
        //Set up the directories.
        chdir([localRoot UTF8String]);
        mkdir("data", 0777);
        chdir("./data");
        mkdir("Sounds", 0777);
        mkdir("Sprites", 0777);
        mkdir("Images", 0777);
        mkdir("Videos", 0777);
        chdir("..");

        NSData *outData = [LuaArchiver archivedDataWithRootObject:data withName:@"data" baseDirectory:baseDir];
        [outData writeToFile:[baseDir stringByAppendingPathComponent:@"data.lua"] atomically:YES];

        //tar/gzip it
        NSTask *gzipTask = [[NSTask alloc] init];
        [gzipTask setLaunchPath:@"/usr/bin/tar"];
        [gzipTask setArguments:[NSArray arrayWithObjects:@"cfz", [fullName lastPathComponent], @"./data/", nil]];
        [gzipTask setCurrentDirectoryPath:localRoot];
        [gzipTask launch];
        [gzipTask waitUntilExit];
        [gzipTask release];
        //clean up the directories

        NSTask *rmTask = [[NSTask alloc] init];
        [rmTask setLaunchPath:@"/bin/rm"];
        [rmTask setArguments:[NSArray arrayWithObjects:@"-r", @"./data/", nil]];
        [rmTask setCurrentDirectoryPath:localRoot];
        [rmTask launch];
        [rmTask waitUntilExit];
        [rmTask release];

        if (outError != NULL) {
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
        }
        return YES;
    } else {
        NSAssert([type isEqualTo:@"Xsera Lua"], @"Bad data type: \"%@\"", type);
        return [super writeToURL:absoluteURL ofType:type error:outError];
    }
    return NO;//This should never be reached.
}

- (NSData *) dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSData *outData = [LuaArchiver archivedDataWithRootObject:data withName:@"data"];
    if (outError != NULL) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return outData;
}

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)type {
    NSLog(@"Reading Data of type (%@)", type);
    [data release];
    if ([type isEqual:@"org.brainpen.xseralua"]) {
        //ughh
        NSString *baseDir = [[[fileName stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]  stringByDeletingLastPathComponent];
        data = [[LuaUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:fileName] baseDirectory:baseDir fromPlugin:NO] retain];

    } else if ([type isEqualTo:@"org.brainpen.xseradata"]) {
        NSString *baseDir = [fileName stringByDeletingLastPathComponent];
        @throw @"Unimplemented";
    } else if ([type isEqual:@"com.biggerplanet.aresdata"]) {
        ResUnarchiver *coder = [[ResUnarchiver alloc] initWithFilePath:fileName];
        if ([[fileName lastPathComponent] isEqual:@"Ares Scenarios"]) {
            NSLog(@"File is 'Ares Scenarios' attempting to load 'Ares Sprites'");
            [coder addFile:[[fileName stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Ares Sprites"]];
            NSLog(@"File is 'Ares Scenarios' attempting to load 'Ares Sounds'");
            [coder addFile:[[fileName stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Ares Sounds"]];
        }
        data = [[coder decodeObjectOfClass:[MainData class] atIndex:128] retain];
        [coder release];

#if 0
        char tempName[17] = "";
        strlcpy(tempName, "/tmp/TEST.XXXXXX", 17);
        mktemp(tempName);
        NSString *testFname = [NSString stringWithCString:tempName];
        NSLog(@"Running Encoder Test");
        ResArchiver *encoder = [[ResArchiver alloc] init];
        [encoder encodeObject:data atIndex:128];
        NSLog(@"Encoding Completed");
        NSLog(@"Writing to temp file: %@", testFname);
        if ([encoder writeToFile:testFname]) {
            NSLog(@"Write succeeded.");
        } else {
            NSLog(@"Write failed.");
        }
        [encoder release];
        NSLog(@"Encoder Test Completed");
        NSLog(@"Running re-decode test");
        ResUnarchiver *decoder = [[ResUnarchiver alloc] initWithFilePath:testFname];
        [decoder decodeObjectOfClass:[MainData class] atIndex:128];
        [decoder release];
        NSLog(@"Completed re-decode test");
        NSLog(@"Unlinking temp file");
        unlink(tempName);
#endif
    } else {
        NSLog(@"ERROR: Type not found. aborting");
        return NO;
    }
    return YES;
}

- (void) dealloc {
    [data release];
    [super dealloc];
}

- (IBAction) openObjectEditor:(id)sender {
    ObjectEditor *objectEditor = [[ObjectEditor alloc] initWithMainData:data];
    [self addWindowController:objectEditor];
    [objectEditor showWindow:self];
    [objectEditor release];
}

- (IBAction) openScenarioEditor:(id)sender {
    ScenarioEditor *scenarioEditor = [[ScenarioEditor alloc] initWithMainData:data];
    [self addWindowController:scenarioEditor];
    [scenarioEditor showWindow:self];
    [scenarioEditor release];
}

- (IBAction) openRaceEditor:(id)sender {
    RaceEditor *raceEditor = [[RaceEditor alloc] initWithMainData:data];
    [self addWindowController:raceEditor];
    [raceEditor showWindow:self];
    [raceEditor release];
}

- (IBAction) openSpriteEditor:(id)sender {
    SpriteEditor *spriteEditor = [[SpriteEditor alloc] initWithMainData:data];
    [self addWindowController:spriteEditor];
    [spriteEditor showWindow:self];
    [spriteEditor release];
}
@end
