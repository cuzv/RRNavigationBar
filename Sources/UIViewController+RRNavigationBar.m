//
//  UIViewController+RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/17/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UIViewController+RRNavigationBar.h"
#import "UINavigationBar+RRNavigationBar_Internal.h"
#import "RRUtils.h"
#import <objc/runtime.h>

@implementation UIViewController (RRNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RRSwizzleInstanceMethod(self.class, @selector(viewWillLayoutSubviews), @selector(_rr_viewWillLayoutSubviews));
    });
}

#pragma mark - Swizzle

- (void)_rr_viewWillLayoutSubviews {
    [self _rr_viewWillLayoutSubviews];
    
    if ([self isKindOfClass:UINavigationController.class] ||
        !self.navigationController ||
        self.rr_navigationBar._rr_equalOtherNavigationBarInTransiting ||
        !self.rr_navigationBar._rr_transiting ||
        !self.isViewLoaded ||
        !self.view.window)
    {
        return;
    }
    
    UIView *_backgroundView = self.navigationController.navigationBar._rr_backgroundView;
    if (!_backgroundView) {
        return;
    }
    
    CGRect relativeRect = [_backgroundView.superview convertRect:_backgroundView.frame toView:self.view];
    if (relativeRect.origin.x != 0) {
        return;
    }
    
    self.rr_navigationBar.frame = relativeRect;
    self.rr_navigationBar.hidden = NO;
    if (!self.rr_navigationBar.superview) {
        [self.view addSubview:self.rr_navigationBar];
    }
    [self.rr_navigationBar.superview bringSubviewToFront:self.rr_navigationBar];
    
    RRLog(@"rr_navigationBar prepared for vc with title: %@", self.navigationItem.title);
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
            self.rr_navigationBar._rr_tmpInfo = [@{} mutableCopy];
        }
    }
    return bar;
}

- (void)setRr_navigationBar:(nonnull UINavigationBar *)rr_navigationBar {
    objc_setAssociatedObject(self, @selector(rr_navigationBar), rr_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    rr_navigationBar._rr_holder = self;
}

- (BOOL)rr_interactivePopGestureRecognizerDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRr_interactivePopGestureRecognizerDisabled:(BOOL)rr_interactivePopGestureRecognizerDisabled {
    objc_setAssociatedObject(self, @selector(rr_interactivePopGestureRecognizerDisabled), @(rr_interactivePopGestureRecognizerDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
