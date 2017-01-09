//
//  UILabel(CornerRadius).m
//  BumBom
//
//  Created by Alexander Shipin on 13/01/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import "UILabel(CornerRadius).h"

@implementation UIView(CornerRadius)

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (UIColor*)borderColor {
    return [UIColor colorWithCGColor: self.layer.borderColor];
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}


- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

@end
