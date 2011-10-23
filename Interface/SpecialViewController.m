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
#import "AthenaDocument.h"
#import "SpriteEditor.h"

@implementation SpecialViewController
@dynamic object;
@dynamic frame;
@dynamic spriteName;
@dynamic spriteId;

- (void)dealloc {
    [object release];
    [frame removeObserver:self];//NOTE: do not confuse with removeObserver:forKeyPath:
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

//relay to fix picker
- (NSInteger)spriteId {
    return [[object valueForKey:@"spriteId"] integerValue];
}

- (void)setSpriteId:(NSInteger)spriteId {
    [object setValue:[NSNumber numberWithInteger:spriteId] forKey:@"spriteId"];
    [self updateViewSprite];
}

+ (NSSet *)keyPathsForValuesAffectingSpriteId {
    return [NSSet setWithObjects:@"object", @"object.spriteId", nil];
}

- (NSString *)spriteName {
    return [[self spriteForObject:object] title];
}

+ (NSSet *)keyPathsForValuesAffectingSpriteName {
    return [NSSet setWithObjects:@"object", @"object.spriteId", @"spriteId", nil];
}

- (void) updateViewSprite {
    SMIVImage *sprite = [self spriteForObject:object];
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
        range.length = [anim lastShape] - range.location;
        [spriteView setFrameRange:range];
    }
}

- (void)loadFix {
    //Fix missing sprite
    [self updateViewSprite];
    //Fix missing sprite name
    [self willChangeValueForKey:@"spriteName"];
    [self didChangeValueForKey:@"spriteName"];
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)object_ toValue:(id)value {
    [object_ setValue:value forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object_
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
            frameRange.length = [[change valueForKey:NSKeyValueChangeNewKey] integerValue] - frameRange.location;
        } else if ([keyPath isEqualToString:@"speed"]) {
            int speed = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
            [spriteView setSpeed:speed];
        }
    }
    NSUndoManager *undo = [[[[[self view] window] windowController] document] undoManager];
    id old = [change objectForKey:NSKeyValueChangeOldKey];
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                  ofObject:object_
                                                   toValue:old];
}

- (SMIVImage *)spriteForObject:(BaseObject *)object_ {
    NSArray *sprites = [(MainData *)[[[[[self view] window] windowController] document] data] sprites];
    NSUInteger spriteId = [[object_ valueForKey:@"spriteId"] unsignedIntegerValue];
//    return [sprites firstObjectPassingTest:^(id obj, NSUInteger idx) {
//        return (BOOL)([obj objectIndex] == spriteId);
//    }];
//    NSString *spriteKey = [[object_ valueForKey:@"spriteId"] stringValue];
    NSUInteger index = [sprites indexOfObjectWithOptions:NSEnumerationConcurrent
                                             passingTest:^(id obj, NSUInteger idx, BOOL *stop){
                                                 return *stop = [obj objectIndex] == spriteId;
                                             }];
    if (index != NSNotFound) {
        return (SMIVImage *)[sprites objectAtIndex:index];
    }
    return nil;
}

- (IBAction)openSpritePicker:(id)sender {
    AthenaDocument *doc = [[[[self view] window] windowController] document];
    SpriteEditor *editor = [[SpriteEditor alloc] initWithMainData:[doc data]];
    [doc addWindowController:editor];
    [editor showWindow:sender];
    [editor setSpriteId:[[object valueForKey:@"spriteId"] integerValue]];
    [self bind:@"spriteId" toObject:editor withKeyPath:@"spriteId" options:nil];
    [editor autorelease];
    
}

@end
