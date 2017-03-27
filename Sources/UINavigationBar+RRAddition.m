//
//  UINavigationBar+_RRAddition.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/26/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UINavigationBar+RRAddition.h"
#import <objc/runtime.h>
#import "UIViewController+RRNavigationBar.h"

@implementation UINavigationBar (RRAddition)

- (nullable UIViewController *)_holder {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)set_holder:(nullable UIViewController *)_holder {
    objc_setAssociatedObject(self, @selector(_holder), _holder, OBJC_ASSOCIATION_ASSIGN);
}

- (void)_apply {
    UINavigationBar *navigationBar = self._holder.navigationController.navigationBar;
    if (!navigationBar) {
        return;
    }
    navigationBar.barStyle = self.barStyle;
    navigationBar.translucent = self.translucent;
    navigationBar.tintColor = self.tintColor;
    navigationBar.barTintColor = self.barTintColor;
    navigationBar.backgroundColor = self.backgroundColor;
    navigationBar.shadowImage = self.shadowImage;
    [navigationBar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    navigationBar.alpha = self.alpha;
    navigationBar.rr_forceHidden = self.rr_forceHidden;
}

- (void)setRr_forceHidden:(BOOL)rr_forceHidden {
    if (self.rr_forceHidden == rr_forceHidden) {
        return;
    }
    objc_setAssociatedObject(self, @selector(rr_forceHidden), @(rr_forceHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    Class clazz1 = NSClassFromString(@"_UINavigationBarBackground");
    Class clazz2 = NSClassFromString(@"_UIBarBackground");
    if (!clazz1 && !clazz2) {
        return;
    }
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:clazz1]) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:UIImageView.class] &&
                    CGRectGetHeight(subview.bounds) == 1.0f / UIScreen.mainScreen.scale) {
                    subview.hidden = rr_forceHidden;
                }
            }
        }
        
        if ([view isKindOfClass:clazz2]) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:UIImageView.class] &&
                    CGRectGetHeight(subview.bounds) == 1.0f / UIScreen.mainScreen.scale) {
                    subview.hidden = rr_forceHidden;
                }
            }
        }
    }
    
    if (self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.rr_forceHidden = rr_forceHidden;
    }
}

- (BOOL)rr_forceHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
