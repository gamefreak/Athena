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
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
