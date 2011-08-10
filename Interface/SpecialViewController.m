//
//  SpecialViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 8/2/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SpecialViewController.h"

@implementation SpecialViewController
@dynamic frame;

- (void)dealloc {
    [frame release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setFrame:(FrameData *)frame_ {
    [frame removeObserver:self];
    [frame release];
    frame = frame_;
    [frame retain];
    [frame addObserver:self];
}

- (FrameData *)frame {
    return frame;
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value {
    [object setValue:value forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    NSUndoManager *undo = [[[[[self view] window] windowController] document] undoManager];
    id old = [change objectForKey:NSKeyValueChangeOldKey];
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                  ofObject:object
                                                   toValue:old];
}
@end
