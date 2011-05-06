//
//  ActionEditor.m
//  Athena
//
//  Created by Scott McClaugherty on 5/3/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ActionEditor.h"


@implementation ActionEditor
@synthesize actions;

- (void) dealloc {
    [super dealloc];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [[self view] setFrame:[targetView bounds]];
    [targetView addSubview:[self view]];
}

@end
