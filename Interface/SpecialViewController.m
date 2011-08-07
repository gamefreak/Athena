//
//  SpecialViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 8/2/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SpecialViewController.h"

@implementation SpecialViewController
@synthesize frame;

- (void)dealloc {
    [frame release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)specialParametersChanged:(NSNotification *)note {
    
}
@end
