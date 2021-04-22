//
//  UINavigationController+RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Shaw on 3/25/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import <objc/runtime.h>
#import "UINavigationController+RRNavigationBar.h"
#import "UINavigationController+RRNavigationBar_Internal.h"
#import "UINavigationBar+RRNavigationBar.h"
#import "UINavigationBar+RRNavigationBar_Internal.h"
#import "UIViewController+RRNavigationBar.h"
#import "_RRUtils.h"
#import "_RRWeakObjectBox.h"
#import "UIView+RRNavigationBar_Internal.h"
#import "_RRNavigationControllerDelegateInterceptor.h"

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

void RRNavigationBarExcludeImpactBehaviorForClass(Class _Nonnull nvcClass) {
    if (![nvcClass isSubclassOfClass:UINavigationController.class]) {
        return;
    }
    assert(_excludeNVCClassess);
    [_excludeNVCClassess addObject:nvcClass];
}

void RRNavigationBarExcludeImpactBehaviorForInstance(__kindof UINavigationController *_Nonnull nvc) {
    if (![nvc isKindOfClass:UINavigationController.class]) {
        return;
    }
    assert(_excludeNVCInstance);
    [_excludeNVCInstance addObject:nvc];
}

@interface UINavigationController ()<UIGestureRecognizerDelegate>
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
        RRSwizzleInstanceMethod(self.class, @selector(setDelegate:), @selector(_rr_setDelegate:));
    });
}

#pragma mark - Swizzle

- (void)_rr_nvc_viewDidLoad {
    [self _rr_nvc_viewDidLoad];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _excludeNVCClassess = [NSMutableSet setWithObject:UIImagePickerController.class];
        _excludeNVCInstance = [NSMutableSet new];
    });

    RRExcludeImpactBehaviorFor(self);

    self.delegate = self._delegateInterceptor;
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)_rr_nvc_viewWillLayoutSubviews {
    [self _rr_nvc_viewWillLayoutSubviews];

    RRExcludeImpactBehaviorFor(self);

    if (!self._navigationBarInitialized && self.navigationBar) {
        self.rr_navigationBar = RRUINavigationBarDuplicate(self.navigationBar);
        [self.rr_navigationBar _rr_apply];
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
    NSDictionary *info = toBar._rr_tmpInfo;
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
        RRRecoverObject(fromBar, toBar, info, titleTextAttributes);
        RRRecoverBoolean(fromBar, toBar, info, rr_forceShadowImageHidden);
        toBar._rr_tmpInfo = nil;
    }
}

- (UIStatusBarStyle)_rr_nvc_preferredStatusBarStyle {
    if (self.topViewController) {
        return self.topViewController.preferredStatusBarStyle;
    }
    return self._rr_nvc_preferredStatusBarStyle;
}

- (void)_rr_setDelegate:(id<UINavigationControllerDelegate>)delegate {
    _RRNavigationControllerDelegateInterceptor *interceptor =  self._delegateInterceptor;
    if (delegate != interceptor) {
        interceptor.delegate = delegate;
    }
    [self _rr_setDelegate:interceptor];
}

- (id<UINavigationControllerDelegate>)rr_originalDelegate {
    return self._delegateInterceptor.delegate;
}

#pragma mark - Private

- (nullable UIViewController *)_visibleTopViewController {
    return ((_RRWeakObjectBox *)objc_getAssociatedObject(self, _cmd)).object;
}

