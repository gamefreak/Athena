//
//  ImageEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 10/4/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ImageEditor.h"
#import "MainData.h"
#import "XSImageView.h"
#import "XSImage.h"
#import "XSKeyValuePair.h"

@interface ImageEditor (Private)
- (void)insertObject:(XSImage *)object inImagesAtIndex:(NSUInteger)index;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)index;
@end


@implementation ImageEditor
@synthesize data;
@synthesize images;

- (id)initWithMainData:(MainData *)data_ {
    self = [super initWithWindowNibName:@"ImageEditor"];
    if (self) {
        data = [data_ retain];
        images = [[data images] retain];
    }
    return self;
}

- (void)dealloc {
    [images release];
    [data release];
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [imageView bind:@"image" toObject:arrayController withKeyPath:@"selection.value" options:nil];
}

- (IBAction)openImage:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSImage imageTypes]];
    [openPanel setAllowsOtherFileTypes:NO];
    [openPanel setAllowsMultipleSelection:NO];
    assert([openPanel canChooseFiles]);
    assert(![openPanel canChooseDirectories]);

    [openPanel retain];
    [openPanel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            [self addImageForPath:[[[openPanel URLs] objectAtIndex:0] path]];
        }
        [openPanel autorelease];
    }];
}

- (BOOL)addImageForPath:(NSString *)file {
    NSError *error = nil;
    NSString *type = [[NSWorkspace sharedWorkspace] typeOfFile:file error:&error];
    if (error) {
        [[NSAlert alertWithError:error] runModal];
        return NO;
    }

    XSImage *image = nil;
    //Load the sound
    if ([[NSImage imageTypes] containsObject:type]) {
        image = [[XSImage alloc] init];
        [image setName:[[file lastPathComponent] stringByDeletingPathExtension]];
        [image setImage:[[[NSImage alloc] initWithContentsOfFile:file] autorelease]];
        BOOL ok = [self addImage:image];
        [image release];
        return ok;
    }
    return NO;
}

- (BOOL)addImage:(XSImage *)image {
    if (image != nil) {
        //get keys
        NSArray *keys = [images valueForKeyPath:@"key"];
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

        NSAssert(![keys containsObject:key], @"images table contained unexpected key %@", key);

        XSKeyValuePair *pair = [arrayController newObject];
        [pair setKey:key];
        [pair setValue:image];
        [arrayController addObject:pair];
        [pair release];
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:[NSArray arrayWithObjects:NSFileContentsPboardType, NSFilesPromisePboardType, nil] owner:self];

    NSMutableArray *fileNames = [NSMutableArray array];
    for (XSKeyValuePair *pair in [[arrayController arrangedObjects] objectsAtIndexes:rowIndexes]) {
        XSImage *image = pair.value;
        NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:[image PNGData]];
        NSString *filename = [[image name] stringByAppendingPathExtension:@"png"];
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
    [wrapper writeToURL:[dropDestination URLByAppendingPathComponent:[wrapper filename]]
                options:NSFileWrapperWritingAtomic originalContentsURL:nil error:&error];
    return [NSArray arrayWithObject:[[dropDestination path] stringByAppendingPathComponent:[wrapper filename]]];
}

- (void)insertObject:(XSImage *)object inImagesAtIndex:(NSUInteger)index {
    [[[[self document] undoManager] prepareWithInvocationTarget:self] removeObjectFromImagesAtIndex:index];
    [images insertObject:object atIndex:index];
}

- (void)removeObjectFromImagesAtIndex:(NSUInteger)index {
    [[[[self document] undoManager] prepareWithInvocationTarget:self] insertObject:[images objectAtIndex:index] inImagesAtIndex:index];
    [images removeObjectAtIndex:index];
}

@end


@implementation ImageImporterTableView
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
        return [[[self window] windowController] addImageForPath:file];
    }
    return NO;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender {
}
@end

