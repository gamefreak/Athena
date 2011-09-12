//
//  SpriteImporterTableView.m
//  Athena
//
//  Created by Scott McClaugherty on 9/12/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SpriteImporterTableView.h"
#import "SMIVImage.h"
#import "SpriteEditor.h"

@implementation SpriteImporterTableView

//- (id)init {
//    self = [super init];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}

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
        NSError *error = nil;
        NSString *type = [[NSWorkspace sharedWorkspace] typeOfFile:file error:&error];
        if (error) {
            [[NSAlert alertWithError:error] runModal];
            return NO;
        }
        NSLog(@"type = %@", type);
        SMIVImage *sprite = nil;
        //Load the sprite
        if ([type isEqualToString:@"com.compuserve.gif"]) {
            NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithContentsOfFile:file];
            NSLog(@"FILE: %@", [file lastPathComponent]);
            sprite = [[[SMIVImage alloc] initWithAnimation:rep
                                                     named:[[file lastPathComponent] stringByDeletingPathExtension]] autorelease];
        }
        if (sprite != nil) {
            //get keys
            NSMutableDictionary *sprites = [self valueForKeyPath:@"window.windowController.document.data.sprites"];
            NSArray *keys = [[sprites allKeys] valueForKeyPath:@"intValue"];
            int firstIndex = [[keys valueForKeyPath:@"@min.intValue"] intValue];
            int lastIndex = [[keys valueForKeyPath:@"@max.intValue"] intValue];
            int found = -1;
            //scan for gaps
            for (int k = firstIndex; k < lastIndex; k++) {
                NSString *tk = [[NSNumber numberWithInt:k] stringValue];
                if ([sprites objectForKey:tk] == nil) {
                    found = k;
                    break;
                }
            }
            NSString *key = nil;
            if (found == -1) {
                found = lastIndex + 1;
            }
            key = [[NSNumber numberWithInt:found] stringValue];
            
            NSAssert([sprites objectForKey:key] == nil, @"sprites table contained unexpected key %@", key);

            NSDictionaryController *controller = [[[self window] windowController] spriteController];
            id pair = [controller newObject];
            [pair setKey:key];
            [pair setValue:sprite];
            [controller addObject:pair];
            NSLog(@"Added key %@", key);
        }
    }
    return NO;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender {
}

@end
