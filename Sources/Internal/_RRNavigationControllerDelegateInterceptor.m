//
//  _RRNavigationControllerDelegateInterceptor.m
//  RRNavigationBar
//
//  Created by Shaw on 1/5/18.
//  Copyright © 2018 Shaw. All rights reserved.
//

#import "_RRNavigationControllerDelegateInterceptor.h"
#import "UINavigationController+RRNavigationBar_Internal.h"

@interface _RRNavigationControllerDelegateInterceptor ()
@property (nonatomic, assign) BOOL delegateImplementsWillShowViewControllerAnimated;
@property (nonatomic, assign) BOOL delegateImplementsDidShowViewControllerAnimated;
@property (nonatomic, assign) BOOL delegateImplementsSupportedInterfaceOrientations;
@property (nonatomic, assign) BOOL delegateImplementsPreferredInterfaceOrientationForPresentation;
@property (nonatomic, assign) BOOL delegateImplementsInteractionControllerForAnimationController;
@property (nonatomic, assign) BOOL delegateImplementsAnimationControllerForOperationFromViewControllerToViewController;
@end

@implementation _RRNavigationControllerDelegateInterceptor

#pragma mark -

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateImplementsWillShowViewControllerAnimated = [_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)];
        _delegateImplementsDidShowViewControllerAnimated = [_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)];
        _delegateImplementsSupportedInterfaceOrientations = [_delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)];
        _delegateImplementsPreferredInterfaceOrientationForPresentation = [_delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)];
        _delegateImplementsInteractionControllerForAnimationController = [_delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)];
        _delegateImplementsAnimationControllerForOperationFromViewControllerToViewController = [_delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.delegateImplementsWillShowViewControllerAnimated) {
        [self.delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }

    RRExcludeImpactBehaviorFor(navigationController);

    [navigationController _handleWillShowViewController:viewController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.delegateImplementsDidShowViewControllerAnimated) {
        [self.delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }

    RRExcludeImpactBehaviorFor(navigationController);

    [navigationController _handleDidShowViewController:viewController];
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    if (self.delegateImplementsSupportedInterfaceOrientations) {
        return [self.delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    if (self.delegateImplementsPreferredInterfaceOrientationForPresentation) {
        return [self.delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }

    switch (UIDevice.currentDevice.orientation) {
        case UIDeviceOrientationPortraitUpsideDown: return UIInterfaceOrientationPortraitUpsideDown;
        case UIDeviceOrientationLandscapeRight: return UIInterfaceOrientationLandscapeLeft;
        case UIDeviceOrientationLandscapeLeft: return UIInterfaceOrientationLandscapeRight;
        default: return UIInterfaceOrientationPortrait;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if (self.delegateImplementsInteractionControllerForAnimationController) {
        return [self.delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  {
    if (self.delegateImplementsAnimationControllerForOperationFromViewControllerToViewController) {
        return [self.delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [_delegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _delegate;
}

@end
