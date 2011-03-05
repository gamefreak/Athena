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
    NSSize size = SMIVRectSize([sprite masterRect]);
    if (direction != 2) {
        [sprite drawAtPoint:NSMakePoint((frame.size.width - size.width)/2.0f, (frame.size.height - size.height)/2.0f)];
    } else {
        NSSize gdim = [sprite gridDistribution];
        int width = gdim.width;
        int height = gdim.height;
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                [sprite drawFrame:x + y * width atPoint:NSMakePoint(x * size.width, y * size.height)];
            }
        }
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
    [self setNeedsDisplay:YES];
}

- (void)setDirection:(NSInteger)_direction {
    direction = _direction;
    [self resetTimer];
    [self setNeedsDisplay:YES];
}

- (void)setSpeed:(CGFloat)_speed {
    speed = _speed;
    [self resetTimer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay:YES];
}

@end
