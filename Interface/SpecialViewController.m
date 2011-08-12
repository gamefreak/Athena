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
    if ([frame isKindOfClass:[RotationData class]]) {
        [spriteView setAngularVelocity:2.0f * [[frame valueForKey:@"turnRate"] floatValue]];
        NSRange frameRange;
        frameRange.location = [[frame valueForKey:@"offset"] integerValue];
        frameRange.length = 360 / [[frame valueForKey:@"resolution"] integerValue];
        [spriteView setFrameRange:frameRange];
    } else if ([frame isKindOfClass:[AnimationData class]]) {
        AnimationData *anim = (AnimationData *)frame;
        [spriteView setSpeed:[anim speed]];
        
        NSRange range;
        range.location = [anim firstShape];
        range.length = [anim lastShape]- range.location;
        [spriteView setFrameRange:range];
    }
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value {
    [object setValue:value forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (spriteView != nil) {
        if([keyPath isEqualToString:@"spriteId"]) {
            [self updateViewSprite];
        } else if ([keyPath isEqualToString:@"turnRate"]) {
            [spriteView setAngularVelocity:2.0f * [[change valueForKey:NSKeyValueChangeNewKey] floatValue]];
        } else if ([keyPath isEqualToString:@"offset"]) {
            NSRange frameRange = [spriteView frameRange];
            frameRange.location = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
            [spriteView setFrameRange:frameRange];
        } else if ([keyPath isEqualToString:@"resolution"]) {
            NSRange frameRange = [spriteView frameRange];
            frameRange.length = 360 / [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
            [spriteView setFrameRange:frameRange];
        } else if ([keyPath isEqualToString:@"firstShape"]) {
            NSRange frameRange = [spriteView frameRange];
            int right = frameRange.location + frameRange.length;
            frameRange.location = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
            frameRange.length = right - frameRange.location;
        } else if ([keyPath isEqualToString:@"lastShape"]) {
            NSRange frameRange = [spriteView frameRange];
            int right = frameRange.location + frameRange.length;
            frameRange.length = [[change valueForKey:NSKeyValueChangeNewKey] integerValue] - frameRange.location;
        } else if ([keyPath isEqualToString:@"speed"]) {
            int speed = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
            [spriteView setSpeed:speed];
        }
    }
    NSUndoManager *undo = [[[[[self view] window] windowController] document] undoManager];
    id old = [change objectForKey:NSKeyValueChangeOldKey];
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                  ofObject:object
                                                   toValue:old];
}
@end
