//
//  SpriteEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 2/14/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SpriteEditor.h"
#import "MainData.h"
#import "SpriteView.h"
#import "SMIVImage.h"

@interface SpriteEditor (Private)
- (void)insertObject:(SMIVImage *)object inSpritesAtIndex:(NSUInteger)index;    
- (void)removeObjectFromSpritesAtIndex:(NSUInteger)index;
@end

@implementation SpriteEditor
@dynamic spriteId;
@synthesize spriteController;

- (id) initWithMainData:(MainData *)_data {
    self = [super initWithWindowNibName:@"SpriteEditor"];
    if (self) {
        data = [_data retain];
        sprites = [[data sprites] retain];
    }
    return self;
}

- (void)dealloc {
    [spriteView unbind:@"sprite"];
    [data release];
    [sprites release];
    [spriteController removeObserver:self forKeyPath:@"selectionIndex"];
    [super dealloc];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [spriteController setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"objectIndex" ascending:YES]]];
    [spriteController addObserver:self
                       forKeyPath:@"selectionIndex"
                          options:NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
                          context:NULL];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [spriteView bind:@"sprite" toObject:spriteController withKeyPath:@"selection.self" options:nil];
}

- (NSUInteger)spriteId {
    NSUInteger index = [spriteController selectionIndex];
    if (index == NSNotFound) {
        return -1;
    }
    return [[[spriteController selection] valueForKey:@"objectIndex"] intValue];
}

- (void)setSpriteId:(NSUInteger)spriteId {
    NSArray *objects = [spriteController arrangedObjects];
    NSString *key = [[NSNumber numberWithUnsignedInteger:spriteId] stringValue];
    if (spriteId == -1) {
        //Clear selection
        [spriteController setSelectedObjects:[NSArray array]];
    } else {
        NSUInteger index = [objects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
            if ([[obj key] isEqualTo:key]) {
                *stop = YES;
                return YES;
            } else {
                return NO;
            }
        }];
        [spriteController setSelectionIndex:index];
    }
}

- (void)insertObject:(SMIVImage *)object inSpritesAtIndex:(NSUInteger)index {
    [[[[self document] undoManager] prepareWithInvocationTarget:self] removeObjectFromSpritesAtIndex:index];
    [sprites insertObject:object atIndex:index];
}

- (void)removeObjectFromSpritesAtIndex:(NSUInteger)index {
    [[[[self document] undoManager] prepareWithInvocationTarget:self] insertObject:[sprites objectAtIndex:index] inSpritesAtIndex:index];
    [sprites removeObjectAtIndex:index];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //Would have separated by prior/not-prior but NSArrayController doesn't send those
    [self willChangeValueForKey:@"spriteId"];
    [self didChangeValueForKey:@"spriteId"];
}

- (BOOL)addSpriteForPath:(NSString *)file {
    NSError *error = nil;
    NSString *type = [[NSWorkspace sharedWorkspace] typeOfFile:file error:&error];
    if (error) {
        [[NSAlert alertWithError:error] runModal];
        return NO;
    }
    SMIVImage *sprite = nil;
    //Load the sprite
    if ([type isEqualToString:@"com.compuserve.gif"]) {
        NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithContentsOfFile:file];
        sprite = [[[SMIVImage alloc] initWithAnimation:rep
                                                 named:[[file lastPathComponent] stringByDeletingPathExtension]] autorelease];
        [self addSprite:sprite];
    } else {
        //Assume spritesheet is provided
        NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithContentsOfFile:file];
        NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:rep, @"rep", [[file lastPathComponent] stringByDeletingPathExtension], @"name", nil];//do not release/autorelease here
        [NSApp beginSheet:dimensionsSheet
           modalForWindow:[self window]
            modalDelegate:self
           didEndSelector:@selector(didEnd:returnCode:context:)
              contextInfo:info];
    }

    return YES;
}

- (IBAction)dimensionsOk:(id)sender {
    [NSApp endSheet:dimensionsSheet returnCode:NSOKButton];
    [dimensionsSheet orderOut:sender];
}

- (IBAction)dimensionsCancel:(id)sender {
    [NSApp endSheet:dimensionsSheet returnCode:NSCancelButton];
    [dimensionsSheet orderOut:sender];
}

- (void)didEnd:(NSWindow *)sheet returnCode:(int)code context:(void *)context {
    NSDictionary *info = (NSDictionary *)context;
    if (code == NSOKButton) {
        SMIVImage *sprite = [[[SMIVImage alloc] initWithSpriteSheet:[info objectForKey:@"rep"]
                                                              named:[info objectForKey:@"name"]
                                                          cellsWide:[widthInput intValue]
                                                               tall:[heightInput intValue]] autorelease];
        [self addSprite:sprite];
    }
    [info release];
}

- (BOOL)addSprite:(SMIVImage *)sprite {
    if (sprite != nil) {
        //get keys
        NSArray *IDs = [sprites valueForKeyPath:@"objectIndex"];
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

        NSAssert(![IDs containsObject:ID], @"sprites table contained unexpected ID %@", ID);
        [sprite setObjectIndex:[ID integerValue]];
        [spriteController addObject:sprite];
        return YES;
    }
    return NO;
}

- (IBAction)openSprite:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSImage imageTypes]];
    [openPanel setAllowsOtherFileTypes:NO];
    [openPanel setAllowsMultipleSelection:NO];
    assert([openPanel canChooseFiles]);
    assert(![openPanel canChooseDirectories]);
    
    [openPanel retain];
    [openPanel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            [self addSpriteForPath:[[[openPanel URLs] objectAtIndex:0] path]];
        }
        [openPanel autorelease];
    }];
}

- (IBAction)exportSprite:(id)sender {
    NSUInteger index = [spriteController selectionIndex];
    if (index == NSNotFound) {
        return;
    }
    BOOL exportPNG = [sender tag];
    SMIVImage *sprite = [[[spriteController arrangedObjects] objectAtIndex:index] retain];
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"png", @"gif", nil]];
    [savePanel setNameFieldStringValue:[[sprite title] stringByAppendingPathExtension:(exportPNG?@"png":@"gif")]];
    [savePanel setCanSelectHiddenExtension:YES];
    [savePanel retain];
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSString *extension = [[savePanel URL] pathExtension];
            NSData *spriteData = nil;
            if ([extension isCaseInsensitiveLike:@"png"]) {
                spriteData = [sprite PNGData];
            } else if ([extension isCaseInsensitiveLike:@"gif"]){
                spriteData = [sprite GIFData];
            } else {
                NSRunAlertPanel(@"Attempt to save in incompatible format.", @"Athena currently only supports saving sprites in PNG or GIF formats.", nil, nil, nil);
            }
            
            BOOL ok = [spriteData writeToURL:[savePanel URL] atomically:YES];
            if (!ok && spriteData != nil) {
                NSRunAlertPanel(@"Unable to export sprite.", @"Athena was unable to export the sprite.", nil, nil, nil);
            }
        }
        [sprite release];
        [savePanel autorelease];
    }];
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:[NSArray arrayWithObjects:NSFileContentsPboardType, NSFilesPromisePboardType, nil] owner:self];
    
    NSMutableArray *fileNames = [NSMutableArray array];
    for (SMIVImage *sprite in [[spriteController arrangedObjects] objectsAtIndexes:rowIndexes]) {
        NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:[sprite PNGData]];
        NSString *filename = [[sprite title] stringByAppendingPathExtension:@"png"];
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
@end

@implementation SpriteImporterTableView
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
        return [[[self window] windowController] addSpriteForPath:file];
    }
    return NO;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender {
}
@end