- (void)set_visibleTopViewController:(nullable UIViewController *)_visibleTopViewController {
    _RRWeakObjectBox *wrapper = [[_RRWeakObjectBox alloc] initWithObject:_visibleTopViewController];
    objc_setAssociatedObject(self, @selector(_visibleTopViewController), wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)_navigationBarInitialized {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_navigationBarInitialized:(BOOL)_navigationBarInitialized {
    objc_setAssociatedObject(self, @selector(_navigationBarInitialized), @(_navigationBarInitialized), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nonnull _RRNavigationControllerDelegateInterceptor *)_delegateInterceptor {
    _RRNavigationControllerDelegateInterceptor *candidate = objc_getAssociatedObject(self, _cmd);
    if (!candidate) {
        candidate = [_RRNavigationControllerDelegateInterceptor new];
        candidate.delegate = self.delegate;
        objc_setAssociatedObject(self, _cmd, candidate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return candidate;
}

#pragma mark -

- (void)_handleWillShowViewController:(UIViewController *)viewController {
    UIViewController *fromVC = self._visibleTopViewController;
    UIViewController *toVC = viewController;
    NSMutableArray *transitionVCs = [@[] mutableCopy];
    if (fromVC) { [transitionVCs addObject:fromVC]; }
    if (toVC) { [transitionVCs addObject:toVC]; }
    
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
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = fromVC.transitionCoordinator;
    __weak typeof(self) weakSelf = self;
    void (^handleCancel)(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) = ^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (context.isCancelled) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf _handleDidShowViewController:fromVC];
            RRLog(@"Pop canceled.");
        }
    };
    if (@available(ios 10.0, *)) {
        if ([transitionCoordinator respondsToSelector:@selector(notifyWhenInteractionChangesUsingBlock:)]) {
            [transitionCoordinator notifyWhenInteractionChangesUsingBlock:handleCancel];
        }
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
        vc.view._rr_clipsToBounds = vc.view.clipsToBounds;
        vc.view.clipsToBounds = NO;
    }
    
#ifdef __IPHONE_11_0
    if (!fromVC.rr_navigationBar.translucent ||
        !toVC.rr_navigationBar.translucent) {
        for (UIViewController *vc in transitionVCs) {
            // Save current contentInsetAdjustmentBehavior & change to UIScrollViewContentInsetAdjustmentNever
            [self _rr_modifyContentInsetAdjustmentBehaviorIfNeededForViewController:vc];
        }
    }
#endif
    
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
    UIViewController *fromVC = self._visibleTopViewController;
    UIViewController *toVC = viewController;
    NSMutableArray *transitionVCs = [@[] mutableCopy];
    if (fromVC) { [transitionVCs addObject:fromVC]; }
    if (toVC) { [transitionVCs addObject:toVC]; }

    [toVC.rr_navigationBar _rr_apply];
    
    [self.navigationBar _rr_setAsInvisible:NO];
    
    for (UIViewController *vc in transitionVCs) {
        vc.rr_navigationBar._rr_transiting = NO;
        vc.rr_navigationBar._rr_equalOtherNavigationBarInTransiting = NO;
        vc.rr_navigationBar.hidden = YES;
        vc.view.clipsToBounds = vc.view._rr_clipsToBounds;
    }
    
    self._visibleTopViewController = toVC;
    
#ifdef __IPHONE_11_0
    if (!fromVC.rr_navigationBar.translucent ||
        !toVC.rr_navigationBar.translucent) {
        for (UIViewController *vc in transitionVCs) {
            // Restore before contentInsetAdjustmentBehavior
            [self _rr_restoreContentInsetAdjustmentBehaviorIfNeededForViewController:vc];
        }
    }
#endif
    
    RRLog(@"did show vc with title: %@", toVC.navigationItem.title);
}

#ifdef __IPHONE_11_0

- (void)_rr_modifyContentInsetAdjustmentBehaviorIfNeededForViewController:(UIViewController *)vc {
    if (@available(iOS 11.0, *)) {
        if ([vc.view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = ((UIScrollView *)vc.view);
            scrollView._rr_contentInsetAdjustmentBehavior = scrollView.contentInsetAdjustmentBehavior;
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        for (UIView *view in vc.view.subviews) {
            if ([view isKindOfClass:UIScrollView.class]) {
                UIScrollView *scrollView = ((UIScrollView *)view);
                scrollView._rr_contentInsetAdjustmentBehavior = scrollView.contentInsetAdjustmentBehavior;
                scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
    }
}

- (void)_rr_restoreContentInsetAdjustmentBehaviorIfNeededForViewController:(UIViewController *)vc {
    if (@available(iOS 11.0, *)) {
        if ([vc.view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = ((UIScrollView *)vc.view);
            scrollView.contentInsetAdjustmentBehavior = scrollView._rr_contentInsetAdjustmentBehavior;
        }
        for (UIView *view in vc.view.subviews) {
            if ([view isKindOfClass:UIScrollView.class]) {
                UIScrollView *scrollView = ((UIScrollView *)view);
                scrollView.contentInsetAdjustmentBehavior = scrollView._rr_contentInsetAdjustmentBehavior;
            }
        }
    }
}

#endif

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
