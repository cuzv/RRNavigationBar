//
//  UINavigationController+RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/25/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+RRNavigationBar.h"
#import "RRUtils.h"
#import "UINavigationBar+RRNavigationBar.h"
#import "UINavigationBar+RRNavigationBar_Internal.h"
#import "_RRWeakAssociatedObjectWrapper.h"

#ifndef RRRecoverObject
#   define RRRecoverObject(from, to, info, property) (to.property = info[@#property] ?: from.property)
#endif

#ifndef RRRecoverBoolean
#   define RRRecoverBoolean(from, to, info, property) (to.property = info[@#property] ? [info[@#property] boolValue] : from.property)
#endif

#ifndef RRRecoverInteger
#   define RRRecoverInteger(from, to, info, property) (to.property = info[@#property] ? [info[@#property] integerValue] : from.property)
#endif

#ifndef RRRecoverDobule
#   define RRRecoverDobule(from, to, info, property) (to.property = info[@#property] ? [info[@#property] doubleValue] : from.property)
#endif

#ifndef RRExcludeImagePicker
#   define RRExcludeImagePicker(instance) if ([instance isKindOfClass:UIImagePickerController.class]) { return; }
#endif

@interface UINavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak, nullable) UIViewController *_visibleTopViewController;
@property (nonatomic, assign) BOOL _navigationBarInitialized;
@end

@implementation UINavigationController (RRNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RRSwizzleInstanceMethod(self.class, @selector(viewDidLoad), @selector(_rr_nvc_viewDidLoad));
        RRSwizzleInstanceMethod(self.class, @selector(viewWillLayoutSubviews), @selector(_rr_nvc_viewWillLayoutSubviews));
        RRSwizzleInstanceMethod(self.class, @selector(preferredStatusBarStyle), @selector(_rr_nvc_preferredStatusBarStyle));
    });
}

#pragma mark - Swizzle

- (void)_rr_nvc_viewDidLoad {
    RRExcludeImagePicker(self);
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self _rr_nvc_viewDidLoad];
}

