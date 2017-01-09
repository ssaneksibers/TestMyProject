//
//  YPProgressAnimation.h
//  
//
//  Created by Alexander Shipin on 23/06/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPProgressAnimation : NSObject

@property (nonatomic, strong, readonly) void (^animatoinBlock)(float lastDuration,float progress);
@property (nonatomic, strong, readonly) void (^completionAnimation)(BOOL successful);
@property (nonatomic, assign) float time;
@property (nonatomic, assign, readonly) BOOL replay;
@property (nonatomic, assign, readonly) BOOL isAnimation;
@property (nonatomic, assign, readonly) float currentProgress;

- (instancetype) initWithTime:(float) time
                       replay:(float) replay
               animationBlock:(void (^)(float lastDuration,float progress)) animatoinBlock
          completionAnimation:(void (^)(BOOL successful)) completionAnimation;

- (void) startAnimation;
- (void) stopAnimation;
- (void) pauseAnimation;
- (void) finishAnimation;


@end
