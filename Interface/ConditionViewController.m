//
//  ConditionViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 8/24/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ConditionViewController.h"

@implementation ConditionViewController
@synthesize conditionObj;
- (void)dealloc {
    [conditionObj release];
    [super dealloc];
}
@end
