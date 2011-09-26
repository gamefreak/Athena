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

- (void)dealloc {
    [sounds retain];
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (BOOL)addSoundForPath:(NSString *)file {
    NSError *error = nil;
    NSString *type = [[NSWorkspace sharedWorkspace] typeOfFile:file error:&error];
    if (error) {
        [[NSAlert alertWithError:error] runModal];
        return NO;
    }
    NSLog(@"type = %@", type);
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
        NSArray *keys = [[sounds allKeys] valueForKeyPath:@"intValue"];
        int firstIndex = [[keys valueForKeyPath:@"@min.intValue"] intValue];
        int lastIndex = [[keys valueForKeyPath:@"@max.intValue"] intValue];
        int found = -1;
        //scan for gaps
        for (int k = firstIndex; k < lastIndex; k++) {
            NSString *tk = [[NSNumber numberWithInt:k] stringValue];
            if ([sounds objectForKey:tk] == nil) {
                found = k;
                break;
            }
        }
        NSString *key = nil;
        if (found == -1) {
            found = lastIndex + 1;
        }
        key = [[NSNumber numberWithInt:found] stringValue];
        
        NSAssert([sounds objectForKey:key] == nil, @"sounds table contained unexpected key %@", key);
        
        id pair = [soundsController newObject];
        [pair setKey:key];
        [pair setValue:sound];
        [soundsController addObject:pair];
        [pair release];
        return YES;
    }
    return NO;
}
@end


@implementation SoundImporterTableView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
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
