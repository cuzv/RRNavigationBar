//
//  EmbedTabBarController.m
//  RRNavigationBar
//
//  Created by Shaw on 3/28/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "EmbedTabBarController.h"
#import "RRNavigationBar.h"
#import "TableViewController.h"
#import "ProductListViewController.h"
#import "StoryboardViewController.h"
#import "NoneTranslucentViewController.h"
#import "Helper.h"
#import "UIColor+EKExtension.h"
//#import <RRNavigationTransitioning/RRNavigationTransitioning.h>

@interface RRNavigationController : UINavigationController
//@property (nonatomic, strong) RRNavigationTransition *transition;
@end


@implementation RRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    RRNavigationTransition *transition = [[RRNavigationTransition alloc] initWithNavigationController:self];
//    self.transition = transition;
//    self.delegate = self.transition;
//    self.interactivePopGestureRecognizer.delegate = nil;
//    self.interactivePopGestureRecognizer.enabled = NO;
}

@end

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

    UINavigationController *productRoot = [[RRNavigationController alloc] initWithRootViewController:[ProductListViewController new]];
    productRoot.tabBarItem.title = @"Product";
    productRoot.navigationBar.tintColor = [UIColor redColor];
    
//    UINavigationController *exampleRoot = [UINavigationController new];
//    exampleRoot.viewControllers = @[[TableViewController new], [TableViewController new], [TableViewController new]];
    UINavigationController *exampleRoot = [[RRNavigationController alloc] initWithRootViewController:[TableViewController new]];
    exampleRoot.tabBarItem.title = @"Custom";
    
    UINavigationController *storyboardRoot = [[RRNavigationController alloc] initWithRootViewController:[StoryboardViewController new]];
    storyboardRoot.tabBarItem.title = @"Storyboard";

    UINavigationController *noneTranslucentRoot = [[RRNavigationController alloc] initWithRootViewController:[NoneTranslucentViewController new]];
    noneTranslucentRoot.tabBarItem.title = @"NoneTranslucent";
    noneTranslucentRoot.navigationBar.translucent = NO;
    noneTranslucentRoot.navigationItem.title = @"NoneTranslucent";
    [noneTranslucentRoot.navigationBar setBackgroundImage:RRUIImageMake(UIColor.ek_random) forBarMetrics:UIBarMetricsDefault];
    
    self.viewControllers = @[productRoot, exampleRoot, storyboardRoot, noneTranslucentRoot];
    self.selectedIndex = 1;
}


@end
