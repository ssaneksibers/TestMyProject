//
//  ViewController.m
//  BumBom
//
//  Created by Alexander Shipin on 29/12/15.
//  Copyright © 2015 Alexander Shipin. All rights reserved.
//

#import "BBGameViewController.h"
#import "BBBombManager.h"

@interface BBGameViewController ()

@property (nonatomic,strong) IBInspectable UIImage* bombImage;
@property (nonatomic,strong) IBInspectable UIImage* activBombImage;
@property (nonatomic,strong) BBBombManager* bombManager;
@property (nonatomic,strong,readonly) NSMutableArray<UIImageView*>* subImageViews;

@property (nonatomic,strong) NSValue* lastTapPoint;

@end

@implementation BBGameViewController{
    NSMutableArray<UIImageView*>* _subImageViews;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _subImageViews = [NSMutableArray new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.bombManager = [[BBBombManager alloc] initWithArea:CGPointMake(self.view.frame.size.width,
                                                                       self.view.frame.size.height)];
    self.bombManager.maxRadius = 40;
    self.bombManager.minRadius = 20;
    self.bombManager.timeRadius = 1;
    
    [self.bombManager reloadWithNumberBombs:24 countWithTypeOne:24 countWithNumberTwo:24];
    
    [NSTimer scheduledTimerWithTimeInterval:1./30.
                                     target:self
                                   selector:@selector(updateImages)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) updateImages {
    [self.bombManager nextStepWithTime:1./30.];
    CGPoint tapPoint = [self.lastTapPoint CGPointValue];
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
    while (self.subImageViews.count > self.bombManager.numberOfBombs) {
        [self.subImageViews[self.subImageViews.count - 1] removeFromSuperview];
        [self.subImageViews removeObjectAtIndex:self.subImageViews.count - 1];
    }
}

#pragma mark - tap
- (IBAction) actionWithTap:(UITapGestureRecognizer*) tap{
    self.lastTapPoint = [NSValue valueWithCGPoint:[tap locationInView:self.view]];
}


@end
