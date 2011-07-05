//
//  ActionViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 7/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ActionViewController.h"


@implementation ActionViewController
@synthesize action;
- (void)dealloc {
    [action release];
    [super dealloc];
}

@end
