//
//  UINavigationBar+_RRAddition.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/26/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UINavigationBar+RRAddition.h"
#import "UINavigationBar+RRAddition_Internal.h"
#import <objc/runtime.h>
#import "UIViewController+RRNavigationBar.h"
#import "_RRWeakAssociatedObjectWrapper.h"
#import "RRUtils.h"

@implementation UINavigationBar (RRAddition)

- (BOOL)_rr_equalOtherNavigationBarInTransiting {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_rr_equalOtherNavigationBarInTransiting:(BOOL)_rr_equalOtherNavigationBarInTransiting {
    objc_setAssociatedObject(self, @selector(_rr_equalOtherNavigationBarInTransiting), @(_rr_equalOtherNavigationBarInTransiting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)_rr_transiting {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_rr_transiting:(BOOL)_rr_transiting {
    objc_setAssociatedObject(self, @selector(_rr_transiting), @(_rr_transiting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable UIViewController *)_holder {
    return ((_RRWeakAssociatedObjectWrapper *)objc_getAssociatedObject(self, _cmd)).object;
}

- (void)set_holder:(nullable UIViewController *)_holder {
    _RRWeakAssociatedObjectWrapper *wrapper = [[_RRWeakAssociatedObjectWrapper alloc] initWithObject:_holder];
    objc_setAssociatedObject(self, @selector(_holder), wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    navigationBar.backIndicatorImage = self.backIndicatorImage;
    navigationBar.backIndicatorTransitionMaskImage = self.backIndicatorTransitionMaskImage;
    navigationBar.rr_forceShadowImageHidden = self.rr_forceShadowImageHidden;
}

- (void)setRr_forceShadowImageHidden:(BOOL)rr_forceShadowImageHidden {
    if (self.rr_forceShadowImageHidden == rr_forceShadowImageHidden) {
        return;
    }
    objc_setAssociatedObject(self, @selector(rr_forceShadowImageHidden), @(rr_forceShadowImageHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    @try {
        [[[self valueForKey:@"_backgroundView"] valueForKey:@"_shadowView"] setHidden:rr_forceShadowImageHidden];
    } @catch (NSException *exception) {
        RRLog(@"NSException happend: %@", exception);
    }

    if (self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.rr_forceShadowImageHidden = rr_forceShadowImageHidden;
    }
}

- (BOOL)rr_forceShadowImageHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
