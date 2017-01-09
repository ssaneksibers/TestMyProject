//
//  BBNavigationViewControllerSegue.m
//  BumBom
//
//  Created by Alexander Shipin on 13/01/16.
//  Copyright © 2016 Alexander Shipin. All rights reserved.
//

#import "BBNavigationViewControllerSegue.h"
#import "BBViewController.h"

@implementation BBNavigationViewControllerSegue

- (void)perform {
    [[self.sourceViewController bbNavigationViewController] pushViewController:self.destinationViewController];
}

@end
