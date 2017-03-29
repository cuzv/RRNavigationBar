//
//  StoryboardViewController.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/29/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "StoryboardViewController.h"

@interface StoryboardViewController ()

@end

@implementation StoryboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Storyboard";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Present" style:UIBarButtonItemStylePlain target:self action:@selector(present:)];
}

- (void)present:(UIBarButtonItem *)sender {
    UINavigationController *controller = [UIStoryboard storyboardWithName:@"Present" bundle:nil].instantiateInitialViewController;
    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}

@end
