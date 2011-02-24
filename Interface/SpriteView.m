//
//  SpriteView.m
//  Athena
//
//  Created by Scott McClaugherty on 2/15/11.
//  Copyright 2011 Scott McClaugherty. All rights reserved.
//

#import "SpriteView.h"
#import "SMIVImage.h"

@implementation SpriteView
@dynamic direction, speed;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"sprite" options:NSKeyValueObservingOptionOld context:NULL];
        direction = 0;
        speed = 1.0f;
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"sprite"];
    [timer invalidate];
    [timer release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor blackColor] set];
    NSRectFill(dirtyRect);
    NSRect frame = [self frame];
    NSSize size = [sprite size];
    [sprite drawAtPoint:NSMakePoint((frame.size.width - size.width)/2.0f, (frame.size.height - size.height)/2.0f)];
}

- (void) resetTimer {
    [timer invalidate];
    [timer release];
    timer = nil;
    if (direction != 0) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:1.0f / (speed) target:self selector:@selector(triggerChange:) userInfo:NULL repeats:YES] retain];
    }
}

- (IBAction) triggerChange:(id)sender {
    if (direction == 1) {
        [sprite nextFrame];
    } else {
        [sprite previousFrame];
    }
    [self setNeedsDisplay:YES];
}

- (void)setDirection:(NSInteger)_direction {
    direction = _direction;
    [self resetTimer];
}

- (void)setSpeed:(CGFloat)_speed {
    speed = _speed;
    [self resetTimer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay:YES];
}

@end
