//
//  SoundEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 9/25/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SoundEditor.h"

#import "MainData.h"
#import "XSSound.h"
#import "XSKeyValuePair.h"

@interface SoundEditor (Private)
- (void)insertObject:(XSSound *)object inSoundsAtIndex:(NSUInteger)index;
- (void)removeObjectFromSoundsAtIndex:(NSUInteger)index;
@end

@implementation SoundEditor
@synthesize sounds;

- (id)initWithMainData:(MainData *)data {
    self = [super initWithWindowNibName:@"SoundEditor"];
    if (self) {
        sounds = [[data sounds] retain];
    }
    return self;
}

- (IBAction)playSound:(id)sender {
    NSUInteger index = [soundsController selectionIndex];
    if (index == NSNotFound) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [(XSSound *)[[[soundsController arrangedObjects] objectAtIndex:index] value] play];
    });
}

- (IBAction)openSound:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"ogg", nil]];
    [openPanel setAllowsOtherFileTypes:NO];
    [openPanel setAllowsMultipleSelection:NO];
    assert([openPanel canChooseFiles]);
    assert(![openPanel canChooseDirectories]);
//    [openPanel setDirectory:NSHomeDirectory()];

    [openPanel retain];
    [openPanel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            [self addSoundForPath:[[[openPanel URLs] objectAtIndex:0] path]];
        }
        [openPanel autorelease];
    }];
}

- (void)dealloc {
    [sounds release];
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES selector:@selector(numericCompare:)];
    [soundsController setSortDescriptors:[NSArray arrayWithObject:desc]];
}

- (BOOL)addSoundForPath:(NSString *)file {
    NSError *error = nil;
    NSString *type = [[NSWorkspace sharedWorkspace] typeOfFile:file error:&error];
    if (error) {
        [[NSAlert alertWithError:error] runModal];
        return NO;
    }
    XSSound *sound = nil;
    //Load the sound
    if ([type hasSuffix:@"ogg"]) {
        sound = [[XSSound alloc] init];
        [sound setName:[[file lastPathComponent] stringByDeletingPathExtension]];
        [sound setVorbis:[NSData dataWithContentsOfFile:file options:NSDataReadingUncached error:nil]];
        [self addSound:sound];
        [sound release];
    }
    return NO;
}

- (BOOL)addSound:(XSSound *)sound {
    if (sound != nil) {
        //get keys
        NSArray *keys = [sounds valueForKeyPath:@"key"];
        int firstIndex = [[keys valueForKeyPath:@"@min.intValue"] intValue];
        int lastIndex = [[keys valueForKeyPath:@"@max.intValue"] intValue];
        int found = -1;
        //scan for gaps
        for (int k = firstIndex; k < lastIndex; k++) {
            NSString *tk = [[NSNumber numberWithInt:k] stringValue];
            if (![keys containsObject:tk]) {
                found = k;
                break;
            }
        }
        NSString *key = nil;
        if (found == -1) {
            found = lastIndex + 1;
        }
        key = [[NSNumber numberWithInt:found] stringValue];
        
        NSAssert(![keys containsObject:key], @"sounds table contained unexpected key %@", key);
        
        id pair = [soundsController newObject];
        [pair setKey:key];
        [pair setValue:sound];
        [soundsController addObject:pair];
        [pair release];
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:[NSArray arrayWithObjects:NSFileContentsPboardType, NSFilesPromisePboardType, nil] owner:self];

    NSMutableArray *fileNames = [NSMutableArray array];
    for (XSKeyValuePair *pair in [[soundsController arrangedObjects] objectsAtIndexes:rowIndexes]) {
        XSSound *sound = pair.value;
        NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:[sound getVorbis]];
        NSString *filename = [[sound name] stringByAppendingPathExtension:@"ogg"];
        [wrapper setFilename:filename];
        [wrapper setPreferredFilename:filename];
        [pboard writeFileWrapper:wrapper];
        [wrapper release];
        [fileNames addObject:filename];
        break;
    }

    [pboard setPropertyList:fileNames forType:NSFilesPromisePboardType];
    return YES;
}

- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {
    NSFileWrapper *wrapper = [[NSPasteboard pasteboardWithName:NSDragPboard] readFileWrapper];
    NSError *error = nil;
    BOOL result = [wrapper writeToURL:[dropDestination URLByAppendingPathComponent:[wrapper filename]]
                                options:NSFileWrapperWritingAtomic originalContentsURL:nil error:&error];
    if (error) {
        [NSAlert alertWithError:error];
    }
    return [NSArray arrayWithObject:[[dropDestination path] stringByAppendingPathComponent:[wrapper filename]]];
}

- (void)insertObject:(XSSound *)object inSoundsAtIndex:(NSUInteger)index {
    [[[[self document] undoManager] prepareWithInvocationTarget:self] removeObjectFromSoundsAtIndex:index];
    [sounds insertObject:object atIndex:index];
}

- (void)removeObjectFromSoundsAtIndex:(NSUInteger)index {
    [[[[self document] undoManager] prepareWithInvocationTarget:self] insertObject:[sounds objectAtIndex:index] inSoundsAtIndex:index];
    [sounds removeObjectAtIndex:index];
}
@end


@implementation SoundImporterTableView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    [self setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    BOOL okForFileDrag = [[[sender draggingPasteboard] types] containsObject:NSFilenamesPboardType];
    return (NSDragOperationCopy * okForFileDrag);
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    BOOL okForFileDrag = [[[sender draggingPasteboard] types] containsObject:NSFilenamesPboardType];
    return (NSDragOperationCopy * okForFileDrag);
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSPasteboard *pb = [sender draggingPasteboard];
    if ([[pb types] containsObject:NSFilenamesPboardType]) {
        NSArray *fileNames = [pb propertyListForType:NSFilenamesPboardType];
        if ([fileNames count] < 1) {
            return NO;
        }
        NSString *file = [fileNames objectAtIndex:0];
        return [[[self window] windowController] addSoundForPath:file];
    }
    return NO;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender {
}
@end
