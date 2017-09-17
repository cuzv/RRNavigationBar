//
//  UIViewController+RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/17/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UIViewController+RRNavigationBar.h"
#import "RRUtils.h"
#import "UINavigationBar+RRAddition_Internal.h"
#import <objc/runtime.h>

@implementation UIViewController (RRNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.class == UIViewController.class) {
            RRSwizzleInstanceMethod(self.class, @selector(viewWillLayoutSubviews), @selector(_rr_viewWillLayoutSubviews));
        }
    });
}

#pragma mark - Swizzle

- (void)_rr_viewWillLayoutSubviews {
    [self _rr_viewWillLayoutSubviews];
    [self _rr_addNavigationBarIfNeeded];
}

#pragma mark - Public

- (nonnull UINavigationBar *)rr_navigationBar {
    UINavigationBar *bar = objc_getAssociatedObject(self, _cmd);
    if (bar) {
        return bar;
    }

    UINavigationController *nvc = self.navigationController;
    if (nvc) {
        UINavigationBar *navigationBar = nvc.rr_navigationBar;
        BOOL flag = NO;
        if (!navigationBar) {
            // prevent return nil when present nvc.
            // See UINavigationController+RRNavigationBar.m `_rr_nvc_viewWillLayoutSubviews` for less part logic.
            navigationBar = nvc.navigationBar;
            // mark as temp, will replace after nvc's rr_navigationBar initialized.
            flag = YES;
        }
        if (navigationBar) {
            bar = RRUINavigationBarDuplicate(navigationBar);
            self.rr_navigationBar = bar;
        }
        if (flag) {
            self.rr_navigationBar._tmpInfo = [@{} mutableCopy];
        }
    }
    return bar;
}

- (void)setRr_navigationBar:(nonnull UINavigationBar *)rr_navigationBar {
    objc_setAssociatedObject(self, @selector(rr_navigationBar), rr_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    rr_navigationBar._holder = self;
}

- (BOOL)rr_interactivePopGestureRecognizerDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRr_interactivePopGestureRecognizerDisabled:(BOOL)rr_interactivePopGestureRecognizerDisabled {
    objc_setAssociatedObject(self, @selector(rr_interactivePopGestureRecognizerDisabled), @(rr_interactivePopGestureRecognizerDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private

- (void)_rr_addNavigationBarIfNeeded {
    if (self.rr_navigationBar._rr_equalOtherNavigationBarInTransiting) {
        return;
    }
    if (!self.rr_navigationBar._rr_transiting) {
        return;
    }
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    
    UIView *backgroundView = self.navigationController.navigationBar._rr_backgroundView;
    if (!backgroundView) {
        return;
    }
    
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    if (rect.origin.x != 0) {
        return;
    }
    
    self.rr_navigationBar.frame = rect;
    if (!self.rr_navigationBar.superview) {
        [self.view addSubview:self.rr_navigationBar];
    }
    
    self.rr_navigationBar.hidden = NO;
    [self.rr_navigationBar.superview bringSubviewToFront:self.rr_navigationBar];
}

@end
