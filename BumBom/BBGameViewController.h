//
//  ViewController.h
//  BumBom
//
//  Created by Alexander Shipin on 29/12/15.
//  Copyright © 2015 Alexander Shipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBLevelManger;

@interface BBGameViewController : UIViewController

@property (nonatomic,strong) BBLevelManger* levelManager;

@end

