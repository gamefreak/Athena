//
//  TextEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 2/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "TextEditor.h"


@implementation TextEditor
- (id) initWithTitle:(NSString *)_title text:(NSString *)_text {
    self = [super initWithWindowNibName:@"TextEditor"];
    if (self) {
        title = _title;
        [title retain];
        text = _text;
        [text retain];
    }
    return self;
}

- (void) dealloc {
    [title release];
    [text release];
    [super dealloc];
}
@end
