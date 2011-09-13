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
    [data release];
    [sprites release];
    [spriteController removeObserver:self forKeyPath:@"selectionIndex"];
    [super dealloc];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [spriteController
     setSortDescriptors:[NSArray
                         arrayWithObject:[NSSortDescriptor
                                          sortDescriptorWithKey:@"key"
                                          ascending:YES
                                          selector:@selector(numericCompare:)]]];
    [spriteController addObserver:self
                       forKeyPath:@"selectionIndex"
                          options:NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
                          context:NULL];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [spriteView bind:@"sprite" toObject:spriteController withKeyPath:@"selection.value" options:nil];
}

- (NSUInteger)spriteId {
    NSUInteger index = [spriteController selectionIndex];
    if (index == NSNotFound) {
        NSLog(@"NOT FOUND");
        return -1;
    }
    return [[[[spriteController arrangedObjects] objectAtIndex:index] key] integerValue];
    
//    NSUInteger id = [[ key] integerValue];
//    NSLog(@"returning %", id);
}

//- (NSUInteger)selectionIndex {
//    [sprites valueForKey:[[NSNumber numberWithUnsignedInteger:[spriteController selectionIndex]] stringValue]];
//    [sprites key
//    return [spriteController selectionIndex];
//}

//- (void)setSelectionIndex:(NSUInteger)selectionIndex {
//    [spriteController setSelectionIndex:selectionIndex];
//}

- (void)setSpriteId:(NSUInteger)spriteId {
    NSArray *objects = [spriteController arrangedObjects];
    NSString *key = [[NSNumber numberWithUnsignedInteger:spriteId] stringValue];
    if (spriteId == -1) {
        //Clear selection
        [spriteController setSelectedObjects:[NSArray array]];
    } else {
//    NSLog(@"setting %@", key);
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
    NSLog(@"type = %@", type);
    SMIVImage *sprite = nil;
    //Load the sprite
    if ([type isEqualToString:@"com.compuserve.gif"]) {
        NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithContentsOfFile:file];
        NSLog(@"FILE: %@", [file lastPathComponent]);
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
        [pair release];
        return YES;
    }
    return NO;
}
@end
