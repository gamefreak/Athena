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
    [arrayController setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"objectIndex" ascending:YES]]];
    [imageView bind:@"image" toObject:arrayController withKeyPath:@"selection.self" options:nil];
}

- (NSString*) windowTitleForDocumentDisplayName:(NSString*)name {
    return [NSString stringWithFormat:@"%@—Images", name];
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

- (IBAction)exportImage:(id)sender {
    NSUInteger index = [arrayController selectionIndex];
    if (index == NSNotFound) {
        return;
    }
    XSImage *image = [[[arrayController arrangedObjects] objectAtIndex:index] retain];
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"png"]];
    [savePanel setNameFieldStringValue:[[image name] stringByAppendingPathExtension:@"png"]];
    [savePanel setCanSelectHiddenExtension:YES];
    [savePanel retain];
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            BOOL ok = [[image PNGData] writeToURL:[savePanel URL] atomically:YES];
            if (!ok) {
                NSRunAlertPanel(@"Unable to export image.", @"Athena was unable to export the image.", nil, nil, nil);
            }
        }
        [image release];
        [savePanel autorelease];
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
        NSArray *IDs = [images valueForKeyPath:@"objectIndex"];
        int firstID = [[IDs valueForKeyPath:@"@min.intValue"] intValue];
        int lastID = [[IDs valueForKeyPath:@"@max.intValue"] intValue];
        int found = -1;
        //scan for gaps
        for (int k = firstID; k < lastID; k++) {
            NSNumber *tk = [NSNumber numberWithInt:k];
            if (![IDs containsObject:tk]) {
                found = k;
                break;
            }
        }
        NSNumber *ID = nil;
        if (found == -1) {
            found = lastID + 1;
        }
        ID = [NSNumber numberWithInt:found];

        NSAssert(![IDs containsObject:ID], @"images table contained unexpected id %@", ID);
        [image setObjectIndex:[ID integerValue]];
        [arrayController addObject:image];
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:[NSArray arrayWithObjects:NSFileContentsPboardType, NSFilesPromisePboardType, nil] owner:self];

    NSMutableArray *fileNames = [NSMutableArray array];
    for (XSImage *image in [[arrayController arrangedObjects] objectsAtIndexes:rowIndexes]) {
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

