//
//  ProductMoreViewController.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/27/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "ProductMoreViewController.h"
#import "RRNavigationBar.h"

@interface ProductMoreViewController ()
@end

@implementation ProductMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"More";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pop" style:UIBarButtonItemStylePlain target:self action:@selector(pop:)];
    self.rr_interactivePopGestureRecognizerDisabled = YES;
}

- (void)pop:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
