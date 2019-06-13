//
//  StoryboardViewController.m
//  RRNavigationBar
//
//  Created by Shaw on 3/29/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "StoryboardViewController.h"
#import "SBRootViewController.h"

#pragma mark -

@interface StoryboardViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation StoryboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Storyboard";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Present" style:UIBarButtonItemStylePlain target:self action:@selector(present:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Picker" style:UIBarButtonItemStylePlain target:self action:@selector(pick:)];
}

- (void)present:(UIBarButtonItem *)sender {
    UINavigationController *controller = [UIStoryboard storyboardWithName:@"Present" bundle:nil].instantiateInitialViewController;
    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)pick:(UIBarButtonItem *)sender {
    UIImagePickerController *controller = [UIImagePickerController new];
    controller.delegate = self;
    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

@end


