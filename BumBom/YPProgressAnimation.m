//
//  YPProgressAnimation.m
//  
//
//  Created by Alexander Shipin on 23/06/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import "YPProgressAnimation.h"
#import "YPAnimation.h"

@interface  YPProgressAnimation()

@property (nonatomic, strong) YPAnimation* animation;
@property (nonatomic, assign, readwrite) BOOL isAnimation;
@property (nonatomic, assign, readwrite) float currentProgress;
@property (nonatomic, strong) void (^animatoinBlock)(float lastDuration, float allTime);

@end

@implementation YPProgressAnimation

- (instancetype) initWithTime:(float) time
                       replay:(float) replay
               animationBlock:(void (^)(float lastDuration,float progress)) animatoinBlock
          completionAnimation:(void (^)(BOOL))completionAnimation{
    self = [super init];
    if (self) {
        _time = time;
        _animatoinBlock = animatoinBlock;
        _replay = replay;
        _animatoinBlock = animatoinBlock;
        _completionAnimation = completionAnimation;
        __weak typeof(self) weakSelf = self;
        _animation = [[YPAnimation alloc] initWithAnimationBlock:^BOOL(float lastDuration, float allTime) {
            float progress = allTime / weakSelf.time;
            [weakSelf animationWithProgress:progress lastDuration:lastDuration];
            return !!weakSelf;
        }];
    }
    return self;
}

- (void) animationWithProgress:(float) progress lastDuration:(float) lastDuration {
    self.currentProgress = progress;
    self.animatoinBlock(lastDuration,progress);
    if (progress > 1) {
        if (self.replay) {
            [self.animation stopAnimation];
            [self startAnimation];
        } else {
            self.isAnimation = NO;
            if (self.completionAnimation) {
                self.completionAnimation(YES);
            }
            [self.animation stopAnimation];
        }
    }
}

- (void) pauseAnimation{
    self.isAnimation = NO;
    [self.animation pauseAnimation];
}

- (void) startAnimation{
    self.isAnimation = YES;
    [self.animation startAnimation];
}

- (void) stopAnimation{
    if (self.isAnimation) {
        self.isAnimation = NO;
        [self.animation stopAnimation];
        self.completionAnimation(NO);
    }
}

- (void)finishAnimation {
    if (self.isAnimation) {
        self.isAnimation = NO;
        self.animatoinBlock(1,0);
        if (self.completionAnimation) {
            self.completionAnimation(YES);
        }
        [self.animation stopAnimation];
    }
}


@end
