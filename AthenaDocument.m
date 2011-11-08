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
#import "ApplicationDelagate.h"

#import "ObjectEditor.h"
#import "ScenarioEditor.h"
#import "RaceEditor.h"
#import "ImageEditor.h"
#import "SpriteEditor.h"
#import "SoundEditor.h"

#import "NSStringExtensions.h"
#import <sys/stat.h>

NSString *XSAntaresPluginUTI = @"org.arescentral.antares.plugin";
NSString *XSAresPluginUTI = @"com.biggerplanet.AresData";
NSString *XSXseraPluginUTI = @"org.brainpen.XseraPlugin";

NSString *XSAthenaMayCleanAntaresData = @"AntaresDidInstallScenarioFromPath";

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

@interface AthenaDocument (Private)
- (void)deleteAntaresTemp:(NSNotification *)notification;
@end

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

- (void)awakeFromNib {
    [[identifierField cell] bind:@"placeholderString" toObject:self withKeyPath:@"data.computedIdentifier" options:nil];
}

- (BOOL) writeToURL:(NSURL *)absoluteURL ofType:(NSString *)type error:(NSError **)outError {
    NSLog(@"Saving data of type: %@", type);
    NSString *fileName = [absoluteURL path];
    if ([type isEqualToCaseInsensitiveString:XSAresPluginUTI]) {
        ResArchiver *coder = [[ResArchiver alloc] init];
        [coder setSaveType:DataBasisAres];
        [coder encodeObject:data atIndex:128];
        BOOL success = [coder writeToResourceFile:fileName];
        [coder release];
        NSLog(@"Save complete");
        return success;
    } else if ([type isEqualToCaseInsensitiveString:XSXseraPluginUTI]) {
        return [super writeToURL:absoluteURL ofType:type error:outError];
    } else if ([type isEqualToCaseInsensitiveString:XSAntaresPluginUTI]) {
        ResArchiver *coder = [[ResArchiver alloc] init];
        [coder setSaveType:DataBasisAntares];
        [coder encodeObject:data atIndex:128];
        BOOL success = [coder writeToZipFile:fileName];
        [coder release];
        NSLog(@"Save complete");
        return success;
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
    [arch saveFile:arch.data named:@"data.lua" inDirectory:@"Scripts/Modules"];
    NSMutableDictionary *files = [arch files];
    NSFileWrapper *wrapper = generateFileWrapperFromDictionary(files);
    [arch release];
    NSLog(@"Save complete");
    return wrapper;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)type error:(NSError **)outError {
    NSString *fileName = [url path];
    NSLog(@"Reading Data of type (%@)", type);
    [data release];
    data = nil;
    @try {
        if ([type isEqualToCaseInsensitiveString:XSXseraPluginUTI]){
            return [super readFromURL:url ofType:type error:outError];
        } else if ([type isEqualToCaseInsensitiveString:XSAresPluginUTI]) {
            ResUnarchiver *coder = [[ResUnarchiver alloc] init];
            NSString *dataDir = [[ApplicationDelagate supportDir] stringByAppendingPathComponent:@"Ares Data"];
            [coder addFile:[dataDir stringByAppendingPathComponent:@"Ares Sprites"] ofType:DataBasisAres];
            [coder addFile:[dataDir stringByAppendingPathComponent:@"Ares Sounds"] ofType:DataBasisAres];
            [coder addFile:[dataDir stringByAppendingPathComponent:@"Ares Interfaces"] ofType:DataBasisAres];
            [coder addFile:[dataDir stringByAppendingPathComponent:@"Ares Scenarios"] ofType:DataBasisAres];
            if (![[fileName lastPathComponent] isEqualTo:@"Ares Scenarios"]) {
                [coder addFile:fileName ofType:DataBasisAres];
            }
            data = [[coder decodeObjectOfClass:[MainData class] atIndex:128] retain];
            [coder release];
        } else if ([type isEqualToCaseInsensitiveString:XSAntaresPluginUTI]) {
            ResUnarchiver *coder = [[ResUnarchiver alloc] init];
            NSString *dataDir = [[ApplicationDelagate supportDir] stringByAppendingPathComponent:@"Ares Data"];
            [coder addFile:[dataDir stringByAppendingPathComponent:@"Ares Sprites"] ofType:DataBasisAres];
            [coder addFile:[dataDir stringByAppendingPathComponent:@"Ares Sounds"] ofType:DataBasisAres];
            [coder addFile:[dataDir stringByAppendingPathComponent:@"Ares Interfaces"] ofType:DataBasisAres];
            [coder addFile:[dataDir stringByAppendingPathComponent:@"Ares Scenarios"] ofType:DataBasisAres];

            [coder addFile:fileName ofType:DataBasisAntares];
            data = [[coder decodeObjectOfClass:[MainData class] atIndex:128] retain];
            [coder release];
            return YES;
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
    [arch loadData:[arch fileNamed:@"data.lua" inDirectory:@"Scripts/Modules"]];
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

- (IBAction)openImageEditor:(id)sender {
    ImageEditor *imageEditor = [[ImageEditor alloc] initWithMainData:data];
    [self addWindowController:imageEditor];
    [imageEditor showWindow:self];
    [imageEditor release];
}

- (IBAction) openSpriteEditor:(id)sender {
    SpriteEditor *spriteEditor = [[SpriteEditor alloc] initWithMainData:data];
    [self addWindowController:spriteEditor];
    [spriteEditor showWindow:self];
    [spriteEditor release];
}

- (IBAction)openSoundEditor:(id)sender {
    SoundEditor *soundEditor = [[SoundEditor alloc] initWithMainData:data];
    [self addWindowController:soundEditor];
    [soundEditor showWindow:self];
    [soundEditor release];
}

- (IBAction) displayEasterWindow:(id)sender {
    [easter makeKeyAndOrderFront:self];
}

- (IBAction) launchInAntares:(id)sender {
    NSString *fileName = nil;
    BOOL isAntaresFileType = [[self fileType] isEqualToCaseInsensitiveString:XSAntaresPluginUTI];
    if ([self isDocumentEdited] || !isAntaresFileType) {
        fileName = NSTemporaryDirectory();
        fileName = [fileName stringByAppendingPathComponent:[[[self data] computedIdentifier] stringByReplacingOccurrencesOfString:@"." withString:@"_" ]];
        fileName = [fileName stringByAppendingPathExtension:[self fileNameExtensionForType:XSAntaresPluginUTI saveOperation:NSSaveToOperation]];
        NSError *error = nil;
        [self saveToURL:[NSURL fileURLWithPath:fileName] ofType:XSAntaresPluginUTI forSaveOperation:NSSaveToOperation error:&error];
        if (error != nil) {
            [self presentError:error];
            return;
        }

        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAntaresTemp:) name:XSAthenaMayCleanAntaresData object:[fileName stringByStandardizingPath]];
    } else {
        fileName = [[self fileURL] path];
    }
    [[NSWorkspace sharedWorkspace] openFile:fileName withApplication:@"/Users/scott/dev/antares/build/antares/Antares.app"];
}

- (void)deleteAntaresTemp:(NSNotification *)notification {
    NSString *file = [notification object];
    NSLog(@"Deleting: %@", file);
    unlink([file fileSystemRepresentation]);
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:XSAthenaMayCleanAntaresData object:file];
}
@end

@implementation AthenaDocumentWindow
- (void)keyDown:(NSEvent *)event {
    if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
        [NSApp sendAction:@selector(displayEasterWindow:) to:nil from:self];
    } else {
        [super keyDown:event];
    }
}

- (void)sendEvent:(NSEvent *)event {
    if ([event type] == NSKeyDown && ([event modifierFlags] & NSAlternateKeyMask) == NSAlternateKeyMask && [[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
        [NSApp sendAction:@selector(displayEasterWindow:) to:nil from:self];
    } else {
        [super sendEvent:event];
    }
}
@end

@implementation EasterWindow
- (void)makeKeyAndOrderFront:(id)sender {
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"Easter" withExtension:@"txt"];
    NSError *error = nil;
    NSArray *lines = [[NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
    NSString *msg = [lines objectAtIndex:(arc4random() % [lines count])];

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[NSFont fontWithName:@"Helvetica" size:24.0f]
                   forKey:NSFontAttributeName];
    NSAttributedString *message = [[[NSAttributedString alloc] initWithString:msg
                                                                   attributes:attributes] autorelease];
    [label setAttributedStringValue:message];
    [super makeKeyAndOrderFront:sender];
}

- (void)keyDown:(NSEvent *)theEvent {
    [self performClose:theEvent];
}
@end

