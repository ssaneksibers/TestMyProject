//
//  BBCurcleMenuViewController.m
//  BumBom
//
//  Created by Alexander Shipin on 11/01/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import "BBCurcleMenuViewController.h"
#import "BBMenuCollectionView.h"
#import "HRKeyDefine.h"

HRImplementationKey(kBBCurcleMenuViewControllerShowGameSegueIdentifier);
HRImplementationKey(kBBCurcleMenuViewControllerShowLevelSegueIdentifier);

@interface BBCurcleMenuViewController ()

@property (nonatomic,strong) IBOutlet BBMenuCollectionView* collectionView;

@end

@implementation BBCurcleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.collectionView.backgroundColors = @[[UIColor redColor],[UIColor orangeColor],[UIColor blueColor],[UIColor yellowColor]];
    [self.collectionView setActions:@[[BBMenuCollectionViewAction actionWithText:@"New Game"
                                                                          action:^{
                                                                              [weakSelf.collectionView stop];
                                                                              [weakSelf performSegueWithIdentifier:kBBCurcleMenuViewControllerShowGameSegueIdentifier
                                                                                                            sender:nil];
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"Contine"
                                                                          action:^{
                                                                              [weakSelf.collectionView stop];
                                                                              [weakSelf performSegueWithIdentifier:kBBCurcleMenuViewControllerShowLevelSegueIdentifier
                                                                                                            sender:nil];
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"Recors"
                                                                          action:^{
                                                                              
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"Share"
                                                                          action:^{
                                                                              
                                                                          }]
                                      ]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.collectionView stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
