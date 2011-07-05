//
//  ObjectTypeSelector.m
//  Athena
//
//  Created by Scott McClaugherty on 7/4/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ObjectTypeSelector.h"

#import "ObjectEditor.h"
#import "MainData.h"
#import "BaseObject.h"

@implementation ObjectTypeSelector
@dynamic type, index;
@synthesize targetKeyPath;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        const static CGFloat pixelSpacing = 8.0f;
        const static NSUInteger autoResizeMask =  NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin;
        frame = [self frame];
        CGFloat elementHeight = frame.size.height - 2.0f * pixelSpacing;
        CGFloat elementWidth = frame.size.width / 2.0f - 3.0f * pixelSpacing;
        
        displayField = [[NSTextField alloc] initWithFrame:NSMakeRect(pixelSpacing, pixelSpacing, elementWidth, elementHeight)];
//        [displayField setAutoresizingMask:autoResizeMask];
        [displayField setBezeled:NO];
        [displayField setDrawsBackground:NO];
        [displayField setEditable:NO];
        [displayField setStringValue:@"A"];
        [self addSubview:displayField];
        
        openButton = [[NSButton alloc] initWithFrame:NSMakeRect(pixelSpacing * 2.0f + elementWidth, pixelSpacing, elementWidth, elementHeight)];
//        [openButton setAutoresizingMask:autoResizeMask];
        [openButton setBezelStyle:NSRoundRectBezelStyle];
        [openButton setTitle:@"Choose"];
        [openButton setTarget:self];
        [openButton setAction:@selector(openObjectPicker:)];
        [self addSubview:openButton];
    
    }
    
    return self;
}

- (void)dealloc {
    [self unbind:@"index"];
    [openButton release];
    [displayField release];
    [index release];
    [targetKeyPath release];
    [super dealloc];
}


- (void)openObjectPicker:(id)sender {
    MainData *data = [[[self window] document] data];
    ObjectEditor *editor = [[ObjectEditor alloc]
                            initAsPickerWithData:data
                            forDevices:NO];
    [[[self window] document] addWindowController:editor];
    [editor showWindow:sender];
//    [editor setSelection:currentInitial.type];
    [editor setSelection:[[data objects] objectAtIndex:[index index]]];
//    [currentInitial bind:@"type" toObject:editor withKeyPath:@"selection" options:nil];
    [self bind:@"type" toObject:editor withKeyPath:@"selection" options:nil];
//    editor.selectionIndex = currentInitial.type.objectIndex;
    editor.selectionIndex = [index index];

    [editor release];
}

- (void)setType:(BaseObject *)type {
    [self willChangeValueForKey:@"index"];
    [self setIndex:[type indexRef]];
    [self didChangeValueForKey:@"index"];
}

- (BaseObject *)type {
    return [[[[[self window] document] data] objects] objectAtIndex:[index index]];
}

- (void)setIndex:(Index *)_index {
    [self willChangeValueForKey:@"type"];
    [index release];
    index = [_index retain];
    [self didChangeValueForKey:@"type"];
}


@end