- (void)_rr_nvc_viewWillLayoutSubviews {
    RRExcludeImagePicker(self);
    
    if (!self._navigationBarInitialized && self.navigationBar) {
        self.rr_navigationBar = RRUINavigationBarDuplicate(self.navigationBar);
        [self.rr_navigationBar _apply];
        self._navigationBarInitialized = YES;
        RRLog(@"nvc's rr_navigationBar initialized.");
    }
    
    // Workaround for present nvc.
    // Normally call order nvc:viewWillLayoutSubviews -> vc:viewDidLoad,
    // when present a nvc, vc:viewDidLoad -> nvc:viewWillLayoutSubviews.
    // So, in vc:viewDidLoad vc.rr_navigationBar isn't the correct styles,
    // therefore recored setups, recover when nvc.rr_navigationBar initialized.
    UINavigationBar *fromBar = self.rr_navigationBar;
    UINavigationBar *toBar = self.topViewController.rr_navigationBar;
    NSDictionary *info = toBar._tmpInfo;
    if (fromBar && info) {
        RRRecoverInteger(fromBar, toBar, info, barStyle);
        RRRecoverBoolean(fromBar, toBar, info, translucent);
        RRRecoverDobule(fromBar, toBar, info, alpha);
        RRRecoverObject(fromBar, toBar, info, tintColor);
        RRRecoverObject(fromBar, toBar, info, barTintColor);
        RRRecoverObject(fromBar, toBar, info, backgroundColor);
        RRRecoverObject(fromBar, toBar, info, shadowImage);
        [toBar setBackgroundImage:info[@"backgroundImage"] ?: [fromBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        RRRecoverObject(fromBar, toBar, info, backIndicatorImage);
        RRRecoverObject(fromBar, toBar, info, backIndicatorTransitionMaskImage);
        RRRecoverBoolean(fromBar, toBar, info, rr_forceShadowImageHidden);
        toBar._tmpInfo = nil;
    }
    
    [self _rr_nvc_viewWillLayoutSubviews];
}

- (UIStatusBarStyle)_rr_nvc_preferredStatusBarStyle {
    if (self.topViewController) {
        return self.topViewController.preferredStatusBarStyle;
    }
    return self._rr_nvc_preferredStatusBarStyle;
}

#pragma mark - Private

- (nullable UIViewController *)_visibleTopViewController {
    return ((_RRWeakAssociatedObjectWrapper *)objc_getAssociatedObject(self, _cmd)).object;
}

- (void)set_visibleTopViewController:(nullable UIViewController *)_visibleTopViewController {
    _RRWeakAssociatedObjectWrapper *wrapper = [[_RRWeakAssociatedObjectWrapper alloc] initWithObject:_visibleTopViewController];
    objc_setAssociatedObject(self, @selector(_visibleTopViewController), wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)_navigationBarInitialized {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_navigationBarInitialized:(BOOL)_navigationBarInitialized {
    objc_setAssociatedObject(self, @selector(_navigationBarInitialized), @(_navigationBarInitialized), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

- (void)_handleWillShowViewController:(UIViewController *)viewController {
    UIViewController *toVC = viewController;
    UIViewController *fromVC = self._visibleTopViewController;
    if (!fromVC) { return; }
    NSArray *transitionVCs = @[toVC, fromVC];
    
    // If these two navigationBar `equal`, use system transition behavior.
    if (RRIsUINavigationBarEqual(toVC.rr_navigationBar, fromVC.rr_navigationBar)) {
        for (UIViewController *vc in transitionVCs) {
            vc.rr_navigationBar._rr_transiting = YES;
            vc.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = YES;
        }
        if (!toVC.view.backgroundColor) {
            toVC.view.backgroundColor = fromVC.view.backgroundColor;
            if ([toVC.view.backgroundColor isEqual:UIColor.clearColor]) {
                toVC.view.backgroundColor = UIColor.whiteColor;
            }
        }
        return;
    }
    
    // If cancel pop, needs recover.
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = fromVC.transitionCoordinator;
    __weak typeof(self) weakSelf = self;
    void (^handleCancel)(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) = ^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (context.isCancelled) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf _handleDidShowViewController:fromVC];
            RRLog(@"Pop canceled.");
        }
    };
    if ([transitionCoordinator respondsToSelector:@selector(notifyWhenInteractionChangesUsingBlock:)]) {
        [transitionCoordinator notifyWhenInteractionChangesUsingBlock:handleCancel];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [transitionCoordinator notifyWhenInteractionEndsUsingBlock:handleCancel];
#pragma clang diagnostic pop
    }

    for (UIViewController *vc in transitionVCs) {
        vc.rr_navigationBar._rr_transiting = YES;
        vc.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = NO;
        vc.rr_navigationBar.hidden = NO;
        vc.view.clipsToBounds = NO;
    }
    
    [fromVC viewWillLayoutSubviews];
    if (!toVC.view.backgroundColor) {
        toVC.view.backgroundColor = fromVC.view.backgroundColor;
        if ([toVC.view.backgroundColor isEqual:UIColor.clearColor]) {
            toVC.view.backgroundColor = UIColor.whiteColor;
        }
    }
    
    [self.navigationBar _rr_setAsInvisible:YES];
    
#if INRR
    NSUInteger currentIndex = [toVC.navigationController.viewControllers indexOfObject:fromVC];
    NSUInteger toIndex = [toVC.navigationController.viewControllers indexOfObject:toVC];
    if (!fromVC) { currentIndex = 0; }
    if (currentIndex > toIndex) {
        RRLog(@"will pop to vc with title: %@", toVC.navigationItem.title);
    } else {
        RRLog(@"will push to vc with title: %@", toVC.navigationItem.title);
    }
#endif
}

- (void)_handleDidShowViewController:(UIViewController *)viewController {
    UIViewController *toVC = viewController;
    UIViewController *fromVC = self._visibleTopViewController;
    if (!fromVC) {
        self._visibleTopViewController = toVC;
        return;
    }
    
    NSArray *transitionVCs = @[toVC, fromVC];

    [toVC.rr_navigationBar _apply];
    
    [self.navigationBar _rr_setAsInvisible:NO];
    
    for (UIViewController *vc in transitionVCs) {
        vc.rr_navigationBar._rr_transiting = NO;
        vc.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = NO;
        vc.rr_navigationBar.hidden = YES;
        vc.view.clipsToBounds = YES;
    }
    
    self._visibleTopViewController = toVC;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    RRExcludeImagePicker(navigationController);
    [self _handleWillShowViewController:viewController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    RRExcludeImagePicker(navigationController);
    [self _handleDidShowViewController:viewController];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    RRTRY(
        if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
          return NO;
        }
    );
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    if (self.topViewController.rr_interactivePopGestureRecognizerDisabled) {
        return NO;
    }
    return YES;
}

@end
