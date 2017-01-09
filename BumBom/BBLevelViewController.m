//
//  BBLevelViewController.m
//  BumBom
//
//  Created by Alexander Shipin on 14/01/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import "BBLevelViewController.h"
#import "BBViewController.h"
#import "BBMenuCollectionView.h"

@interface BBLevelViewController ()


@property (nonatomic,strong) IBOutlet BBMenuCollectionView* collectionView;
@property (nonatomic,strong) NSPointerArray* pointerArray;

@end

@implementation BBLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setActions:@[[BBMenuCollectionViewAction actionWithText:@"1"
                                                                          action:^{
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"2"
                                                                          action:^{
                                                                              
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"3"
                                                                          action:^{
                                                                              
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"4"
                                                                          action:^{
                                                                              
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"1"
                                                                          action:^{
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"2"
                                                                          action:^{
                                                                              
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"3"
                                                                          action:^{
                                                                              
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"4"
                                                                          action:^{
                                                                              
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"1"
                                                                          action:^{
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"2"
                                                                          action:^{
                                                                              
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"3"
                                                                          action:^{
                                                                              
                                                                          }],
                                      [BBMenuCollectionViewAction actionWithText:@"4"
                                                                          action:^{
                                                                              
                                                                          }]
                                      ]];
}

#pragma mark - ACTION

- (IBAction)pressedButtonBack:(id)sender {
    [self.bbNavigationViewController popViewController];
}

@end
