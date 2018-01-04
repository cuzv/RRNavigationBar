//
//  RRNavigationControllerDelegate.h
//  RRNavigationBar
//
//  Created by Roy Shaw on 1/4/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#ifndef RRNavigationControllerDelegate_h
#define RRNavigationControllerDelegate_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RRNavigationControllerDelegate <NSObject>

@optional

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)rr_navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)rr_navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (UIInterfaceOrientationMask)rr_navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
- (UIInterfaceOrientation)rr_navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;

- (nullable id <UIViewControllerInteractiveTransitioning>)rr_navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0);

- (nullable id <UIViewControllerAnimatedTransitioning>)rr_navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);

@end

NS_ASSUME_NONNULL_END

#endif /* RRNavigationControllerDelegate_h */
