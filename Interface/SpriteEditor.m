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
    [super dealloc];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [spriteView bind:@"sprite" toObject:spriteController withKeyPath:@"selection.value" options:nil];
}


@end
