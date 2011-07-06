//
//  ActionViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 7/5/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "ActionViewController.h"
#import "ObjectTypeSelector.h"

@implementation ActionViewController
@dynamic action, baseObjectType;
- (void)awakeFromNib {
    //Protected by nil messaging
    [objectPickerView preformDelayedBinding];
}
- (void)dealloc {
    [action release];
    [super dealloc];
}

- (void)setBaseObjectType:(Index *)baseObjectType {
    [action setValue:baseObjectType forKey:@"baseType"];
}

- (Index *)baseObjectType {
    return [action valueForKey:@"baseType"];
}
@end
