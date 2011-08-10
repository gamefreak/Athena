//
//  SpecialViewController.m
//  Athena
//
//  Created by Scott McClaugherty on 8/2/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SpecialViewController.h"
#import "SpriteView.h"
#import "BaseObject.h"
#import "MainData.h"

@implementation SpecialViewController
@dynamic object;
@dynamic frame;

- (void)dealloc {
    [object release];
    [frame release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (spriteView != nil) {
        //Animate forward
        [spriteView setDirection:1];
    }
}

- (void)setObject:(BaseObject *)object_ {
    [object release];
    object = object_;
    [object retain];
    [self setFrame:[object valueForKey:@"frame"]];

    if (spriteView != nil) {
        [self updateViewSprite];
    }
}

- (BaseObject *)object {
    return object;
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

- (void) updateViewSprite {
    NSDictionary *sprites = [[[[[[self view] window] windowController] document] data] sprites];
    NSString *spriteKey = [[object valueForKey:@"spriteId"] stringValue];
    SMIVImage *sprite = [sprites valueForKey:spriteKey];
    [spriteView setSprite:sprite];
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value {
    [object setValue:value forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (spriteView != nil && [keyPath isEqualToString:@"spriteId"] ) {
        [self updateViewSprite];
    }
    NSUndoManager *undo = [[[[[self view] window] windowController] document] undoManager];
    id old = [change objectForKey:NSKeyValueChangeOldKey];
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                  ofObject:object
                                                   toValue:old];
}
@end
