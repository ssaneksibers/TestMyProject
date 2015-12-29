//
//  ViewController.m
//  BumBom
//
//  Created by Alexander Shipin on 29/12/15.
//  Copyright © 2015 Alexander Shipin. All rights reserved.
//

#import "BBGameViewController.h"
#import "BBBombManager.h"
#import "BBLevelManger.h"

@interface BBGameViewController ()<BBLevelMangerDelegate>

@property (nonatomic,strong) IBInspectable UIImage* bombImage;
@property (nonatomic,strong) IBInspectable UIImage* activBombImage;
@property (nonatomic,strong) BBBombManager* bombManager;
@property (nonatomic,strong,readonly) NSMutableArray<UIImageView*>* subImageViews;

@property (nonatomic,assign) BOOL isNeedUpdate;
@property (nonatomic,strong) NSValue* lastTapPoint;

@property (nonatomic,assign) NSInteger numberOfPoints;

@end

@implementation BBGameViewController{
    NSMutableArray<UIImageView*>* _subImageViews;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.numberOfPoints = 0;
    _subImageViews = [NSMutableArray new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData];
}

- (void) reloadData{
    if (self.levelManager) {
#warning demo code
        _levelManager = [BBLevelManger levels][0];
    }
    self.bombManager = [[BBBombManager alloc] initWithArea:CGPointMake(self.view.frame.size.width,
                                                                       self.view.frame.size.height)];
    self.bombManager.maxRadius = 40;
    self.bombManager.minRadius = 20;
    self.bombManager.timeRadius = 1;
    
    [self.levelManager startLevel:self.bombManager];
    
    [NSTimer scheduledTimerWithTimeInterval:1./30.
                                     target:self
                                   selector:@selector(updateImages)
                                   userInfo:nil
                                    repeats:YES];
}


- (void)setLevelManager:(BBLevelManger *)levelManager{
    _levelManager = levelManager;
    _levelManager.delegate = self;
    [self reloadData];
}

- (void) updateImages {
    [self.bombManager nextStepWithTime:1./30.];
    CGPoint tapPoint = [self.lastTapPoint CGPointValue];
    BOOL isActiv = NO;
    for (int i = 0; i < self.bombManager.numberOfBombs; i++){
        CGPoint point = [self.bombManager bombsAtIndex:i]->position;
        CGFloat size = [self.bombManager bombsAtIndex:i]->curentRadius;
        UIImageView* imageView = nil;
        if (self.subImageViews.count > i) {
            imageView = self.subImageViews[i];
        } else {
            imageView = [UIImageView new];
            imageView.userInteractionEnabled = YES;
            [self.subImageViews addObject:imageView];
            [self.view addSubview:imageView];
        }
        imageView.frame = CGRectMake(point.x - size,
                                     point.y - size,
                                     size * 2.,
                                     size * 2);
        imageView.layer.cornerRadius = size;
        if ([self.bombManager bombsAtIndex:i]->isActivState) {
            imageView.image = self.activBombImage;
            isActiv = YES;
            imageView.backgroundColor = [UIColor redColor];
        } else {
            if (self.lastTapPoint) {
                if ((point.x - tapPoint.x)*(point.x - tapPoint.x) +
                    (point.y - tapPoint.y)*(point.y - tapPoint.y) < size * size) {
                    [self.bombManager activBombAtIndex:i];
                }
            }
            imageView.image = self.bombImage;
            NSInteger type = [self.bombManager bombsAtIndex:i]->type;
            if (type == 0) {
                imageView.backgroundColor = [UIColor blackColor];
            } else if (type == 1) {
                imageView.backgroundColor = [UIColor blueColor];
            } else {
                imageView.backgroundColor = [UIColor greenColor];
            }
        }
    }
    self.lastTapPoint = nil;
    if (self.isNeedUpdate && !isActiv) {
        if (!(self.levelManager.currentTap == 0  && [self.levelManager endLevel:self.bombManager])
            || (self.levelManager.currentTap != 0 && [self.levelManager nextLevel:self.bombManager])) {
            
        }
        self.isNeedUpdate = NO;
    }
    while (self.subImageViews.count > self.bombManager.numberOfBombs) {
        [self.subImageViews[self.subImageViews.count - 1] removeFromSuperview];
        [self.subImageViews removeObjectAtIndex:self.subImageViews.count - 1];
    }
}

- (void) nextLevel{
    self.numberOfPoints += self.levelManager.numberOfPoints;
    NSInteger level = [[BBLevelManger levels] indexOfObject:self.levelManager];
    self.levelManager = [BBLevelManger levels] [level + 1];
}

#pragma mark - tap
- (IBAction) actionWithTap:(UITapGestureRecognizer*) tap{
    if (self.levelManager.currentTap) {
        self.isNeedUpdate = YES;
        self.levelManager.currentTap--;
        self.lastTapPoint = [NSValue valueWithCGPoint:[tap locationInView:self.view]];
    }
}

#pragma mark - BBLevelMangerDelegate
- (void) showAlertText:(NSString*) alertText
                 title:(NSString*) title
                  type:(BBLevelMangerMessageType) type{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:alertText
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    __weak typeof(self) weakSelf = self;
    if (type == BBLevelMangerMessageTypeEndLevel) {
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"next", @"")
                                                  style:(UIAlertActionStyleDefault)
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [weakSelf nextLevel];
                                                }]];
    }
    if (type == BBLevelMangerMessageTypeEndLevel || type == BBLevelMangerMessageTypeFaild) {
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"repit", @"")
                                                  style:(UIAlertActionStyleDefault)
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [weakSelf reloadData];
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"back in menu", @"")
                                                  style:(UIAlertActionStyleDefault)
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                                }]];
    }
    if (type == BBLevelMangerMessageTypeStartLevel) {
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"")
                                                  style:(UIAlertActionStyleDefault)
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                }]];
    }
    
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
