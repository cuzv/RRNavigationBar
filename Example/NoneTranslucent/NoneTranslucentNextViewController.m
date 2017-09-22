//
//  NoneTranslucentNextViewController.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 9/22/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "NoneTranslucentNextViewController.h"
#import "UIColor+EKExtension.h"
#import "RRNavigationBar.h"

@interface NoneTranslucentNextViewController ()

@end

@implementation NoneTranslucentNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 200, 60)];
    [self.view addSubview:view];
    view.backgroundColor = UIColor.ek_random;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [view.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:10].active = YES;
    [view.widthAnchor constraintEqualToConstant:200].active = YES;
    [view.heightAnchor constraintEqualToConstant:60].active = YES;
    
    self.rr_navigationBar.translucent = YES;
}


@end
