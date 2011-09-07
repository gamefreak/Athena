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

@implementation SpriteEditor
@dynamic spriteId;

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

@end
