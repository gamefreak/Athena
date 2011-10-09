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
        return -1;
    }
    return [[[spriteController selection] valueForKey:@"key"] intValue];
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
        NSArray *keys = [sprites valueForKeyPath:@"key"];
        int firstIndex = [[keys valueForKeyPath:@"@min.intValue"] intValue];
        int lastIndex = [[keys valueForKeyPath:@"@max.intValue"] intValue];
        int found = -1;
        //scan for gaps
        for (int k = firstIndex; k < lastIndex; k++) {
            NSString *tk = [[NSNumber numberWithInt:k] stringValue];
            if (![sprites containsObject:tk]) {
                found = k;
                break;
            }
        }
        NSString *key = nil;
        if (found == -1) {
            found = lastIndex + 1;
        }
        key = [[NSNumber numberWithInt:found] stringValue];

        NSAssert(![sprites containsObject:key], @"sprites table contained unexpected key %@", key);

        id pair = [spriteController newObject];
        [pair setKey:key];
        [pair setValue:sprite];
        [spriteController addObject:pair];
        [pair release];
        return YES;
    }
    return NO;
}
@end
