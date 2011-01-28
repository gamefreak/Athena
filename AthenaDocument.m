//
//  AthenaDocument.m
//  Athena
//
//  Created by Scott McClaugherty on 1/20/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "AthenaDocument.h"
#import "MainData.h"
#import "Archivers.h"

#import "RaceEditor.h"
#import "ScenarioEditor.h"

@implementation AthenaDocument
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
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *) dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    NSData *outData = [LuaArchiver archivedDataWithRootObject:data withName:@"data"];
    if (outError != NULL) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return outData;
}

- (BOOL) readFromData:(NSData *)inData ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.

    [data release];
    data = [LuaUnarchiver unarchiveObjectWithData:inData];
    [data retain];
    if (outError != NULL) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

- (void) dealloc {
    [data release];
    [super dealloc];
}

- (IBAction) openRaceEditor:(id)sender {
    RaceEditor *raceEditor = [[RaceEditor alloc] initWithMainData:data];
    [self addWindowController:raceEditor];
    [raceEditor setDocument:self];
    [raceEditor showWindow:self];
    [raceEditor release];
}

- (IBAction) openScenarioEditor:(id)sender {
    ScenarioEditor *scenarioEditor = [[ScenarioEditor alloc] initWithMainData:data];
    [self addWindowController:scenarioEditor];
    [scenarioEditor setDocument:self];
    [scenarioEditor showWindow:self];
    [scenarioEditor release];
}
@end
