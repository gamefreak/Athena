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

#import <sys/stat.h>

NSFileWrapper *generateFileWrapperFromDictionary(NSDictionary *dictionary) {
    NSFileWrapper *wrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:[NSDictionary dictionary]];
    for (NSString *key in [dictionary keyEnumerator]) {
        id obj = [dictionary objectForKey:key];
        NSFileWrapper *file = nil;
        if ([obj isKindOfClass:[NSData class]]) {
            file = [[[NSFileWrapper alloc] initRegularFileWithContents:(NSData *)obj] autorelease];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            file = generateFileWrapperFromDictionary(obj);
        }
        [file setPreferredFilename:key];
        [wrapper addFileWrapper:file];
    }
    return [wrapper autorelease];
}

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
    NSLog(@"Saving data of type: %@", type);
    NSString *fileName = [absoluteURL path];
    if ([type isEqualTo:@"com.biggerplanet.AresData"]) {
        ResArchiver *coder = [[ResArchiver alloc] init];
        [coder encodeObject:data atIndex:128];
        BOOL success = [coder writeToFile:fileName];
        assert(success==YES);
        [coder release];
        return success;
    } else if ([type isEqualTo:@"org.brainpen.XseraPlugin"]) {
        return [super writeToURL:absoluteURL ofType:type error:outError];
    } else {
        //BAD!!!
        return NO;
    }
    return NO;//This should never be reached.
}

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError {
    LuaArchiver *arch = [[LuaArchiver alloc] init];
    [arch encodeObject:data forKey:@"data"];
    [arch sync];
    NSMutableDictionary *files = [arch files];
    [files setObject:arch.data forKey:@"data.lua"];
    NSFileWrapper *wrapper = generateFileWrapperFromDictionary(files);
    [arch release];
    return wrapper;
}

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)type {
    NSLog(@"Reading Data of type (%@)", type);
    [data release];
    data = nil;
    @try {
        if ([type isEqual:@"org.brainpen.xseraplugin"]){
            return [super readFromFile:fileName ofType:type];
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
    }
    @catch (id exception) {
        NSLog(@"Error while opening:\n%@", exception);
        return NO;
    }
    return YES;
}

- (BOOL)loadFileWrapperRepresentation:(NSFileWrapper *)wrapper ofType:(NSString *)type {
    LuaUnarchiver *arch = [[LuaUnarchiver alloc] init];
    [arch setBaseDir:wrapper];
    [arch loadData:[arch fileNamed:@"data.lua" inDirectory:@""]];
    [data release];
    data = [[arch decodeObjectOfClass:[MainData class] forKey:@"data"] retain];
    [arch release];
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
