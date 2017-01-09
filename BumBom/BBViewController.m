//
//  BBViewController.m
//  BumBom
//
//  Created by Alexander Shipin on 13/01/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import "BBViewController.h"
#import "BBBombManager.h"
#import "BBMenuCollectionView.h"
#import "UIView(HRConstraint).h"

HRImplementationKey(kBBNavigationViewController);

@implementation UIViewController(BBViewController)

- (BBViewController *)bbNavigationViewController {
    UIViewController* vc = self;
    while (vc && ![vc isKindOfClass:[BBViewController class]]) {
        vc = self.parentViewController;
    }
    return (id)vc;
}

@end

@interface BBViewController ()<UIScrollViewDelegate>

@property (nonatomic,assign) IBInspectable NSInteger numberOfBombs;
@property (nonatomic,assign) IBInspectable CGFloat allRadius;
@property (nonatomic,assign) IBInspectable CGFloat allRadiusDelta;
@property (nonatomic,strong) UIScrollView* bacgroundScrollView;
@property (nonatomic,strong) UIScrollView* forgroundScrollView;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,strong) BBBombManager* bombManager;
@property (nonatomic,strong) NSArray<BBMenuCellView*>* backgroundViews;

@property (nonatomic,strong) NSLayoutConstraint* rightConstraint;
@property (nonatomic,assign) CGPoint startPoint;

@end

@implementation BBViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewControllers = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewControllers = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllers = [NSMutableArray new];
    self.bacgroundScrollView = [UIScrollView new];
    self.bacgroundScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bacgroundScrollView];
    self.bacgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.bacgroundScrollView.showsVerticalScrollIndicator = NO;
    self.bacgroundScrollView.scrollEnabled = NO;
    
    self.forgroundScrollView = [UIScrollView new];
    self.forgroundScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.forgroundScrollView];
    self.forgroundScrollView.delegate = self;
    self.forgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.forgroundScrollView.showsVerticalScrollIndicator = NO;
    self.forgroundScrollView.scrollEnabled = NO;
    
    [self.view hrAddMarginConstraintSubview:self.bacgroundScrollView];
    [self.view hrAddMarginConstraintSubview:self.forgroundScrollView];
    
    [self performSegueWithIdentifier:kBBNavigationViewController sender:self];
    
    [self.forgroundScrollView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(actionPanGesture:)]];
    
    [self reloadData];
    [self start];
}


#pragma mark - publick 

- (void)pushViewController:(UIViewController *)viewController {
    [self pushViewController:viewController animation:YES];
}

- (void)popViewController {
    [self popViewControllerAnimation:YES];
}

- (void) pushViewController:(UIViewController*) viewController
                  animation:(BOOL) isAnimation{
    if (self.rightConstraint) {
        [self.forgroundScrollView removeConstraint:self.rightConstraint];
    }
    
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.forgroundScrollView addSubview:viewController.view];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:viewController];
    
    if (self.viewControllers.count) {
        [self.forgroundScrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                             attribute:(NSLayoutAttributeLeft)
                                                                             relatedBy:(NSLayoutRelationEqual)
                                                                                toItem:self.viewControllers.lastObject.view
                                                                             attribute:(NSLayoutAttributeRight)
                                                                            multiplier:1.
                                                                              constant:0.]];
    } else {
        [self.forgroundScrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                             attribute:(NSLayoutAttributeLeft)
                                                                             relatedBy:(NSLayoutRelationEqual)
                                                                                toItem:self.forgroundScrollView
                                                                             attribute:(NSLayoutAttributeLeft)
                                                                            multiplier:1.
                                                                              constant:0.]];
    }
    
    [self.viewControllers addObject:viewController];
    
    self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.forgroundScrollView
                                                        attribute:(NSLayoutAttributeRight)
                                                        relatedBy:(NSLayoutRelationEqual)
                                                           toItem:viewController.view
                                                        attribute:(NSLayoutAttributeRight)
                                                       multiplier:1.
                                                         constant:0.];
    [self.forgroundScrollView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.forgroundScrollView
                                                                            attribute:(NSLayoutAttributeTop)
                                                                            relatedBy:(NSLayoutRelationEqual)
                                                                               toItem:viewController.view
                                                                            attribute:(NSLayoutAttributeTop)
                                                                           multiplier:1.
                                                                             constant:0.],
                                               [NSLayoutConstraint constraintWithItem:self.forgroundScrollView
                                                                            attribute:(NSLayoutAttributeBottom)
                                                                            relatedBy:(NSLayoutRelationEqual)
                                                                               toItem:viewController.view
                                                                            attribute:(NSLayoutAttributeBottom)
                                                                           multiplier:1.
                                                                             constant:0.],
                                               self.rightConstraint,
                                               [NSLayoutConstraint constraintWithItem:viewController.view
                                                                            attribute:(NSLayoutAttributeWidth)
                                                                            relatedBy:(NSLayoutRelationEqual)
                                                                               toItem:self.forgroundScrollView
                                                                            attribute:(NSLayoutAttributeWidth)
                                                                           multiplier:1.
                                                                             constant:0.],
                                               [NSLayoutConstraint constraintWithItem:viewController.view
                                                                            attribute:(NSLayoutAttributeHeight)
                                                                            relatedBy:(NSLayoutRelationEqual)
                                                                               toItem:self.forgroundScrollView
                                                                            attribute:(NSLayoutAttributeHeight)
                                                                           multiplier:1.
                                                                             constant:0.]]];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    if (isAnimation) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.forgroundScrollView setContentOffset:CGPointMake((self.viewControllers.count - 1) * self.view.frame.size.width,
                                                                                    0)];
                             [self updatebacgroundPosition];
                         }];
    } else {
        [self.forgroundScrollView setContentOffset:CGPointMake((self.viewControllers.count - 1) * self.view.frame.size.width,
                                                               0)];
        [self updatebacgroundPosition];
    }
}

