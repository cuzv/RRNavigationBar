//
//  UINavigationController+RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/25/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UINavigationController+RRNavigationBar.h"
#import "UIViewController+RRNavigationBar.h"
#import "RRUtils.h"
#import <objc/runtime.h>
#import "UINavigationBar+RRAddition.h"
#import "UINavigationBar+RRAddition_Internal.h"
#import "_RRWeakAssociatedObjectWrapper.h"

@interface UINavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, weak, nullable) UIViewController *_visibleTopViewController;
@end

@implementation UINavigationController (RRNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.class == UINavigationController.class) {
            RRSwizzleInstanceMethod(self.class, @selector(viewDidLoad), @selector(_rr_viewDidLoad));
            RRSwizzleInstanceMethod(self.class, @selector(preferredStatusBarStyle), @selector(_rr_preferredStatusBarStyle));
        }
    });
}

#pragma mark - Private

- (nullable UIViewController *)_visibleTopViewController {
    return ((_RRWeakAssociatedObjectWrapper *)objc_getAssociatedObject(self, _cmd)).object;
}

- (void)set_visibleTopViewController:(nullable UIViewController *)_visibleTopViewController {
    _RRWeakAssociatedObjectWrapper *wrapper = [[_RRWeakAssociatedObjectWrapper alloc] initWithObject:_visibleTopViewController];
    objc_setAssociatedObject(self, @selector(_visibleTopViewController), wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_makeNavigationBarVisible:(BOOL)visible {
    [[self.navigationBar valueForKey:@"_backgroundView"] setHidden:!visible];
}

#pragma mark - Swizzle

- (void)_rr_viewDidLoad {
    [self _rr_viewDidLoad];
    self.delegate = self;
    self.rr_navigationBar = RRUINavigationBarDuplicate(self.navigationBar);
}

- (UIStatusBarStyle)_rr_preferredStatusBarStyle {
    if (self.topViewController) {
        return self.topViewController.preferredStatusBarStyle;
    }
    return  [self _rr_preferredStatusBarStyle];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    RRLog(@"WILL SHOW VC %@", viewController.navigationItem.title);

    // If these two navigationBar `equal`, use system transition behavior.
    if (RRIsUINavigationBarEqual(viewController.rr_navigationBar, self._visibleTopViewController.rr_navigationBar)) {
        viewController.rr_navigationBar._rr_transiting = YES;
        viewController.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = YES;
        self._visibleTopViewController.rr_navigationBar._rr_transiting = YES;
        self._visibleTopViewController.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = YES;
        if (!viewController.view.backgroundColor) {
            viewController.view.backgroundColor = self._visibleTopViewController.view.backgroundColor;
        }
        return;
    }
    
    // If cancel pop, needs recover.
    __weak typeof(self) weak_self = self;
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self._visibleTopViewController.transitionCoordinator;
    [transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (context.isCancelled) {
            RRLog(@"Canceled");
            __strong typeof(weak_self) strong_self = weak_self;
            [strong_self _handleDidShowViewController:strong_self._visibleTopViewController];
        }
    }];

    viewController.rr_navigationBar._rr_transiting = YES;
    viewController.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = NO;
    self._visibleTopViewController.rr_navigationBar._rr_transiting = YES;
    self._visibleTopViewController.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = NO;

    self._visibleTopViewController.view.clipsToBounds = NO;
    viewController.view.clipsToBounds = NO;
    
    [self._visibleTopViewController viewWillLayoutSubviews];
    [viewController viewWillLayoutSubviews];
    
    if (!viewController.view.backgroundColor) {
        viewController.view.backgroundColor = self._visibleTopViewController.view.backgroundColor;
    }

    [self _makeNavigationBarVisible:NO];
    
#if DEBUG
    NSUInteger currentIndex = [navigationController.viewControllers indexOfObject:self._visibleTopViewController];
    NSUInteger toIndex = [navigationController.viewControllers indexOfObject:viewController];
    if (currentIndex > toIndex) {
        RRLog(@"POPING TO VC %@", viewController.navigationItem.title);
    } else {
        RRLog(@"PUSHING TO VC %@", viewController.navigationItem.title);
    }
#endif
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self _handleDidShowViewController:viewController];
    RRLog(@"DID SHOW VC %@", viewController.navigationItem.title);
    RRLog(@"%@", viewController.rr_navigationBar.hidden ? @"HIDDEN" : @"NOT HIDDEN");
}

- (void)_handleDidShowViewController:(UIViewController *)viewController {
    [viewController.rr_navigationBar _apply];
    [self _makeNavigationBarVisible:YES];

    viewController.rr_navigationBar._rr_transiting = NO;
    viewController.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = NO;
    self._visibleTopViewController.rr_navigationBar._rr_transiting = NO;
    self._visibleTopViewController.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = NO;
    
    viewController.view.clipsToBounds = YES;
    self._visibleTopViewController.view.clipsToBounds = YES;
    
    viewController.rr_navigationBar.hidden = YES;
    self._visibleTopViewController.rr_navigationBar.hidden = YES;

    self._visibleTopViewController = viewController;
}

@end
