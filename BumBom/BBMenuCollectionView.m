//
//  BBMenuCollectionView.m
//  BumBom
//
//  Created by Alexander Shipin on 13/01/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import "BBMenuCollectionView.h"
#import "BBBombManager.h"
#import "UIView(HRConstraint).h"
#import "YPAnimation.h"

@implementation BBMenuCollectionViewAction

+ (instancetype)actionWithText:(NSString *)text action:(void (^)())block  {
    BBMenuCollectionViewAction* result = [self new];
    result.block = block;
    result.text = text;
    return result;
}

@end

@interface BBMenuCellView ()

@property (nonatomic,assign) BBMenuCollectionViewAction* action;
@property (nonatomic,assign) CGFloat Vradius;

@end

@implementation BBMenuCellView{
    UILabel* _label;
}

- (UILabel *)label {
    if (!_label){
        _label = [UILabel new];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        NSArray* constraint = @[[NSLayoutConstraint constraintWithItem:self
                                                             attribute:(NSLayoutAttributeCenterX)
                                                             relatedBy:(NSLayoutRelationEqual)
                                                                toItem:_label
                                                             attribute:(NSLayoutAttributeCenterX)
                                                            multiplier:1.
                                                              constant:0.],
                                [NSLayoutConstraint constraintWithItem:self
                                                             attribute:(NSLayoutAttributeCenterY)
                                                             relatedBy:(NSLayoutRelationEqual)
                                                                toItem:_label
                                                             attribute:(NSLayoutAttributeCenterY)
                                                            multiplier:1.
                                                              constant:0.],
                                [NSLayoutConstraint constraintWithItem:_label
                                                             attribute:(NSLayoutAttributeWidth)
                                                             relatedBy:(NSLayoutRelationEqual)
                                                                toItem:nil
                                                             attribute:(NSLayoutAttributeNotAnAttribute)
                                                            multiplier:1.
                                                              constant:self.radius],
                                [NSLayoutConstraint constraintWithItem:_label
                                                             attribute:(NSLayoutAttributeHeight)
                                                             relatedBy:(NSLayoutRelationEqual)
                                                                toItem:nil
                                                             attribute:(NSLayoutAttributeNotAnAttribute)
                                                            multiplier:1.
                                                              constant:self.radius ]];
        [self addConstraints:constraint];
    }
    return _label;
}


- (void)setAction:(BBMenuCollectionViewAction *)action {
    _action = action;
    self.label.text = action.text;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(actionTapGesture:)]];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void) actionTapGesture:(UITapGestureRecognizer*) tap{
    if (self.action.block){
        self.action.block();
    }
}

- (void) setPosition:(CGPoint)position {
    _position = position;
    if (self.radius) {
        self.frame = CGRectMake(self.position.x - self.radius,
                                self.position.y - self.radius,
                                self.radius * 2.,
                                self.radius * 2.);
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.layer.cornerRadius = self.radius;
    self.frame = CGRectMake(self.position.x - self.radius,
                            self.position.y - self.radius,
                            self.radius * 2.,
                            self.radius * 2.);
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end

@interface BBMenuCollectionView()<UIScrollViewDelegate>

@property (nonatomic,assign) IBInspectable CGFloat buttonRadius;
@property (nonatomic,assign) IBInspectable CGFloat buttonRadiusDelta;
@property (nonatomic,assign) IBInspectable CGFloat allRadius;
@property (nonatomic,assign) IBInspectable CGFloat allRadiusDelta;
@property (nonatomic,assign) IBInspectable CGFloat marginWidth;
@property (nonatomic,assign) IBInspectable BOOL isVertical;
@property (nonatomic,strong) IBInspectable UIColor* buttonBackgroundColor;
@property (nonatomic,strong) IBInspectable UIColor* buttonTextColor;
@property (nonatomic,assign) IBInspectable NSInteger numberOfBombs;


@property (nonatomic,strong) UIScrollView* forgroundScrollView;
@property (nonatomic,strong) UIScrollView* bacgroundScrollView;
@property (nonatomic,strong) NSArray<BBMenuCellView*>* menuCells;
@property (nonatomic,strong) BBBombManager* bombManager;
@property (nonatomic,strong) NSArray<BBMenuCellView*>* bombs;

@property (nonatomic,assign) CGFloat time;
@property (nonatomic,assign) NSInteger numberFrams;
@property (nonatomic,strong) YPAnimation* animation;

@end

@implementation BBMenuCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bacgroundScrollView = [UIScrollView new];
    self.bacgroundScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.bacgroundScrollView];
    self.bacgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.bacgroundScrollView.showsVerticalScrollIndicator = NO;
    self.bacgroundScrollView.scrollEnabled = NO;
    self.bacgroundScrollView.clipsToBounds = NO;
    
    self.forgroundScrollView = [UIScrollView new];
    self.forgroundScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.forgroundScrollView];
    self.forgroundScrollView.delegate = self;
    self.forgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.forgroundScrollView.showsVerticalScrollIndicator = NO;
    
    self.bacgroundScrollView.backgroundColor = [UIColor clearColor];
    self.forgroundScrollView.backgroundColor = [UIColor clearColor];
    
    [self hrAddMarginConstraintSubview:self.forgroundScrollView];
    [self hrAddMarginConstraintSubview:self.bacgroundScrollView
                                   top:50
                                bottom:0
                                 right:0
                                  left:0];
}

