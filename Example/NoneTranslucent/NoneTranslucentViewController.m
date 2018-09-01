//
//  NoneTranslucentViewController.m
//  RRNavigationBar
//
//  Created by Shaw on 9/22/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "NoneTranslucentViewController.h"
#import "NoneTranslucentNextViewController.h"
#import "UIColor+EKExtension.h"
#import "RRNavigationBar.h"

@interface NoneTranslucentViewController ()

@end

@implementation NoneTranslucentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 200, 60)];
    [self.view addSubview:view];
    view.backgroundColor = UIColor.ek_random;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [view.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:10].active = YES;
    [view.widthAnchor constraintEqualToConstant:200].active = YES;
    [view.heightAnchor constraintEqualToConstant:60].active = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(onNext:)];
    
    self.rr_navigationBar.translucent = YES;
    
}

- (void)onNext:(UIBarButtonItem *)sender {
    NoneTranslucentNextViewController *vc = [NoneTranslucentNextViewController new];
    [self showViewController:vc sender:nil];
}


@end
