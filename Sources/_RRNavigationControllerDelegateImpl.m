//
//  _RRNavigationControllerDelegateImpl.m
//  RRNavigationBar
//
//  Created by Roy Shaw on 1/5/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "_RRNavigationControllerDelegateImpl.h"
#import "UINavigationController+RRNavigationBar_Internal.h"

@implementation _RRNavigationControllerDelegateImpl

#pragma mark -

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
    
    RRExcludeImpactBehaviorFor(navigationController);
    [navigationController _handleWillShowViewController:viewController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    
    RRExcludeImpactBehaviorFor(navigationController);
    [navigationController _handleDidShowViewController:viewController];
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    
    switch (UIDevice.currentDevice.orientation) {
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationPortrait:
            return UIInterfaceOrientationPortrait;
        case UIDeviceOrientationLandscapeLeft:
            return UIInterfaceOrientationLandscapeLeft;
        case UIDeviceOrientationLandscapeRight:
            return UIInterfaceOrientationLandscapeRight;
        case UIDeviceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationPortraitUpsideDown;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [self.delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }
    return nil;
}

@end
