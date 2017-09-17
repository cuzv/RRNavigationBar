//
//  EmbedTabBarController.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/28/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "EmbedTabBarController.h"
#import "RRNavigationBar.h"
#import "TableViewController.h"
#import "ProductListViewController.h"
#import "StoryboardViewController.h"
#import "Helper.h"

@interface EmbedTabBarController ()

@end

@implementation EmbedTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        UINavigationBar *global = [UINavigationBar appearance];
        global.tintColor = [UIColor magentaColor];
        global.barStyle = UIBarMetricsDefault;
        global.translucent = YES;
//        UIImage *indicatorImage = RRUIImageMakeWithSize([UIColor orangeColor], CGSizeMake(13, 21));
//        global.backIndicatorImage = indicatorImage;
//        global.backIndicatorTransitionMaskImage = indicatorImage;
    }

    UINavigationController *productRoot = [[UINavigationController alloc] initWithRootViewController:[ProductListViewController new]];
    productRoot.tabBarItem.title = @"Product Example";
    productRoot.navigationBar.tintColor = [UIColor redColor];
    
//    UINavigationController *exampleRoot = [UINavigationController new];
//    exampleRoot.viewControllers = @[[TableViewController new], [TableViewController new], [TableViewController new]];
    UINavigationController *exampleRoot = [[UINavigationController alloc] initWithRootViewController:[TableViewController new]];
    exampleRoot.tabBarItem.title = @"Custom Example";
    
    UINavigationController *storyboardRoot = [[UINavigationController alloc] initWithRootViewController:[StoryboardViewController new]];
    storyboardRoot.tabBarItem.title = @"Storyboard Example";

    self.viewControllers = @[productRoot, exampleRoot, storyboardRoot];
    self.selectedIndex = 1;
}


@end