- (void) popViewControllerAnimation:(BOOL) isAnimation{
    if (self.viewControllers.count == 1) {
        return;
    }
    if (!isAnimation) {
        [self.forgroundScrollView setContentOffset:CGPointMake((self.viewControllers.count - 2) * self.view.frame.size.width,
                                                               0)
                                          animated:NO];
        [self updatebacgroundPosition];

        if (self.rightConstraint) {
            [self.forgroundScrollView removeConstraint:self.rightConstraint];
        }
        
        
        [self.viewControllers.lastObject removeFromParentViewController];
        [self.viewControllers.lastObject.view removeFromSuperview];
        [self.viewControllers removeLastObject];
        
        if (self.viewControllers.count) {
            self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.forgroundScrollView
                                                                attribute:(NSLayoutAttributeRight)
                                                                relatedBy:(NSLayoutRelationEqual)
                                                                   toItem:self.viewControllers.lastObject.view
                                                                attribute:(NSLayoutAttributeRight)
                                                               multiplier:1.
                                                                 constant:0.];
            [self.forgroundScrollView addConstraint:self.rightConstraint];
        }
        
        return;
    }
    if (self.viewControllers.count) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.forgroundScrollView setContentOffset:CGPointMake((self.viewControllers.count - 2) * self.view.frame.size.width,
                                                                                    0)];
                             [self updatebacgroundPosition];
                         } completion:^(BOOL finished) {
                             if (self.rightConstraint) {
                                 [self.forgroundScrollView removeConstraint:self.rightConstraint];
                             }
                             [self.viewControllers.lastObject removeFromParentViewController];
                             [self.viewControllers.lastObject.view removeFromSuperview];
                             [self.viewControllers removeLastObject];
                             
                             if (self.viewControllers.count) {
                                 self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.forgroundScrollView
                                                                                     attribute:(NSLayoutAttributeRight)
                                                                                     relatedBy:(NSLayoutRelationEqual)
                                                                                        toItem:self.viewControllers.lastObject.view
                                                                                     attribute:(NSLayoutAttributeRight)
                                                                                    multiplier:1.
                                                                                      constant:0.];
                                 [self.forgroundScrollView addConstraint:self.rightConstraint];
                             }
                         }];
    }
}

- (void) updatebacgroundPosition{
    [self.bacgroundScrollView setContentOffset:CGPointMake(self.forgroundScrollView.contentOffset.x / 10.,
                                                           self.forgroundScrollView.contentOffset.y / 10.)];
}

#pragma mark - private
- (void) reloadData{
    NSMutableArray* list = [NSMutableArray new];
    for (int i = 0; i < self.numberOfBombs ; i++) {
        BBMenuCellView* cell = [BBMenuCellView new];
        [list addObject:cell];
        [self.bacgroundScrollView addSubview:cell];
        
        CGFloat k = (CGFloat)(rand() % 10000) / 10000. - 0.5;
        cell.radius = self.allRadius + self.allRadiusDelta * k;
        k = (CGFloat)(rand() % 10000) / 20000.;
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:k];
    }
    self.bombManager = [[BBBombManager alloc] initWithArea:CGPointMake([UIScreen mainScreen].bounds.size.width * 2.,
                                                                       [UIScreen mainScreen].bounds.size.height)];

    self.bacgroundScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2. ,
                                                      [UIScreen mainScreen].bounds.size.height);
    self.bombManager.maxRadius = 10;
    self.bombManager.minRadius = 10;
    self.bombManager.deltaVel = 0.2;
    [self.bombManager reloadWithNumberBombs:self.numberOfBombs];
    self.backgroundViews = list;
}

- (void) updateFrame {
    [self.bombManager nextStepWithTime:30./60.];
    for (int i = 0; i < self.backgroundViews.count; i++) {
        BBBomb* bomb = [self.bombManager bombsAtIndex:i];
        self.backgroundViews[i].position = CGPointMake(bomb->position.x,
                                                       bomb->position.y);
    }
}

#pragma mark - publick
- (void) start {
    [self stop];
    self.bacgroundScrollView.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1./30.
                                                  target:self
                                                selector:@selector(updateFrame)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) stop {
    [self.timer invalidate];
    self.bacgroundScrollView.hidden = YES;
}


- (IBAction)actionPanGesture:(UIPanGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.startPoint = [sender locationInView:self.view];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat x = [sender locationInView:self.view].x - self.startPoint.x;
        if (x > 0 && self.viewControllers.count > 1) {
            self.forgroundScrollView.contentOffset = CGPointMake((self.viewControllers.count - 1) * self.view.frame.size.width - x,
                                                                 0);
            [self updatebacgroundPosition];
        }
    } else {
        CGPoint point = [sender velocityInView:self.view];
        if (point.x > 0) {
            [self popViewControllerAnimation:YES];
        } else {
            [UIView animateWithDuration:0.4
                             animations:^{
                                 self.forgroundScrollView.contentOffset = CGPointMake((self.viewControllers.count - 1) * self.view.frame.size.width ,
                                                                                      0);
                                 [self updatebacgroundPosition];
                             }];
        }
    }
}


@end
