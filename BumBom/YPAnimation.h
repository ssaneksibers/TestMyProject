//
//  YPAnimation.h
//  
//
//  Created by Alexander Shipin on 23/06/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPAnimation : NSObject

@property (nonatomic, strong, readonly) BOOL (^animatoinBlock)(float lastDuration,float allTime);

- (instancetype) initWithAnimationBlock:(BOOL (^)(float lastDuration,float allTime)) animatoinBlock;
- (void) startAnimation;
- (void) stopAnimation;
- (void) pauseAnimation;

@end
