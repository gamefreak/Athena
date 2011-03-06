//
//  WeaponViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 3/6/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "WeaponViewController.h"


@implementation WeaponViewController
@synthesize weaponTitle;

- (void) awakeFromNib {
    [super awakeFromNib];
    [[self view] setFrame:[targetView bounds]];
    [targetView addSubview:[self view]];
}

- (void) dealloc {
    [weaponTitle release];
    [super dealloc];
}
@end
