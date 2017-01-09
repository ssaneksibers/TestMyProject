//
//  ViewController.h
//  BumBom
//
//  Created by Alexander Shipin on 29/12/15.
//  Copyright © 2015 Alexander Shipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBLevelManger;
@class BBGameViewController;

@protocol BBGameViewControllerDelegate <NSObject>

- (void) viewController:(BBGameViewController*) viewController selectLevel:(NSInteger) selectLevel;

@end

@interface BBGameViewController : UIViewController

@property (nonatomic,strong) BBLevelManger* levelManager;
@property (nonatomic,weak) id<BBGameViewControllerDelegate> delegate;

@end

