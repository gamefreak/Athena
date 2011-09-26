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

@end
