//
//  YPAnimation.m
//  
//
//  Created by Alexander Shipin on 23/06/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPAnimation.h"

@interface YPAnimation()

@property (nonatomic, strong) CADisplayLink* displayLink;
@property (nonatomic, assign) float timeStamp;
@property (nonatomic, assign) float startTime;

@property (nonatomic, assign) float timeLastPause;
@property (nonatomic, assign) float pauseDuration;
@property (nonatomic, assign) BOOL pause;

@end

@implementation YPAnimation

- (instancetype) initWithAnimationBlock:(BOOL (^)(float lastDuration,float allTime)) animatoinBlock{
    self = [super init];
    if (self) {
        _animatoinBlock = animatoinBlock;
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        _displayLink = displayLink;
    }
    return self;
}

- (void)dealloc {
    [self stopAnimation];
}

- (void)startAnimation {
    if (!self.pause) {
        self.startTime = CACurrentMediaTime();
        self.timeStamp = self.startTime;
        self.pauseDuration = 0;
    } else {
        self.pauseDuration += CACurrentMediaTime() - self.timeLastPause;
    }
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
}

- (void) pauseAnimation{
    [self.displayLink invalidate];
    self.timeLastPause = CACurrentMediaTime();
    self.pause = YES;
}

- (void)stopAnimation{
    [self.displayLink invalidate];
    self.pause = NO;
}

- (void) update{
    float time = CACurrentMediaTime() - self.pauseDuration;
    float frameTime =  time - self.timeStamp;
    self.timeStamp = time;
    if (self.animatoinBlock) {
        if (!self.animatoinBlock(frameTime,time - self.startTime)){
            [self stopAnimation];
        }
    }
}

@end