- (NSArray<UIColor*> *)backgroundColors {
    if (!_backgroundColors) {
        _backgroundColors = @[[UIColor blackColor]];
    }
    return _backgroundColors;
}

- (void)setActions:(NSArray<BBMenuCollectionViewAction *> *)actions {
    _actions = actions;
    [self reloadData];
}
#pragma mark - scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.bacgroundScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x * 0.5,
                                                         scrollView.contentOffset.y / scrollView.contentSize.height * [UIScreen mainScreen].bounds.size.height);
}

#pragma mark - update

- (void) reloadData{
    for (BBMenuCollectionView* view in self.menuCells) {
        [view removeFromSuperview];
    }
    NSMutableArray* list = [NSMutableArray new];
    CGFloat m = self.marginWidth + self.buttonRadiusDelta + self.buttonRadius;
    CGPoint lastPoint = CGPointMake(m,
                                    m);
    
    
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (self.isVertical) {
        height = [UIScreen mainScreen].bounds.size.width;
    }
    CGFloat shift = sqrt(m * m * 4 - (height - m * 2) * (height - m * 2));
    if (m * 2 < (height - m)) {
        shift = m ;
    }
    
    CGFloat max = shift * self.actions.count;
    for (int i = 0; i < self.numberOfBombs ; i++) {
        BBMenuCellView* cell = [BBMenuCellView new];
        [list addObject:cell];
        [self.bacgroundScrollView addSubview:cell];
        
        CGFloat k = (CGFloat)(rand() % 10000) / 10000. - 0.5;
        cell.radius = self.allRadius + self.allRadiusDelta * k;
        k = (CGFloat)(rand() % 10000) / 20000.;
        cell.backgroundColor = [self.backgroundColors[rand() % self.backgroundColors.count] colorWithAlphaComponent:k];
    }
    self.bombs = [list copy];
    if (self.isVertical) {
        self.bombManager = [[BBBombManager alloc] initWithArea:CGPointMake([UIScreen mainScreen].bounds.size.width,
                                                                           [UIScreen mainScreen].bounds.size.height * 2. )];
    } else {
        self.bombManager = [[BBBombManager alloc] initWithArea:CGPointMake([UIScreen mainScreen].bounds.size.width * 2.,
                                                                           [UIScreen mainScreen].bounds.size.height)];
    }
    self.bacgroundScrollView.contentSize = CGSizeMake(self.bombManager.area.x,
                                                      self.bombManager.area.y);
    self.bombManager.maxRadius = 10;
    self.bombManager.minRadius = 10;
    self.bombManager.deltaVel = 0.2;
    [self.bombManager reloadWithNumberBombs:self.numberOfBombs];
    
    
    for (int i = 0; i < self.actions.count; i++) {
        BBMenuCellView* cell = [BBMenuCellView new];
        [list addObject:cell];
        [self.forgroundScrollView addSubview:cell];
        
        CGFloat k = (CGFloat)(rand() % 10000) / 10000. - 0.5;
        cell.radius = self.buttonRadius + self.buttonRadiusDelta * k;
        cell.position = lastPoint;
        cell.positionCenter = lastPoint;
        cell.action = self.actions[i];
        cell.backgroundColor = self.buttonBackgroundColor;
        cell.label.textColor = self.buttonTextColor;
        if (self.isVertical) {
            if (i % 2 == 0) {
                lastPoint.x = height - m;
            } else {
                lastPoint.x = m;
            }
            
            lastPoint.y += shift;
            
        } else {
            if (i % 2 == 0) {
                lastPoint.y = height - m;
            } else {
                lastPoint.y = m;
            }
        
            lastPoint.x += shift;
        }
    }
    self.menuCells = list;
    if (self.isVertical) {
        self.forgroundScrollView.contentSize = CGSizeMake(height, lastPoint.y - m);
    } else {
        self.forgroundScrollView.contentSize = CGSizeMake(lastPoint.x - m, height);
    }
    [self start];
}


- (void) updateWithDuration:(float) duration {
    [self.bombManager nextStepWithTime:duration];
    
    CGFloat max = self.allRadius + self.allRadiusDelta;
    
    CGFloat startY1 = self.bacgroundScrollView.contentOffset.y - max;
    CGFloat endY1 = self.bacgroundScrollView.contentOffset.y + self.frame.size.height + max;
    
    
    NSInteger visable = 0;
    for (int i = 0; i < self.numberOfBombs; i++) {
        BBBomb* bomb = [self.bombManager bombsAtIndex:i];
        CGPoint point = bomb->position;
        BBMenuCellView* cell = self.bombs[i];
        
        if (point.y > startY1 && point.y < endY1) {
            cell.hidden = NO;
            cell.position = point;
            visable ++;
        } else {
            cell.hidden = YES;
        }
    }
    
}

- (void) start {
    __weak typeof(self) weakSelf = self;
    self.numberFrams = 0;
    self.time = 0;
    self.animation = [[YPAnimation alloc] initWithAnimationBlock:^BOOL(float lastDuration, float allTime) {
        weakSelf.time += lastDuration;
        weakSelf.numberFrams ++;
        if (weakSelf.time > 2.) {
            NSLog(@"fps = %f",1. / (weakSelf.time / (float)weakSelf.numberFrams));
            weakSelf.numberFrams = 0;
            weakSelf.time = 0;
        }
        [weakSelf updateWithDuration:lastDuration];
        return YES;
    }];
    [self.animation startAnimation];
}

- (void) stop {
    [self.animation stopAnimation];
}

@end
