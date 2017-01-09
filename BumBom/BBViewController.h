//
//  BBViewController.h
//  BumBom
//
//  Created by Alexander Shipin on 13/01/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRKeyDefine.h"

HRIntefaceKey(kBBNavigationViewController);

@class BBViewController;

@interface  UIViewController(BBViewController)

- (BBViewController*) bbNavigationViewController;

@end


@interface BBViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray<UIViewController*>* viewControllers;

- (void) start;

- (void) stopWithAnimation:(BOOL) isAnimation;
- (void) stop;

- (void) pushViewController:(UIViewController*) viewController;
- (void) popViewController;

- (void) pushViewController:(UIViewController*) viewController
                  animation:(BOOL) isAnimation;
- (void) popViewControllerAnimation:(BOOL) isAnimation;

@end
