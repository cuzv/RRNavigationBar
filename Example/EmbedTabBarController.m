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
#import "Helper.h"

@interface EmbedTabBarController ()

@end

@implementation EmbedTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    {
//        UINavigationBar *global = [UINavigationBar appearance];
//        global.tintColor = [UIColor magentaColor];
//        global.barStyle = UIBarMetricsDefault;
//        global.translucent = YES;
//        [global setBackgroundImage:RRUIImageMake([UIColor cyanColor]) forBarMetrics:UIBarMetricsDefault];
//        UIImage *backIndicator = [RRUIImageMakeWithSize([UIColor yellowColor], CGSizeMake(13, 21)) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        global.backIndicatorImage = backIndicator;
//        global.backIndicatorTransitionMaskImage = backIndicator;
//        global.rr_appearanceDeployed = YES;
//    }

    UINavigationController *productRoot = [[UINavigationController alloc] initWithRootViewController:[ProductListViewController new]];
    productRoot.tabBarItem.title = @"Product Example";
    productRoot.rr_navigationBar.tintColor = [UIColor redColor];

//    UIImage *backIndicator = [RRUIImageMakeWithSize([UIColor yellowColor], CGSizeMake(13, 21)) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    productRoot.rr_navigationBar.backIndicatorImage = backIndicator;
//    productRoot.rr_navigationBar.backIndicatorTransitionMaskImage = backIndicator;
    
//    UINavigationController *exampleRoot = [UINavigationController new];
//    exampleRoot.viewControllers = @[[TableViewController new], [TableViewController new], [TableViewController new]];
    UINavigationController *exampleRoot = [[UINavigationController alloc] initWithRootViewController:[TableViewController new]];
    exampleRoot.tabBarItem.title = @"Custom Example";

    self.viewControllers = @[productRoot, exampleRoot];
}


@end
