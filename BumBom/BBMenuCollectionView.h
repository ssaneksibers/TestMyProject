//
//  BBMenuCollectionView.h
//  BumBom
//
//  Created by Alexander Shipin on 13/01/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMenuCellView: UIView

@property (nonatomic,assign) CGPoint position;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGPoint positionCenter;
@property (nonatomic,assign) CGPoint vector;
@property (nonatomic,strong,readonly) UILabel* label;

@end

@interface BBMenuCollectionViewAction : NSObject

+ (instancetype) actionWithText:(NSString*) text action:(void (^)()) block;

@property (nonatomic,copy) NSString* text;
@property (nonatomic,strong) void (^block)();

@end

@interface BBMenuCollectionView : UIView

@property (nonatomic,strong) NSArray<BBMenuCollectionViewAction*>* actions;
@property (nonatomic,strong) NSArray<UIColor*>* backgroundColors;

- (void) start;
- (void) stop;

@end
