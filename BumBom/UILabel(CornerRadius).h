//
//  UILabel(CornerRadius).h
//  BumBom
//
//  Created by Alexander Shipin on 13/01/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(CornerRadius)

@property (nonatomic,strong) IBInspectable UIColor* borderColor;
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;

@end
