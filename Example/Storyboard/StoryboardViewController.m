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

@interface _ImagePickerController : UIImagePickerController
@end

@implementation _ImagePickerController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return true;
}

@end

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
    UIImagePickerController *controller = [_ImagePickerController new];
    controller.delegate = self;
    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
    NSLog(@"%@", @"Canceled");
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    return UIInterfaceOrientationLandscapeLeft;
}

@end

