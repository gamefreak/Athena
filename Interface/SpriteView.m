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
@dynamic sprite, direction, speed, frameRange, angularVelocity;

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
    NSSize size = [sprite masterSize];
    if (direction != 2) {
        [sprite drawAtPoint:NSMakePoint(frame.size.width/2.0f, frame.size.height/2.0f)];
    } else {
        NSSize grid = [sprite gridDistribution];
        [sprite drawSpriteSheetAtPoint:NSMakePoint(
        (frame.size.width  - size.width  * grid.width )/2.0f,
        (frame.size.height - size.height * grid.height)/2.0f)];
    }

}

- (void) resetTimer {
    [timer invalidate];
    [timer release];
    timer = nil;
    if (direction == 1 || direction == -1) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:1.0f / (speed) target:self selector:@selector(triggerChange:) userInfo:NULL repeats:YES] retain];
    }
}

- (IBAction) triggerChange:(id)sender {
    if (direction == 1) {
        [sprite nextFrame];
    } else if (direction == -1) {
        [sprite previousFrame];
    }
    if (!NSLocationInRange([sprite frame], frameRange)) {
        if ([sprite frame] < frameRange.location) {
            [sprite setFrame:NSMaxRange(frameRange)];
        } else {
            [sprite setFrame:frameRange.location];
        }
    }
    [self setNeedsDisplay:YES];
}

- (void)setSprite:(SMIVImage *)sprite_ {
    [sprite release];
    sprite = sprite_;
    [sprite retain];
    [self setFrameRange:NSMakeRange(0, [sprite count])]; 
}

- (SMIVImage *)sprite {
    return sprite;
}

- (void)setDirection:(NSInteger)_direction {
    direction = _direction;
    [self resetTimer];
    [self setNeedsDisplay:YES];
}

- (NSInteger)direction {
    return direction;
}

- (void)setSpeed:(CGFloat)_speed {
    speed = _speed;
    [self resetTimer];
}

- (CGFloat)speed {
    return speed;
}

- (void)setAngularVelocity:(CGFloat)angularVelocity {
    [self setSpeed:angularVelocity * [sprite count] / (2.0f  * M_PI)];
}

- (CGFloat)angularVelocity {
    //circle/slices * slices / second = circles/second
    return 2.0f * M_PI / [sprite count] * speed;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay:YES];
}

- (void)setFrameRange:(NSRange)frameRange_ {
    frameRange = frameRange_;
}

- (NSRange)frameRange {
    return frameRange;
}

- (void)mouseUp:(NSEvent *)event {
    if (direction == 1) {
        [self setDirection:-1];
    } else if (direction == -1) {
        [self setDirection:1];
    }
}

@end
